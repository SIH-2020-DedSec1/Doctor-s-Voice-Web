
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:doctors_voice_web/ibm_speech_to_text.dart';
import 'package:http/http.dart' as http;

import 'package:doctors_voice_web/speech_thingy.dart';
import 'package:flutter/material.dart';

class WebRecorder {
  static bool isNotRecording = true;
  static html.MediaRecorder recorder;

  final Function whenRecorderStart; 
  final Function whenRecorderStop;
  // final Function whenReceiveData;


  WebRecorder({@required this.whenRecorderStart, @required this.whenRecorderStop});

  openRecorder(){
    WebRecorder.isNotRecording = !WebRecorder.isNotRecording;



    if(WebRecorder.isNotRecording)
      stopRecoring().whenComplete(whenRecorderStop);
    else
      html.window.navigator
      .getUserMedia(audio: true)
      .then((stream) {
          recorder = html.MediaRecorder(stream);//, { 'type': 'audio/wav' });
          
          print("${recorder.audioBitsPerSecond.toString()} and MimeType ${recorder.mimeType}");

          recorder.addEventListener('dataavailable', hundlerFunctionStream);
      })
      .whenComplete((){
        startRecording().whenComplete(whenRecorderStart);
      })
      .catchError((e)=> print);
  }
  
  Future<void> startRecording(){
    WebRecorder.recorder.start();
    return Future.value(true);
  }

  Future<void> stopRecoring() async{
    WebRecorder.recorder.stop();

    return Future.value(true);
  }



  hundlerFunctionStream(event) async {

    html.FileReader reader = html.FileReader();
    html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];
    
    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((e) async {

      var audioThing = html.Url.createObjectUrlFromBlob(blob);
      print(audioThing);

      print(blob.type);

      IBMSpeechToText ibmSpeechToText = new IBMSpeechToText();
      ibmSpeechToText.doProcess(blob);

    
    });
  }

  /// Send [html.AudioRecorder] data to the created function [whenReceiveData].
  // setData(data) => whenReceiveData(data);

  dispose(){
    WebRecorder.recorder.removeEventListener('dataavailable', hundlerFunctionStream);
    WebRecorder.recorder = null;
  }

}