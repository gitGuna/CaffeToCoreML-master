# CaffeToCoreML 

<img src="https://user-images.githubusercontent.com/22883945/38160688-2da983e8-34df-11e8-9ab3-7089ae005a79.png" width="100" height="100"/>


Hey'll!
There are a lot of tutorials/ open source projects on how to use **Vision** and **CoreML** frameworks for **Object Detection** in real world using iOS apps using **.mlmodels** given by Apple. But seldom in reality, do we get a **.mlmodel** available suiting our use case. 

**CAFFE** is one of the
most famous Deep Learning frameworks used to train ML models (more details here: http://caffe.berkeleyvision.org)

Here, I took up a **Caffe model for the Oxford 102 flower dataset**, which was converted to **CoreML model** using **coremltools python package**.

`oxford102.caffemodel` can be downloaded at https://drive.google.com/uc?export=download&confirm=PXEh&id=0B0HbJVlOlJ3SVVNyMDQwR3FRYWc . Please not that along with `oxford102.caffemodel`, we will also need `flower-labels.txt` and `deploy.prototxt` files in order to successfully **convert .caffemodel to .mlmodel** 

Also note that this conversion from `.caffemodel to .mlmodel` is only possible with `**Python2.7**`



Once downloaded the above mentioned three files, here are the steps used for conversion:

1) Put all the three downloaded files in a folder, say FlowerClassifier.
2) Add a python file, say convert-script.py in the same folder.
3) Add the script below to your convert-script.py file.

```
import coremltools

caffe_model = ('oxford102.caffemodel', 'deploy.prototxt')
labels  = 'flower-labels.txt'

coreml_model = coremltools.converters.caffe.convert(
caffe_model,
class_labels = labels,
image_input_names = 'data'
)

coreml_model.save('FlowerClassifier.mlmodel')
```

4) Now, launch Terminal in your Mac, activate Python2.7 using command ```source python27/bin/activate```

5) Then cd into your folder (***FlowerClassifier***)
6) Then run the script using command ```python convert-script.py```.

Voila! 2-3 minutes later you will have your FlowerClassifier.ml model present in your FlowerClassifier folder. 
<p align="center">
  <img src="https://user-images.githubusercontent.com/22883945/38160668-0b08a2a6-34df-11e8-8728-cffdaa65e4d8.png" width="200" height="400"/>
  <img src="https://user-images.githubusercontent.com/22883945/38160669-0b457ff0-34df-11e8-9b9a-b815e6e37608.png" width="200" height="400"/>
  <img src="https://user-images.githubusercontent.com/22883945/38160670-0b84bf44-34df-11e8-8056-89f8ccaf115a.png" width="200" height="400"/>
  <img src="https://user-images.githubusercontent.com/22883945/38160671-0bc98020-34df-11e8-83d4-f9317a95230f.png" width="200" height="400"/>
</p>





