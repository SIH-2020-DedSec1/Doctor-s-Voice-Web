import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

void main() {
  runApp(UploadingDocuments(firebaseUser: null,));
}

class UploadingDocuments extends StatelessWidget {


  UploadingDocuments({Key key, this.firebaseUser}) : super(key: key);
  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doctor's Voice",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UploadingDocumentsStateful(firebaseUser: firebaseUser,),
    );
  }
}

class UploadingDocumentsStateful extends StatefulWidget {
  
  UploadingDocumentsStateful({Key key, this.firebaseUser}) : super(key: key);
  final FirebaseUser firebaseUser;

  @override
  UploadingDocumentsState createState() => UploadingDocumentsState();
}

class UploadingDocumentsState extends State<UploadingDocumentsStateful> with TickerProviderStateMixin {

  bool isCheckBoxChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          
          // Center(
          //   child: Text("Doctor's Voice",
          //     style: TextStyle(fontFamily: 'Manrope',
          //     fontSize: 24.0,
          //     fontWeight: FontWeight.w700
          //     ),
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.all(32.0),
            child: Container(),
          ),



          Padding(
            padding: EdgeInsets.fromLTRB(24.0, 36.0, 16.0, 16.0),
            child: Text("Uploading Documents",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              color: Colors.black,
              fontWeight: FontWeight.w700
              ),
            ),
          ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.black,
              child: Column(
                children: [



                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                    child: Card(
                      color: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Since this is test version, no verification documents are required.", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),




                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                    child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      elevation: 8.0,
      color: Colors.blue.shade700,
                      onPressed: () {

                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Dashboard(firebaseUser: widget.firebaseUser,)));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                        child: Text("Go to Dashboard", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),

                 
                    ],
                  ),

                ],
              ),
            ),
            ),




        ],
      ),
          ),
        ),
      ),
    );
  }
}
