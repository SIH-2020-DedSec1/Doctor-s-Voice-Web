import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;

class IBMSpeechToText {
  final jsonEncoder = JsonEncoder();



  void getToken() {
       const tokenUrl = "https://iam.bluemix.net/identity/token";
       final authThing = "Basic " + base64.encode(utf8.encode("pnani18dec@gmail.com:Rock1331"));
       http.post(
         tokenUrl,
         headers: {
           "Authorization" : authThing,
         }
       ).then((value) {
          print(value.body);
       });
  }

  void doProcess(Blob blob) {

      getToken();

    // var webSocket =  WebSocket("wss://api.eu-gb.speech-to-text.watson.cloud.ibm.com/instances/062d6fda-ee57-430d-b1df-a99d8901cc2c/v1/recognize?access_token=eyJraWQiOiIyMDIwMDYyNDE4MzAiLCJhbGciOiJSUzI1NiJ9.eyJpYW1faWQiOiJJQk1pZC01NTAwMDNLQTQyIiwiaWQiOiJJQk1pZC01NTAwMDNLQTQyIiwicmVhbG1pZCI6IklCTWlkIiwiaWRlbnRpZmllciI6IjU1MDAwM0tBNDIiLCJnaXZlbl9uYW1lIjoiUGVudW1hbGEiLCJmYW1pbHlfbmFtZSI6Ik5hbmkiLCJuYW1lIjoiUGVudW1hbGEgTmFuaSIsImVtYWlsIjoicG5hbmkxOGRlY0BnbWFpbC5jb20iLCJzdWIiOiJwbmFuaTE4ZGVjQGdtYWlsLmNvbSIsImFjY291bnQiOnsidmFsaWQiOnRydWUsImJzcyI6ImYzNTA5NTc1MjZlODRjYTViZGQyZTQ0YjMyZWQ4ZTI1In0sImlhdCI6MTU5NTQzMDA0MywiZXhwIjoxNTk1NDMzNjQzLCJpc3MiOiJodHRwczovL2lhbS5jbG91ZC5pYm0uY29tL2lkZW50aXR5IiwiZ3JhbnRfdHlwZSI6InBhc3N3b3JkIiwic2NvcGUiOiJpYm0gb3BlbmlkIiwiY2xpZW50X2lkIjoiYngiLCJhY3IiOjEsImFtciI6WyJwd2QiXX0.N37WX1R2bqGcfZ9XRGOIqttv42SXW3OkMA72bk6eN2IOcoUtGQcFKXKxEyZLD-VbqOMP-GlodNzhx7z-orXNwmFB_rr4PcUkXGGYXChL6JxhTo4KcrumLh6-zM-0yW7EH9GDwtSj6AXQxzIrgAbY7Q4Mv5EaJQJ8liLorvfnYE54-HP_3_6NBDccbDPmkCX2qTw0YWcyDsSv6PbAv9vd64qryWwl8d4R5_iPtdmxEmklx_XfiK8ZE1pDN6jZVzhBtvc1-Smd3t1cZQ6P1bJoYUuGzqz6-zOiUfpHJlIyx8yiwg-lqHqiMG90znmpYWNgWMNfSb50uRWe2QKoNAAfaQ");
    var webSocket =  WebSocket("wss://api.eu-gb.speech-to-text.watson.cloud.ibm.com/instances/062d6fda-ee57-430d-b1df-a99d8901cc2c/v1/recognize?model=en-US_BroadbandModel&watson-token=");
  


      webSocket.onOpen.listen((event) {
        
    webSocket.send(
      jsonEncoder.convert({
        'action': 'start',
      }));


      webSocket.send(blob);

      webSocket.send(jsonEncoder.convert({'action': 'stop'}));

      });

    
      webSocket.onMessage.listen((event) {
        print(event.data.toString());
      });

  }

}