import 'dart:collection';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(
      MaterialApp(home: Textrec()),
    );

class Textrec extends StatefulWidget {
  @override
  _TextrecState createState() => _TextrecState();
}

String ans = "";
bool loading = true;

class _TextrecState extends State<Textrec> {
  LinkedHashSet<String> linkedHashSet = LinkedHashSet();
  File _image;

  getter(File image) async {
    ans = await predictText(image);
    setState(() {});
  }

  Future<String> predictText(File img) async {
    String f = "";
    if (img != null) {
      final File imageFile = img;
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(imageFile);
      final TextRecognizer textRecognizer =
          FirebaseVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      String text = visionText.text;
      for (TextBlock block in visionText.blocks) {
        final Rect boundingBox = block.boundingBox;
        final List<Offset> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<RecognizedLanguage> languages = block.recognizedLanguages;

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
            if (!linkedHashSet.contains(text)) f += text;
            linkedHashSet.add(text);
          }
          f += "\n";
        }
      }
//      for(String s in linkedHashSet)
//        f+=s;
      setState(() {
        loading = false;
      });
      textRecognizer.close();
    }
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      appBar: AppBar(
//            actions: <Widget>[
//              Padding(
//                  padding: EdgeInsets.only(right: 10.0),
//                  child: GestureDetector(
//                    onTap: () {},
//                    child: Icon(
//                      Icons.search,
//                    ),
//                  )
//              ),
//            ],
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
                              'Tap on the icon below to capture an image of your text.',
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
                              'Detected text from your image will be displayed here.',
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
