import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';





/**
 * 
 * 
 * 
 * 
 * 
 * 
 * curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'config': {
    'encoding': 'LINEAR16',
    'sampleRateHertz': 16000,
    'languageCode': 'en-US',
    'enableWordTimeOffsets': false
  },
  'audio': {
    'content': '/9j/7QBEUGhvdG9zaG9...base64-encoded-audio-content...fXNWzvDEeYxxxzj/Coa6Bax//Z'
  }
}" "https://speech.googleapis.com/v1/speech:recognize"
  
 */




final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  
  "type": "service_account",
  "project_id": "smartindiahackathon-2020",
  "private_key_id": "8d53e5867768313e15ab18c30b16c0cb56980438",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCFL1WAuUSqyEP\nvx85FJ3GsVNZLKWC9qpXTQJDZKV8z+uDE+qI7+zI0Qd75hV/uBOJmAmBsZl63zdA\nvfcmMKC7Xar0PEt9xlVtx2qZBWTq4qKKvSC4nmKod90LlEK3irp60kHkb49R0dWi\nEIWvi1BVnw0G+hNUY1T9xa3z2PlUkIX93xAmgeeCBFLgnifCKfAfwwct4jzSYlGC\n3stean9FpVWc/xphOVT+5yWADDeaQA5Hf3u89IaxWIgeXPLDfCQmhEp20ll8fBNG\nVT+/69kQBc0Bb4UMkLXnLKnfAw66uoayZtew4o/kp9JdEG+lVXdFQYFutjgzYSgN\n8Qrp/J0NAgMBAAECggEAMe7/FamSAV8ZFwGPyXJV86B89sUHYm4PPn3YNrmm4Dlo\neSV/IrNEAxjQqZ51apJUKIL+8yjb+aKDhzs44tEBEaPUT5lRvO7x3NhBQ1SBdfNQ\naYymZgmODZUlQIzpK2rcdqww+tJ/F8h6hANnOdaImTbeNazSm1QhMleRXVs2Lvy7\nWUP73lBVRsprrFdIRlfIDJcZtVCoqELcItWPl5Ri16FlKZgJ5YNyGDgU0w3YyXPt\nZbUhiwmTGYS4r8QCrYK+WPmLLEeRuwN3VpeweEvdL5uCZ6Y+rIArHi1smgQPxAbe\nDAjs4EcaD8hZ10zyJo4ocdqUZw0KREnQrtFrb7+piwKBgQDkWp8yVdFTUHGCikpe\nGx2S9yN11Ff/g41ioFfejH0tzw+xzHcJLFn+IZrQZfj9ByWBCemVO30ytboB4PZs\nyg93jTp+L8R9yodkeQhqYB1JUF/8a0PW0i062q/LX7Bdr7mPmQKoQ28jk1EBV1xn\nn0xN608nOQiSpIGzX2nmXcZR2wKBgQDZk+UYg41LGHVn5Ij2dEjiD4/ysZnBpcYx\nRmrcfyb7i4xIdDYPGlvJ7DJ35euqY6mmMtX9VnHWZjfpBHptsIbfsTXBOjS/f/y1\ngwEKmreyaSZjQzImqN/JJHPmTVUEj4ep1EneIyPv/1jm91/KuWHVw4pslgzZ+IL2\n3quL7ENFNwKBgQCwJ6g/MCx2VMv7o6qSxeAeiz9zmgb4OQdMWdzu9Plr6Rt2UQBS\nt0AE5u+Ca+eTaXvo+ziRwn5mLAH9iQkQCx+7XdsNlNPDJgUj4Ko5RUPSVop1Mln2\n0dPKXwDVpk9rNi+zMpn2K28ExpPqsPW7igtW4HsDCuAuH3FeafBLoXNnmQKBgH2N\nhHQC5bPh504OaKKfM7ePd2d66NkACkBA/EVE8n/RZSAiP1ezxCffLrhVawql/C21\nxBoumf44eibyuJs3dHz8y6I3Ll0bQ/6SHDW8ViiT2N0K15PLe2ecq2zITzkUghqU\nMBQJfyFs3iZZtWNMWpJ6BhTm+X+GkjxW/fL+YUs9AoGAGExMV7HlQUed41qqI1hy\nTaCOhQJsTdzNTERaFVjVF+h+oqQZYqe7FA5g69GyiVlZRN3Alpd9j1RuqahdxaYX\naT3BIEYrpKiRG6kl14wahtHZjs4IYHXEeAn3IEehsYPNzI40Vf4d8hJaEMkN+MPO\nvR8yztKOTcaA8bzFlA/jvI8=\n-----END PRIVATE KEY-----\n",
  "client_email": "service-account@smartindiahackathon-2020.iam.gserviceaccount.com",
  "client_id": "112310511263296737410",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/service-account%40smartindiahackathon-2020.iam.gserviceaccount.com"
}
''');

const _SCOPES = const [SpeechApi.CloudPlatformScope];

void speechActivation(String audioString) {

  clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
    var speech = new SpeechApi(http_client);
    final _json = {
  "audio":{
    "content": base64.encode(utf8.encode(audioString)),
  },
  "config": {
    "encoding": "LINEAR16",
    "sampleRateHertz": 16000,
    "languageCode": "en-US"
  }
};
    final _recognizeRequest = RecognizeRequest.fromJson(_json);
    speech.speech.recognize(_recognizeRequest).then((response) {

        print(response.toJson().toString());
        
    });
  });
}
