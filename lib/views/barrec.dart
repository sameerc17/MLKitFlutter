import 'dart:io';
import 'dart:math';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() =>
    runApp(
      MaterialApp(
        home: BarRec(),
      ),
    );

class BarRec extends StatefulWidget {
  @override
  _BarRecState createState() => _BarRecState();
}

String ans = "";
bool loading = true;

class _BarRecState extends State<BarRec> {

  File _image;

  getter(File image) async {
    ans = await predictText(image);
    setState(() {});
  }

  Future<String> predictText(File image) async {
    String f="";
    if(image!=null){
      final File imageFile =image;
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
      final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);
      for (Barcode barcode in barcodes) {
        final Rect boundingBox = barcode.boundingBox;
        final List<Offset> cornerPoints = barcode.cornerPoints;

        final String rawValue = barcode.rawValue;

        final BarcodeValueType valueType = barcode.valueType;

        // See API reference for complete list of supported types
        switch (valueType) {
          case BarcodeValueType.wifi:
            final String ssid = barcode.wifi.ssid;
            final String password = barcode.wifi.password;
            final BarcodeWiFiEncryptionType type = barcode.wifi.encryptionType;
            f="ssid: "+ssid+"\npassword: "+password+"\nencryption type: "+type.toString()+"\n";
            break;
          case BarcodeValueType.url:
            final String title = barcode.url.title;
            final String url = barcode.url.url;
            f="title: "+title+"\nurl: "+url+"\n";
            break;
          default:
            break;
        }
      }
      setState(() {
        loading=false;
      });
      barcodeDetector.close();
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
                        'Tap on the icon below to capture a code you want to scan.',
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
