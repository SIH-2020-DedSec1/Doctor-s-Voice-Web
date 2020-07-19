import 'package:flutter/material.dart';



class URLOfPdf {
  String url;
  URLOfPdf({@required this.url});

    factory URLOfPdf.fromJson(Map<String, dynamic> json) {
    return URLOfPdf(
      url: json['url'],
    );
  }
}

