import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

import 'new_patient.dart';


class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                    Navigator.of(buildContextOfNewPatient).pop();
                  }, 
                  label: Text("Back"),
                  icon: Icon(Icons.chevron_left),
                  ),
                  body: PdfViewer(
                    filePath: path,
                  ),
    );
  }
}





class PdfPreviewScreenForHistory extends StatelessWidget {
  final String path;

  PdfPreviewScreenForHistory({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                    Navigator.of(globalContext).pop();
                  }, 
                  label: Text("Back"),
                  icon: Icon(Icons.chevron_left),
                  ),
                  body: PdfViewer(
                    filePath: path,
                  ),
    );
  }
}




