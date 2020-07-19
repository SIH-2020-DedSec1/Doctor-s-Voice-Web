import 'dart:io';
import 'dart:typed_data';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PDFPreviewScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'curvesAnimation.dart';
import 'new_patient.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(Dashboard());
}






class Dashboard extends StatelessWidget {

  Dashboard({Key key, this.firebaseUser}) : super(key: key);
  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doctor's Voice",
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardStateful(firebaseUser: firebaseUser,),
    );
  }
}

class DashboardStateful extends StatefulWidget {
  
  DashboardStateful({Key key, this.firebaseUser}) : super(key: key);
  final FirebaseUser firebaseUser;


  @override
  DashboardState createState() => DashboardState();
}

BuildContext globalContext;

class DashboardState extends State<DashboardStateful> with TickerProviderStateMixin {


  String userName;
  List<String> litems = ["Novel Coronavirus","Headache","Fever","Heart attack"];

  bool isCollapsed = true;
  double screenHeight, screenWidth;

  int isSelectedNumber = 0;



  String hospitalName;

  void initState() {
    super.initState();

    userName = widget.firebaseUser.displayName == null ? "there" : widget.firebaseUser.displayName;

    FirebaseAuth.instance.currentUser().then((value) {


        Firestore.instance.collection('doctors').document(value.email).collection('personal_info').document('data').get().then((value) {
          hospitalName = value['hospitalName'];
        });

      setState(() {
        
      });
    });






    final PermissionHandler _permissionHandler = PermissionHandler();

    _permissionHandler.checkPermissionStatus(PermissionGroup.microphone).then((value) {
          if(value == PermissionStatus.granted) {

          } else {
    _permissionHandler.requestPermissions([PermissionGroup.microphone, PermissionGroup.storage]).then((value) {

    });
          }
    });
  }

  bool isFabClosed = false;

  @override
  Widget build(BuildContext context) {

    globalContext = context;


    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;






    return WillPopScope(
      child: Scaffold(


      floatingActionButton: isCollapsed ? isSelectedNumber == 0 ? FloatingActionButton(

        heroTag: "NewPatientAdder",
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green.shade700,
    
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => new NewPatient(firebaseUser: widget.firebaseUser,)));
              print("new patient : ${widget.firebaseUser.email}");
              },
          ) : null : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          userProfileOptions(context),
          isSelectedNumber == 0 ? dashboardMenu(context) : 
          isSelectedNumber == 1 ? historyData(context) : 
          isSelectedNumber == 2 ? profileMenu(context) : 
          isSelectedNumber == 3 ? aboutUs(context) : 
          Container(),
        ],
      ), 

    ), onWillPop: () => _onWillPop(),);
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  List<Widget> listForHistory = new List<Widget>();

  Widget userProfileOptions(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(24.0),
        color: Colors.green.withOpacity(0.80),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            Container(
            ),

            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
              child: Card(
              
              color: Colors.black45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [

                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: CircleAvatar(
                    radius: 40.0,
              backgroundImage: NetworkImage(
                "https://www.thefactsite.com/wp-content/uploads/2018/12/emma-watson-facts.jpg",
                ),
            ),
                  ),


                    Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      child: 
            Text(userName == "there" ? widget.firebaseUser.email : widget.firebaseUser.displayName, 
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Manrope', 
              fontSize: 16.0, 
              fontWeight: FontWeight.w500),),
                    ),
                ],
              ),
            ),
            ),


                    InkWell(
                      onTap: () {
                        isSelectedNumber = 0;
                        isCollapsed = !isCollapsed;
                        setState(() {
                          
                        });
                      },
                      child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: 
            Text("Home", style: TextStyle(
              color: isSelectedNumber == 0 ? Colors.white : Colors.black,fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w500),),
                    ),
                    ),

                     InkWell(
                      onTap: () {
                        setState(() {
                          isSelectedNumber = 1;
          isCollapsed = !isCollapsed;
                        });
                      },
                      child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: 
            Text("History", style: TextStyle(
              color: isSelectedNumber == 1 ? Colors.white : Colors.black,fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w500),),
                    ),
                    ),


                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelectedNumber = 2;
          isCollapsed = !isCollapsed;
                          
                        });
                      },
                      child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: 
            Text("Profile", style: TextStyle(
              color: isSelectedNumber == 2 ? Colors.white : Colors.black,fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w500),),
                    ),
                    ),




                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelectedNumber = 3;
          isCollapsed = !isCollapsed;
                        });
                      },
                      child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: 
            Text("About us", style: TextStyle(
              color: isSelectedNumber == 3 ? Colors.white : Colors.black,fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w500),),
                    ),
                    ),


            

          ],
        ),


            Container(
            ),


            Container(
            ),


            Container(
            ),



            Container(
              child: Text("Built for SIH", style: TextStyle(fontFamily: 'Manrope', fontSize: 16.0, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardMenu(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500,),
      curve: Curves.linearToEaseOut,
      top: isCollapsed ? 0 : 0.1 * screenHeight,
      bottom: isCollapsed ? 0 : 0.1 * screenWidth,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
             
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
          children: [




        CustomPaint(
      painter: DashboardPainter(),
      size: MediaQuery.of(context).size,
    ),

            Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.menu, color: Colors.white,), onPressed: () {
          isCollapsed = !isCollapsed;
          setState(() {
            
          });
        },),
            ],
          ),
          ),
        



          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Text("Hello $userName!",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
              ),
            ),
          ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.blue.shade500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 2.0,
              shadowColor: Colors.black,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: 
                  Text("Diseases Frequency (Top 3)", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700, color: Colors.white),),
                  ),
                 ListView.builder(
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 16.0),
                   dragStartBehavior: DragStartBehavior.down,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, num) {
                          return new Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("${num+1}. ${litems[num]}", style: TextStyle(color: Colors.white),),
                            );
                        }
                      ),

                ],
              ),
            ),
            ),





            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.pink.shade500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 2.0,
              shadowColor: Colors.black,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: 
                  Text("Fact of the day", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700, color: Colors.white),),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child:  Text("In olden days, Doctors used to wear a rat mask as a recognition.", style: TextStyle(color: Colors.white, fontSize: 16.0), textAlign: TextAlign.start,)
                  ),

                ],
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: 
                  Text("Patients diagnosed (7-day history)", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                  ),
                 
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child:  Container(
                   height: 200,
                   child: BezierChart(
                     
        bezierChartScale: BezierChartScale.CUSTOM,
        xAxisCustomValues: const [1, 2, 3, 4, 5, 6, 7],
        
        
        series: const [
          BezierLine(
            lineColor: Colors.blue,
            data: const [
              DataPoint<double>(value: 10, xAxis: 1),
              DataPoint<double>(value: 130, xAxis: 2),
              DataPoint<double>(value: 50, xAxis: 3),
              DataPoint<double>(value: 150, xAxis: 4),
              DataPoint<double>(value: 75, xAxis: 5),
              DataPoint<double>(value: 0, xAxis: 6),
              DataPoint<double>(value: 5, xAxis: 7),
            ],
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black,
          xAxisTextStyle: TextStyle(color: Colors.black,),
          showVerticalIndicator: true,
          verticalLineFullHeight: true,
          verticalIndicatorFixedPosition: false,
          contentWidth: MediaQuery.of(context).size.width / 1.4,
          pinchZoom: false,
          backgroundColor: Colors.white,
          snap: false,
        ),
      ),
                 ),
                ),

                          Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Pro Tip! Hold on the graph to see the values for each of them", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        ),

                        Padding(
                          padding: EdgeInsets.all(4.0),
                        ),
                ],
              ),
            ),
            ),





            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Card(
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            //   elevation: 24.0,
            //   shadowColor: Colors.indigo,
              
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.all(16.0),
            //         child: 
            //       Text("Predicted Patients Number", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
            //       ),
            //      ListView.builder(
            // padding: EdgeInsets.all(8.0),
            //        dragStartBehavior: DragStartBehavior.down,
            //             shrinkWrap: true,
            //             physics: NeverScrollableScrollPhysics(),
            //             itemCount: 3,
            //             itemBuilder: (context, num) {
            //               return new Padding(
            //                   padding: EdgeInsets.all(8.0),
            //                   child: Text("${num+1}. ${litems[num]}"),
            //                 );
            //             }
            //           ),

            //           Padding(
            //             padding: EdgeInsets.all(16.0),
            //             child: RaisedButton(
            //               elevation: 24.0,
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            //               color: Colors.teal.shade900,
            //               onPressed: () {},
            //               child: Padding(
            //               padding: EdgeInsets.all(16.0),
            //               child: Text("Show more", style: TextStyle(color: Colors.white),),
            //             ),
            //             ),
            //           ),
            //     ],
            //   ),
            // ),
            // ),



        ],
      ),
          ],
        ),
        ),
      ),
    ),
    );
  }













  Widget profileMenu(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500,),
      curve: Curves.linearToEaseOut,
      top: isCollapsed ? 0 : 0.1 * screenHeight,
      bottom: isCollapsed ? 0 : 0.1 * screenWidth,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
             
      // bottomNavigationBar: FABBottomAppBar(
      //   onTabSelected: _selectedTab,
      //   selectedColor: Colors.teal,

      //   notchedShape: CircularNotchedRectangle(),
      //   items: [
      //     FABBottomAppBarItem(iconData: Icons.history, text: 'History'),
      //     FABBottomAppBarItem(iconData: Icons.healing, text: 'Suggestions'),
      //     FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Bottom'),
      //     FABBottomAppBarItem(iconData: Icons.info, text: 'Bar'),
      //     ],
      //   ),
      child: SingleChildScrollView(
        child: Stack(
          children: [


              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: 
              Align(
                alignment: Alignment.bottomLeft,
                child: 
              Icon(Icons.person_outline, color: Colors.green, size: 250.00,),
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
              IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: () {
          isCollapsed = !isCollapsed;
          setState(() {
            
          });
        },),
            ],
          ),
          ),
        



          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 16.0),
            child: Text("Profile",
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
              
              child: Container(
                width: MediaQuery.of(context).size.width,
                
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Padding(
                   padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                   child: CircleAvatar(
                    radius: 50.0,
              backgroundImage: NetworkImage(
                "https://www.thefactsite.com/wp-content/uploads/2018/12/emma-watson-facts.jpg",
                ),
            ),
                 ),




                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: 
            Text(userName == "there" ? widget.firebaseUser.email : widget.firebaseUser.displayName, 
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Manrope', 
              fontSize: 24.0, 
              fontWeight: FontWeight.w500),),
                    ),



                ],
              ),
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
                  Text("Personal information", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                  ),

                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: TextField(
                      enabled: false,
                      controller: new TextEditingController(
                        text: widget.firebaseUser.email,
                      ),
                      decoration: InputDecoration(
                        labelText: "Email ID",
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),




                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: TextField(
                      enabled: true,
                      controller: new TextEditingController(
                        text: hospitalName,
                      ),
                      decoration: InputDecoration(
                        labelText: "Hospital Name",
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
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
    ),
    );
  }










  Widget historyData(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500,),
      curve: Curves.linearToEaseOut,
      top: isCollapsed ? 0 : 0.1 * screenHeight,
      bottom: isCollapsed ? 0 : 0.1 * screenWidth,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
             
      // bottomNavigationBar: FABBottomAppBar(
      //   onTabSelected: _selectedTab,
      //   selectedColor: Colors.teal,

      //   notchedShape: CircularNotchedRectangle(),
      //   items: [
      //     FABBottomAppBarItem(iconData: Icons.history, text: 'History'),
      //     FABBottomAppBarItem(iconData: Icons.healing, text: 'Suggestions'),
      //     FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Bottom'),
      //     FABBottomAppBarItem(iconData: Icons.info, text: 'Bar'),
      //     ],
      //   ),
      child: SingleChildScrollView(
        child: Stack(
          children: [


              Align(
                alignment: Alignment.topRight,
                child: 
              Icon(Icons.history, color: Colors.green, size: 300.00,),
              ),







            Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: () {
          isCollapsed = !isCollapsed;
          setState(() {
            
          });
        },),
            ],
          ),
          ),
        


          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text("History",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.black
              ),
            ),
          ),



              StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('doctors').document(widget.firebaseUser.email).collection('patients_operated').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Center(child: CircularProgressIndicator(),);
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: ListTile(
                  trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () {


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


                    loadPdf(document['pdfLink']).then((value) {


      Navigator.of(context, rootNavigator: true).pop('dialog');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => new PdfPreviewScreenForHistory(path: linkedOnes,)));

                    });
                  },),
                  title: new Text(document['patient_uid']),
                  subtitle: new Text(document.documentID),
                ),
                ),
                );
              }).toList(),
            );
        }
      },
    ),



        ],
      ),
          ],
        ),
      ),
    ),
    );
  }




  String linkedOnes;


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final filePath = await _localPath;
    return File('$filePath/test.pdf');
  }


  Future<File> writeCounter(Uint8List stream) async {
    File file = await _localFile;
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;
    return responseJson;
  }

  Future<void> loadPdf(String url) async {
    writeCounter(await fetchPost(url));
    linkedOnes = (await _localFile).path;

    if (!mounted) return;

  }

  












  Widget aboutUs(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500,),
      curve: Curves.linearToEaseOut,
      left: 0.6 * screenWidth,
      child: Material(

        elevation: 16.0,
        
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
             
      // bottomNavigationBar: FABBottomAppBar(
      //   onTabSelected: _selectedTab,
      //   selectedColor: Colors.teal,

      //   notchedShape: CircularNotchedRectangle(),
      //   items: [
      //     FABBottomAppBarItem(iconData: Icons.history, text: 'History'),
      //     FABBottomAppBarItem(iconData: Icons.healing, text: 'Suggestions'),
      //     FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Bottom'),
      //     FABBottomAppBarItem(iconData: Icons.info, text: 'Bar'),
      //     ],
      //   ),
      child: SingleChildScrollView(
        child: Stack(
          children: [




        CustomPaint(
      painter: ProfilePainter(),
      size: MediaQuery.of(context).size,
    ),





            Column(



    
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: () {
          isCollapsed = !isCollapsed;
          setState(() {
            
          });
        },),
            ],
          ),
          ),
        



          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Text("About us",
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: 
                  Text("Designed at Smart India Hackathon 2020 for Bajaj Finserv", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                  ),
                ],
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: 
                  Text("Team : DedSec11", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
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
    ),
    );
  }

}





