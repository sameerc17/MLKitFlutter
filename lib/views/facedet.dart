import 'dart:io';
import 'dart:math';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(
      MaterialApp(
        home: FaceDet(),
      ),
    );

class FaceDet extends StatefulWidget {
  @override
  _FaceDetState createState() => _FaceDetState();
}

String ans = "";
bool loading = true;

class _FaceDetState extends State<FaceDet> {
  File _image;

  getter(File image) async {
    ans = await predictText(image);
    setState(() {});
  }

  Future<String> predictText(File image) async {
    String f = "";
    if (image != null) {
      final File imageFile = image;
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(imageFile);
      final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.fast,
            enableLandmarks: true,
            enableClassification: true,
            enableContours: true,
            minFaceSize: 0.1),
      );
      final List<Face> faces = await faceDetector.processImage(visionImage);
      for (Face face in faces) {
        final Rect boundingBox = face.boundingBox;

        final double rotY =
            face.headEulerAngleY;
        final double rotZ =
            face.headEulerAngleZ;

        if(face.leftEyeOpenProbability<0.2)
          f+="Your left eye seems to be closed\n";
        else
          f+="Your left eye seems to be open\n";

        if(face.rightEyeOpenProbability<0.2)
          f+="Your right eye seems to be closed\n";
        else
          f+="Your right eye seems to be open\n";

        if (face.smilingProbability != null) {
          final double smileProb = face.smilingProbability;
          f+="On a scale of 100, your smile gets "+(smileProb*100).round().toString()+".\n";
        }

//        if (face.trackingId != null) {
//          final int id = face.trackingId;
//        }
          f+="Have a nice day !\n";
      }
      setState(() {
        loading = false;
      });
      faceDetector.close();
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
                              'Tap on the icon below to capture an image you want to detect faces in.',
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
                              'Detected information from your image will be displayed here.',
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
