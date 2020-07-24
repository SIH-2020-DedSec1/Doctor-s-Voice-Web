
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';

import 'new_patient.dart';

class WebRecorder {
  static bool isNotRecording = true;
  static html.MediaRecorder recorder;

  final Function whenRecorderStart; 
  final Function whenRecorderStop;
  final Function whenReceiveData;
  // final Function whenReceiveData;


  WebRecorder({@required this.whenRecorderStart, @required this.whenRecorderStop, 
      @required this.whenReceiveData,});

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


      setData(reader.result);


    
    });
  }

  setData(data) => whenReceiveData(data);

  dispose(){
    WebRecorder.recorder.removeEventListener('dataavailable', hundlerFunctionStream);
    WebRecorder.recorder = null;
  }

}