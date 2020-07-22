
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
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
          recorder = html.MediaRecorder(stream,  { 'type' : 'audio/mpeg-3' });//, { 'type': 'audio/wav' });

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



  /// A function hundler that waits for [html.MediaStream] data
  /// and then transform it to a [html.Blob] with [js.JsObject]
  /// subsequently read it with [html.FileReader] to transform
  /// into [Uint8List] data
  /// 
  hundlerFunctionStream(event) async {

    // html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];
    //       var audioThing = html.Url.createObjectUrlFromBlob(blob);
    //       print(audioThing);
    html.FileReader reader = html.FileReader();
    html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];


          var audioThing = html.Url.createObjectUrlFromBlob(blob);
          print(audioThing);


    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((e) async {


        await http.post(
          "https://api.convertio.co/convert",
          body: {
              "apikey": "bc0677af9e65cd36a934d080ea5b1408", 
              "file":"$audioThing", 
              "outputformat":"flac"
          }
        ).then((value) async {
            String responseId = jsonDecode(value.body)['data']['id'];
            await http.get(
              "http://api.convertio.co/convert/$responseId/dl",
            ).then((value2) {
                String content = jsonDecode(value2.body)['data']['content'];
                print("Content $content");
            });
        });

    // var urlOnes = html.Url.createObjectUrlFromBlob(audioBlob);
    // print(urlOnes.toString());
    
    });
  }

  /// Send [html.AudioRecorder] data to the created function [whenReceiveData].
  // setData(data) => whenReceiveData(data);

  /// Dispose this [html.MediaRecorder]
  dispose(){
    WebRecorder.recorder.removeEventListener('dataavailable', hundlerFunctionStream);
    WebRecorder.recorder = null;
  }
}