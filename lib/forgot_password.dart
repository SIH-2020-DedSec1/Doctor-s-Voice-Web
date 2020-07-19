import 'curvesAnimation.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key key, this.context}) : super(key: key);

  final BuildContext context;


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Doctor's Voice",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ForgotPasswordStateful(title: "Register"),
    );
  }
}

class ForgotPasswordStateful extends StatefulWidget {
  ForgotPasswordStateful({Key key, this.title, this.context}) : super(key: key);

  final String title;
  final BuildContext context;

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordStateful> with TickerProviderStateMixin {

  bool isCheckBoxChecked = false;

  TextEditingController emailID = new TextEditingController();

  final snackBar = SnackBar(
    content: Text('Password Reset mail sent Successfully.'), 
  action: SnackBarAction(
    label: 'Dismiss',
    onPressed: () {

    },
  ),);


  final _scaffoldKey = GlobalKey<ScaffoldState>(); 


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Stack(
          alignment: Alignment.center,
          children: [





          CustomPaint(
            painter: ForgotPasswordPainter(),
            size: MediaQuery.of(context).size,
          ),


            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          







          Padding(
            padding: EdgeInsets.all(36.0),
            child: Container(
            ),
          ),



          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            child: IconButton(
              color: Colors.white,
          onPressed: () {

                Navigator.of(globalContext).pop();
          },
          icon: Icon(Icons.chevron_left),
          ),
          ),

Padding(
            padding: EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
            child: Text("Forgot Password?",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              color: Colors.white,
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
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: TextField(
                      controller: emailID,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Email ID"
                      ),
                    ),
                  ),


                    Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      elevation: 8.0,
                      color: Colors.amber.shade900,
                          onPressed: () {

                          FirebaseAuth.instance.sendPasswordResetEmail(email: emailID.text).then((value) {
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          });

                      },
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Text("Send Password Reset link", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),


                ],
              ),
            ),
            ),




            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                color: Colors.pink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                elevation: 4.0,
              shadowColor: Colors.indigo,
                child: InkWell(
                  onTap: () {},
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                      children: [
                        Image.network("https://img.icons8.com/bubbles/2x/google-logo.png", width: 50, height: 50,),

                        Text("Continue with Google", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                      ],
                    ),
                    ),
                  ],
                ),
                ),
              ),
            ),
        ],
      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
