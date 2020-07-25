
@JS()
library typed_callback.web;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'recorder_thing.dart';
import 'curvesAnimation.dart';
import 'dashboard.dart';
import 'sending_facilities.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:html' as html;
import 'dart:js' as js;



import 'package:js/js.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show rootBundle;

Future<ByteData> loadAsset() async {
  return await rootBundle.load('assets/dv.png');
}


String transcription;

class NewPatient extends StatelessWidget {
  NewPatient({Key key, this.firebaseUser,}) : super(key: key);
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
      home: NewPatientStateful(),
    );
  }

}

class NewPatientStateful extends StatefulWidget {
  NewPatientStateful({Key key, this.firebaseUser,}) : super(key: key);
  final FirebaseUser firebaseUser;

  @override
  State<StatefulWidget> createState() => new NewPatientState();

}


BuildContext buildContextOfNewPatient;
class NewPatientState extends State<NewPatientStateful> with TickerProviderStateMixin{

  final pdf = pw.Document();

  WebRecorder webRecorder;
  bool isRecording;

  String dateTime = DateFormat('yyyy-MM-dd_kk:mm').format(DateTime.now());

  TextEditingController patientNameController = new TextEditingController();
  TextEditingController patientGenderController = new TextEditingController();
  TextEditingController patientAgeController = new TextEditingController();
  TextEditingController uniqueId = new TextEditingController();
  TextEditingController symptomsP = new TextEditingController();
  TextEditingController diagnosisP = new TextEditingController();
  TextEditingController prescP = new TextEditingController();
  TextEditingController advicesP = new TextEditingController();

  Uint8List imageForPdf;

  FirebaseUser firebaseUserThing;

  String hospitalName;

  whenRecorderStart(){
    print('Recorder Started');
    setState(() {}); 
  }

  whenRecorderStop(){
    print('Recorder Stopped'); 
    setState(() {}); 
  }

  whenRecorderResult(data) {


      http.post(
        "https://api.eu-gb.speech-to-text.watson.cloud.ibm.com/instances/062d6fda-ee57-430d-b1df-a99d8901cc2c/v1/recognize",
        headers : {
          "Accept" : "application/json", 
          "Authorization" : "Basic " + base64.encode(utf8.encode("apikey:lhCmK873A3w9VGXUX4CEFH5YmwIvlpQoiOSXIebPEyYf")),
          "Content-Type" : "audio/webm",
        },
        body : data,
      ).then((value) {

        print(value.body);
      var dataObject = jsonDecode(value.body);
      transcription = dataObject["results"][0]["alternatives"][0]["transcript"];


    totalTranscript = totalTranscript + "[DOCTOR]: " + transcription + "\n";

    String actualInfo = "";
    List<String> transcriptParsed = transcription.split(" ");
    List<String> modString = transcriptParsed.sublist(2);
    modString.forEach((element) {
      actualInfo = actualInfo  + element + " ";
    });

      if(transcriptParsed[0] == 'put') {
        print("Given order :  Adding an element");


      switch(transcriptParsed[1]) {
        case 'name': patientNameController.text = actualInfo; break;
        case 'age': patientAgeController.text = transcriptParsed[2]; break;
        case 'gender': patientGenderController.text = transcriptParsed[2]; break;
        case 'symptom': symptomsP.text == "" ? symptomsP.text = actualInfo : symptomsP.text = symptomsP.text + ", " + actualInfo; print(symptomsP.text); break;
        case 'diagnosis': diagnosisP.text == "" ? diagnosisP.text = actualInfo : diagnosisP.text = diagnosisP.text + ", " + actualInfo; break;
        case 'prescription': prescP.text == "" ? prescP.text = actualInfo : prescP.text = prescP.text + ", " + actualInfo; break;
        case 'advice': advicesP.text == "" ? advicesP.text = actualInfo : advicesP.text = advicesP.text + ", " + actualInfo; break;
        default : break;
      }


      } else if(transcriptParsed[0]  == 'remove') {
        print("Given order: Removing an element");


      switch(transcriptParsed[1]) {
        case 'name': patientNameController.text = ""; break;
        case 'age': patientAgeController.text = ""; break;
        case 'gender': patientGenderController.text = ""; break;
        case 'symptoms': symptomsP.text = "";  break;
        case 'diagnosis': diagnosisP.text = ""; break;
        case 'prescription': prescP.text = ""; break;
        case 'advice': advicesP.text = ""; break;
        default : break;
      }



      } else if(transcriptParsed[0]  == "modify") {
        print("Given order: modifying the element");


      switch(transcriptParsed[1]) {
        case 'name': patientNameController.text = actualInfo; break;
        case 'age': patientAgeController.text = transcriptParsed[2]; break;
        case 'gender': patientGenderController.text = transcriptParsed[2]; break;
        case 'symptom': symptomsP.text = actualInfo;  break;
        case 'diagnosis': diagnosisP.text = actualInfo; break;
        case 'prescription': prescP.text = actualInfo; break;
        case 'advice': advicesP.text = actualInfo; break;
        default : break;
                 }

              }


setState(() {
  
});

      }).catchError((onError) {
        print(onError.toString());
      });

  }


  void initState() {
    super.initState();

  webRecorder = WebRecorder(
    whenRecorderStart: whenRecorderStart,
    whenRecorderStop: whenRecorderStop,
    whenReceiveData:  whenRecorderResult,
  );
  
    uniqueId.value = TextEditingValue(
      text: "DV-",
      selection: TextSelection.fromPosition(
        TextPosition(offset: 3),
      ),
    );

    FirebaseAuth.instance.currentUser().then((value) {
        firebaseUserThing = value;

        Firestore.instance.collection('doctors').document(value.email).collection('personal_info').document('data').get().then((value) {
          hospitalName = value['hospitalName'];
        });
        
        
    });

    loadAsset().then((value) {
      var buffer = value.buffer;
      imageForPdf = buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
    });

  }

  String totalTranscript = "";


  bool isClicked = false;
  Widget showHelpCard() {
    return Container(
      child: Padding(
      
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Card(
        color: Colors.green.shade900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isClicked ? [

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("'put name Nani'", style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("The above statement adds the name 'Nani' into the field 'Patient name'", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),

//,  and 
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("We can also perform",  style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'put': adds the given value to the respective field", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'remove': Removes everything from a field", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'modify': Erases the whole field and adds the given element", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Fields supported", style: TextStyle(fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'name': Patient Name", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'age': Patient age (only number required)", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'gender': Patient gender(male / female)", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'symptom': Symptoms", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'diagnosis': Diagnosis", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'prescription': Prescription", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'advice': Advices", style: TextStyle( fontSize: 16.0,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("(fields requiring multiple values should be added one by one)", style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700,color: Colors.white)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("Mobile number can't be typed through voice (as a security measure). Please input mobile number using keyboard.", style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700,color: Colors.white)),
            ),



          ] : [],
        ),
    ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    buildContextOfNewPatient = context;

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        heroTag: "HelpForNewPatientAdd",
        backgroundColor: Colors.green.shade900,
        onPressed: () {
          isClicked = !isClicked;
          setState(() {
            
          });

        },
        child: Icon(Icons.help),
      ),
             
      body: SingleChildScrollView(
        child: Stack(
          children: [


        CustomPaint(
      painter: NewPatientPainter(),
      size: MediaQuery.of(context).size,
    ),



          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: Colors.white), onPressed: () {
                Navigator.of(globalContext).pop();
        },),
            ],
          ),
          ),



            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [


        
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(),
          ),


        
            Padding(

            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text("New Patient (or) Existing Patient Entry",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
              ),
            ),

              ),


            AnimatedSize(
              curve: Curves.linear,
              vsync: this,
              key: Key("AnimationOfHelpCard"),
              duration: Duration(milliseconds: 100),
              child: showHelpCard(),
            ),

            
           



            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: FloatingActionButton.extended(
             isExtended: true,
             elevation: 16.0,
             backgroundColor: isRecording ? Colors.red.shade700 : Colors.green.shade700,
             onPressed: () {
              isRecording = !isRecording;


              webRecorder.openRecorder();





              setState(() {

              });
          
             }, 
             label: isRecording ? Text("Stop", style: TextStyle(
               fontFamily: 'Manrope',
               fontSize: 16.0,
               fontWeight: FontWeight.w700,
              ),
            ) : Text("Recognize", style: TextStyle(
               fontFamily: 'Manrope',
               fontSize: 16.0,
               fontWeight: FontWeight.w700,
              ),
            ),
            icon: isRecording ? Icon(Icons.stop) : Icon(Icons.record_voice_over),
            ),
              ),
            ),




            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                            children: [

                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                            child: isRecording ? Icon(Icons.keyboard_voice): Icon(Icons.play_arrow),
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: isRecording ? Text("Listening", style: TextStyle(fontSize: 18.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),)
                            : Text("Ready to listen", style: TextStyle(fontSize: 18.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                          ),


                            ],
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: 
                             Text("", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            ),






            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.grey.shade800,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: 
                        Text("Transcript", style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                            ),
                          ),


                        Text(totalTranscript, style: TextStyle(fontSize: 16.0, color: Colors.white,fontFamily: 'Manrope', fontWeight: FontWeight.w300),),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),




            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.black,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("Information", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),


                          

                  
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [


                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: true,
                      controller: uniqueId, 
                      onChanged: (text) {
                        if(text.length < 3) {
                          uniqueId.value = TextEditingValue(
                            text: "DV-",
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: 3),
                            ),
                          );
                        }
                      },
                      maxLength: 13,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Unique ID (Mobile number)"
                      ),
                    ),
                        ),


                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: patientNameController,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Patient Name"
                      ),
                    ),
                        ),


                          Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: patientAgeController,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Age"
                      ),
                    ),
                        ),





                          Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: patientGenderController,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Gender"
                      ),
                    ),
                        ),

                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: symptomsP,
                            maxLines: 5,
                      
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Symptoms (seperate by ,)"
                      ),
                    ),
                        ),



                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                      controller: diagnosisP,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Diagnosis (seperate by ,)"
                      ),
                    ),
                        ),




                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                      controller: prescP,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Prescription (seperate by ,)"
                      ),
                    ),
                        ),




                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                      controller: advicesP,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Advices (seperate by ,)"
                      ),
                    ),
                        ),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [


                          Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          color: Colors.green.shade700,
                          onPressed: () async {


                            writeOnPdf();
                            savePdf().then((value) {

                                    _launchURL(value);
                            });

                          },
                          child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Preview", style: TextStyle(color: Colors.white),),
                        ),
                        ),
                      ),



                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          color: Colors.blue.shade700,
                          onPressed: () async {


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






                            writeOnPdf().then((value) async {

                                var txt = pdf.save();
                                var blobUrl = html.Blob([txt], 'application/pdf');  
                                var blobUrlLink = html.Url.createObjectUrlFromBlob(blobUrl);
                                print(blobUrlLink);

                                fb.StorageReference storageRef = fb.storage().ref('pdf/${firebaseUserThing.email}_${uniqueId.text}_$dateTime.pdf');
                                fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(blobUrl).future;
    
                                uploadTaskSnapshot.ref.getDownloadURL().then((value) {

                            Firestore.instance.collection('doctors').document(firebaseUserThing.email).collection('patients_operated').document(dateTime).setData({
                              'patient_uid': uniqueId.text,
                              'pdfLink': value.toString(),
                            }).then((xx) {
                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  SendingFacilities(title: value.toString())));    
                            });
                        });
                      });

                          },  
                          child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Proceed", style: TextStyle(color: Colors.white),),
                        ),
                        ),
                      ),
                        ],
                      ),


                      ],
                    ),
                  ),
                ],
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


  Future<void> writeOnPdf() async {
    
    pdf.addPage(

      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),

        build: (pw.Context context){
          return <pw.Widget>  [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[

                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
                    child: pw.Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          fit: pw.BoxFit.fill,
                          image: PdfImage.file(
                            pdf.document, 
                            bytes: imageForPdf,
                          ),
                        ),
                      ),
                    ),
                  ),


                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: <pw.Widget>[

                        pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 4.0),
                          child: pw.Text("Doctor's Name: ${firebaseUserThing.displayName}", 
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 16.0,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          ),
                        ),


                        pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 4.0),
                          child: pw.Text("Hospital Name: $hospitalName", 
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          ),
                          ),
                        ),


                        pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                          child: pw.Text("Email ID: ${firebaseUserThing.email}", 
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          ),
                          ),
                        ),

                    ]
                  ),

              
                ]
              ),
            ),
            

            pw.Table(
              children: <pw.TableRow> [

                  pw.TableRow(
                    
                    children: <pw.Widget>[
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Name : ${patientNameController.text}"
                      ),
                      ),

                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Date & Time : $dateTime"
                      ),
                      ),
                      

                    ]
                  ),




                  pw.TableRow(
                    children: <pw.Widget>[
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Age / Gender : ${patientAgeController.text} / ${patientGenderController.text}"
                      ),
                      ),


                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Unique ID : ${uniqueId.text}"
                      ),
                      ),                    

                    ]
                  ),



              ]
            ),


            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Symptoms", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),


            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${symptomsP.text}"),
            ),





            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Diagnosis", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),



            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${diagnosisP.text}"),
            ),



            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Prescription", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),


            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${prescP.text}"),
            ),



            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Advices", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),



            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${advicesP.text}"),
            ),
          ];
        },
      )
    );
  
  
  }

  Future<String> savePdf() async{
    var txt = pdf.save();
    var blobUrl = html.Blob([txt], 'application/pdf');  
    var blobUrlLink = html.Url.createObjectUrlFromBlob(blobUrl);
    print(blobUrlLink);
    return blobUrlLink;
  }
}


  void _launchURL(String url) async {
    js.context.callMethod("open", [url]);
  }

