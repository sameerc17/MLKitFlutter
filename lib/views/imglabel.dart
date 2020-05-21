import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(
      home: ImgLabel(),
    ));

class ImgLabel extends StatefulWidget {
  @override
  _ImgLabelState createState() => _ImgLabelState();
}

String ans="";
bool loading=true;

class _ImgLabelState extends State<ImgLabel> {

  File _image;

  getter(File image) async {
    ans = await predictText(image);
    setState(() {});
  }

  Future<String> predictText(File image) async{
    String f="";
    if(image!=null){
      final File imageFile = image;
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
      final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
      final List<ImageLabel> labels = await labeler.processImage(visionImage);
      for (ImageLabel label in labels) {
        final String text = label.text;
        final String entityId = label.entityId;
        final double confidence = label.confidence;
        f+="I am "+(confidence*100).toString()+" % sure that there is a "+text+".\n";
      }
      setState(() {
        loading=false;
      });
      labeler.close();
    }
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
        backgroundColor: Color(0xf0e65c00),
        title: Text(
          'MLKit for flutter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
          Icons.mobile_screen_share,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: <Widget>[
                Container(
                    color: Colors.white,
                    child: _image == null
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tap on the icon below to capture an image you want to label.',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : Image.file(_image)),
                SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: FloatingActionButton(
                    child: Icon(Icons.camera),
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                    color: Colors.white,
                    child: _image == null
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Detected entities from your image will be displayed here.',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : checker()),
              ],
            ),
          ),
        ),
      ),

    );
  }
  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = image;
    });
    getter(_image);
  }

  Widget checker() {
    if (!loading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$ans',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }

}
