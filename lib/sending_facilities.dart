import 'dart:async';
import 'dart:html';

import 'new_patient.dart';
import 'twilio_whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';


class SendingFacilities extends StatelessWidget {
  SendingFacilities({Key key, this.title}) : super(key: key);

final String title;


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Doctor's Voice",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SendingFacilitiesStateful(title: title ),
    );
  }
}

class SendingFacilitiesStateful extends StatefulWidget {
  SendingFacilitiesStateful({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SendingFacilitiesState createState() => SendingFacilitiesState();
}

class SendingFacilitiesState extends State<SendingFacilitiesStateful> with TickerProviderStateMixin {


  final snackBar = SnackBar(
    content: Text('PDF link sent successfully'), 
  );

  bool isMobileNumberChecked = false;
  bool isWhatsAppNumberChecked = false;
  bool isEmailChecked = false;


  final _scaffoldKey = GlobalKey<ScaffoldState>(); 


  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController whatsappNumber = new TextEditingController();
  TextEditingController emailThing = new TextEditingController();



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [


              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: 
              Align(
                alignment: Alignment.topRight,
                child: 
              Icon(Icons.send, color: Colors.green, size: 250.00,),
              ),
              ),




            Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [





          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: Colors.black,), onPressed: () {
                Navigator.of(buildContextOfNewPatient).pop();
        },),
            ],
          ),
          ),
        



          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 16.0),
            child: Text("Send the document",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.black
              ),
            ),
          ),






            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 2.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: 
                  Text("Choose aleast one", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                  ),

                  



                  Row(
                    children: [


                      Flexible(
                        flex: 1,
                        child: 
                      Checkbox(
                        onChanged: (value) {
                          isMobileNumberChecked = value;
                          setState(() {
                            
                          });
                        },
                        value: isMobileNumberChecked,
                      ),
                      ),

                    Flexible(
                      flex: 7,
                      child: 
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      enabled: true,
                      controller: mobileNumber,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                    ),
                  ),
                    ),





                    ],
                  ),








                  Row(
                    children: [


                      Flexible(
                        flex: 1,
                        child: 
                      Checkbox(
                        onChanged: (value) {
                          isWhatsAppNumberChecked = value;
                          setState(() {
                            
                          });
                        },
                        value: isWhatsAppNumberChecked,
                      ),
                      ),



                      Flexible(
                        flex: 7,
                        child: 
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      enabled: true,
                      controller: whatsappNumber,
                      decoration: InputDecoration(
                        labelText: "WhatsApp number",
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                      ),
                    ),
                  ),
                      ),






                    ],
                  ),









                  Row(
                    children: [


                      Flexible(
                        flex: 1,
                        child: 
                      Checkbox(
                        onChanged: (value) {
                          isEmailChecked = value;
                          setState(() {
                            
                          });
                        },
                        value: isEmailChecked,
                      ),
                      ),


                Flexible(
                  flex: 7,
                  child: 
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      enabled: true,
                      controller: emailThing,
                      decoration: InputDecoration(
                        labelText: "Email ID",
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ),
                ),




                    ],
                  ),




                    Center(
                      child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        color: Colors.green,
                        onPressed: !isEmailChecked && !isMobileNumberChecked && !isWhatsAppNumberChecked ? null : () {


                              if(isMobileNumberChecked) {


                                  var client = new MyTwilio("AC5b032366794305eba7f1d1d24883aa82", "19c15cb5c1ec3ce4070619df3261b5cc");

                                  client.messages.create({
                                    'body': "Here's the link to the Doctor's Voice Prescription: ${widget.title}",
                                    'from': '+14155238886', // a valid Twilio number
                                    'to': '+91${mobileNumber.text}' // your phone number
                                  }).then((value) {

                            _scaffoldKey.currentState.showSnackBar(snackBar);
                                    Timer(Duration(seconds: 1), () {

                                        Navigator.of(globalContext).pop();
                                    });
                                  });

                                /**
                                 * 
                                 * curl 'https://api.twilio.com/2010-04-01/Accounts/AC5b032366794305eba7f1d1d24883aa82/Messages.json' -X POST \
--data-urlencode 'To=+918919586332' \
--data-urlencode 'From=+13345185009' \
-u AC5b032366794305eba7f1d1d24883aa82:19c15cb5c1ec3ce4070619df3261b5cc



                                 */
                              } 
                               if(isWhatsAppNumberChecked) {


                                  var client = new MyTwilio("AC5b032366794305eba7f1d1d24883aa82", "19c15cb5c1ec3ce4070619df3261b5cc");

                                  client.messages.create({
                                    'body': "Here's the link to the Doctor's Voice Prescription: ${widget.title}",
                                    'from': 'whatsapp:+14155238886', // a valid Twilio number
                                    'to': 'whatsapp:+91${whatsappNumber.text}' // your phone number
                                  }).then((value) {
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                                    Timer(Duration(seconds: 1), () {

                                        Navigator.of(globalContext).pop();
                                    });
                                  }).catchError((onError) {
                                    print(onError.toString());
                                  });

                                


                                /**
                                 * 
                                 * 
                                 * curl 'https://api.twilio.com/2010-04-01/Accounts/AC5b032366794305eba7f1d1d24883aa82/Messages.json' -X POST \
--data-urlencode 'To=whatsapp:+918801853078' \
--data-urlencode 'From=whatsapp:+14155238886' \
--data-urlencode 'Body=Your Yummy Cupcakes Company order of 1 dozen frosted cupcakes has shipped and should be delivered on July 10, 2019. Details: http://www.yummycupcakes.com/' \
-u AC5b032366794305eba7f1d1d24883aa82:19c15cb5c1ec3ce4070619df3261b5cc


                                 */


                              } 
                              
                               if(isEmailChecked) {

                                String emailId = emailThing.text;

                                _launchURL(emailId, "Doctor's Voice Notification", "URL link to the Doctor's Prescription.                                  ${widget.title}\n\nSupport Team,\nDoctor's Voice.");

                              }
                        },
                        child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Proceed to sending PDF", style: TextStyle(color: Colors.white, fontSize: 16.0),),
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
          ],
        ),
      ),
    );
  }





  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  
}
