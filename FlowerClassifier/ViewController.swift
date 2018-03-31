//
//  ViewController.swift
//  FlowerClassifier
//
//  Created by gunm on 31/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SwiftyJSON
import Alamofire
import SDWebImage
import ColorThiefSwift

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var pickedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert image to CIImage.")
            }
            
            pickedImage = userPickedImage
            
            
            detect(flowerImage: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func detect(flowerImage: CIImage) {
        
        
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Can't load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            
            self.navigationItem.title = result.identifier.capitalized
            
            self.requestInfo(flowerName: result.identifier)
            
        }
        
        let handler = VNImageRequestHandler(ciImage: flowerImage)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
        
    }
    
    func requestInfo(flowerName: String) {
        let parameters : [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : flowerName, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]

        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let flowerJSON : JSON = JSON(response.result.value!)
                
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                let flowerImageURL = flowerJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                self.infoLabel.text = flowerDescription
                
                self.imageView.sd_setImage(with: URL(string: flowerImageURL), completed: { (image, error,  cache, url) in
                    
                    if let currentImage = self.imageView.image {
                        
                        guard let dominantColor = ColorThief.getColor(from: currentImage) else {
                            fatalError("Can't get dominant color")
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.navigationController?.navigationBar.isTranslucent = true
                            self.navigationController?.navigationBar.barTintColor = dominantColor.makeUIColor()
                            
                            
                        }
                    } else {
                        self.imageView.image = self.pickedImage
                        self.infoLabel.text = "Could not get information on flower from Wikipedia."
                    }
                    
                })
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.infoLabel.text = "Connection Issues"
                
                
                
            }
        }
    }
    
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
}

