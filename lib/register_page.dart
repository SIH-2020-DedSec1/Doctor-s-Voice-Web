import 'package:cloud_firestore/cloud_firestore.dart';
import 'curvesAnimation.dart';
import 'main.dart';
import 'uploading_documents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterUser extends StatelessWidget {
  RegisterUser({Key key, this.context}) : super(key: key);

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
      home: RegisterUserStateful(title: "Register"),
    );
  }
}

class RegisterUserStateful extends StatefulWidget {
  RegisterUserStateful({Key key, this.title, this.context}) : super(key: key);

  final String title;
  final BuildContext context;

  @override
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUserStateful> with TickerProviderStateMixin {

  bool isCheckBoxChecked = false;

  TextEditingController emailID = new TextEditingController();
  TextEditingController passwordC = new TextEditingController();
  TextEditingController confirm = new TextEditingController();
  TextEditingController displayName = new TextEditingController();

  TextEditingController hospitalName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Stack(
          alignment: Alignment.center,
          children: [



        CustomPaint(
      painter: RegisterPainter(),
      size: MediaQuery.of(context).size,
    ),



            Container(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Center(
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
            padding: EdgeInsets.all(20.0),
            child: Container(
            ),
          ),


          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            child: IconButton(
              color: Colors.black,
          onPressed: () {

                Navigator.of(globalContext).pop();
          },
          icon: Icon(Icons.chevron_left, color: Colors.white,),
          ),
          ),

Padding(
            padding: EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
            child: Text("Register",
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
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: TextField(
                      controller: displayName,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Name"
                      ),
                    ),
                  ),





                Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: TextField(
                      controller: hospitalName,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Hospital Name"
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: TextField(
                      controller: passwordC,
                      
                      obscureText: true,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password"
                      ),
                    ),
                  ),

                    Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: TextField(
                      controller: confirm,
                      
                      obscureText: true,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Confirm Password"
                      ),
                    ),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: 
                      Checkbox(
                        value: isCheckBoxChecked,
                        onChanged: (val) {
                          setState(() {
                          isCheckBoxChecked = val;
                          });
                        },
                        
                      ),
                        ),
                      ),



                      Flexible(
                        flex: 5,
                        child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
                          child: Text("By checking this, you agree to our T&C and Privacy policy"),
                        ),
                      ),
                    ],
                  ),
Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      elevation: 8.0,
      color: Colors.blue.shade900,
                      onPressed: () {



                        if(isCheckBoxChecked && passwordC.text == confirm.text) {



                           showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Processing"),
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),

          ],
        ),
        
      ),
    );


                          FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailID.text, password: confirm.text).then((value) {
                            UserUpdateInfo updateInfo = UserUpdateInfo();
                            updateInfo.displayName = displayName.text;
                            value.user.updateProfile(updateInfo);

                            Firestore.instance.collection('doctors').document(value.user.email).collection('personal_info').document('data').setData({
                              'doctorName': displayName.text,
                              'hospitalName': hospitalName.text,
                            }).then((x) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => new UploadingDocuments(firebaseUser: value.user,)));

                            });


                          }).catchError((onError) {

                          });
                        }
                      },
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Text("Continue with uploading documents", style: TextStyle(color: Colors.white),),
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
