import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mlkit/views/barrec.dart';
import 'package:mlkit/views/imglabel.dart';
import 'package:mlkit/views/textrec.dart';

import 'views/facedet.dart';

void main() => runApp(
  MaterialApp(
    home: Scaffold(
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
      body: Home(),
    ),
  ),
);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xffada996),
//            Color(0xfff2f2f2),
            Color(0xffdbdbdb),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          print('Clicked');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Textrec()),
                          );
                        },
                        child: Text(
                          "Click here to recognize text in an image",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xd5e65c00),
                            Color(0xffF9D423),
                          ],
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          print('Clicked');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImgLabel()),
                          );
                        },
                        child: Text(
                          "Click here to recognize entities in an image",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xd5e65c00),
                            Color(0xffF9D423),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BarRec()),
                          );
                        },
                        child: Text(
                          "Click here to scan a Barcode/ QR code (under development)",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xd5e65c00),
                            Color(0xffF9D423),
                          ],
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FaceDet()),
                          );
                        },
                        child: Text(
                          "Click here to detect faces in an image",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xd5e65c00),
                            Color(0xffF9D423),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
