import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class IBMSpeechToText {
  final jsonEncoder = JsonEncoder();



  void getToken() {
       const tokenUrl = "https://stream.watsonplatform.net/authorization/api/v1/token?url=https://stream.watsonplatform.net/speech-to-text/api";
       final authThing = "Basic " + base64.encode(utf8.encode("pnani18dec@gmail.com:Rock1331"));
       http.post(
         tokenUrl,
         headers: {
           "Content-Type": "application/x-www-form-urlencoded",
           "Accept": "application/json",
           "Authorization" : authThing,
         }
       ).then((value) {
          print(value.body);
       });
  }

  String doProcess(Uint8List blobUrl) {

      http.post(
        "https://api.eu-gb.speech-to-text.watson.cloud.ibm.com/instances/062d6fda-ee57-430d-b1df-a99d8901cc2c/v1/recognize",
        headers : {
          "Accept" : "application/json", 
          "Authorization" : "Basic " + base64.encode(utf8.encode("apikey:lhCmK873A3w9VGXUX4CEFH5YmwIvlpQoiOSXIebPEyYf")),
          "Content-Type" : "audio/webm",
        },
        body : blobUrl,
      ).then((value) {
        print(value.body.toString());
        return value.body;

      }).catchError((onError) {
        print(onError.toString());
      });



  }

}