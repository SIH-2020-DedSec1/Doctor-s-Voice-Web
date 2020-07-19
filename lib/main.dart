import 'dart:async';

import 'package:doctors_voice_mobile/curvesAnimation.dart';
import 'package:doctors_voice_mobile/dashboard.dart';
import 'package:doctors_voice_mobile/forgot_password.dart';
import 'package:doctors_voice_mobile/register_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(LoginOrDashboard());
}


BuildContext globalContext;

class LoginOrDashboard extends StatelessWidget {

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doctor's Voice",
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginOrDashboardStateful(title: "Login"),
    );
  }
}

class LoginOrDashboardStateful extends StatefulWidget {
  LoginOrDashboardStateful({Key key, this.title}) : super(key: key);

  final String title;

  

  @override
  LoginOrDashboardState createState() => LoginOrDashboardState();
}

class LoginOrDashboardState extends State<LoginOrDashboardStateful> with TickerProviderStateMixin {


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailId = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool isLoadingDone = true;

 void initState() {
   super.initState();

    _auth.currentUser().then((value) {

    if(value != null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Dashboard(firebaseUser: value,),), (route) => false);
    } else {
    Timer(Duration(seconds: 1), () {
      isLoadingDone = !isLoadingDone;
      setState(() {
        
      });
    });

    }
    }) ;

    
  }

  @override
  Widget build(BuildContext context) {


    globalContext = context;


    return isLoadingDone ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator(),),
        ],
      ),
    ) : Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(children: [

        CustomPaint(
      painter: LoginPainter(),
      size: MediaQuery.of(context).size,
    ),

Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            padding: EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
            child: Text("Login",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
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
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: TextField(
                      controller: emailId,
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
                    child: TextField(
                      controller: password,
                      
                      obscureText: true,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password"
                      ),
                    ),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      elevation: 4.0,
      color: Colors.green,
                      onPressed: () {

                        FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId.text, password: password.text).then((value) {

                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Dashboard(firebaseUser: value.user)));

                        }).catchError((onError) {

                        });


                      },
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Login", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      color: Colors.white,
                      elevation: 0.0,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new RegisterUser(context: globalContext,)));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Register"),
                      ),
                    ),
                  ),
                    ],
                  ),


                  Padding(
                    
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
                    child: 
                  InkWell(
                    onTap: () {
                      
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new ForgotPassword(context: globalContext,)));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text("Forgot Password?"),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                elevation: 4.0,
                color: Colors.pink,
              shadowColor: Colors.black,
                child: InkWell(
                  onTap: () {

                  _handleSignIn()
                    .then((FirebaseUser user) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Dashboard(firebaseUser: user,)));
                    })
                    .catchError((e) => print(e));



                  },
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


      ],),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);
  return user;
}
}