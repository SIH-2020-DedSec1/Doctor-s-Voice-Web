import 'package:bezier_chart/bezier_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'curvesAnimation.dart';
import 'new_patient.dart';
import 'dart:js' as js;
import 'upi_payments.dart';

import 'package:intl/intl.dart';
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
        primarySwatch: Colors.blue,
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

  List<double> arrayOfPatientsArrival = new List<double>();
  final List<DataPoint<double>> list = new List<DataPoint<double>>();

  String hospitalName;
  bool isDataLoaded = false;

  void _launchURL(String url) async {
    js.context.callMethod("open", [url]);
  }



  Widget paymentPage(BuildContext context) {

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
        child: Stack(
          fit: StackFit.loose,
          children: [



              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height,
                child: 
              Align(
                alignment: Alignment.topRight,
                child: 
              Icon(Icons.payment, color: Colors.blue.shade700, size: 180.00,),
              ),
              ),





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
            child: Text("Payment Board",
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                  Text("Available Balance", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),


                  Text("INR 100.0", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),



          Center(
            child: 
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.blue.shade200,
                elevation: 16.0,
                onPressed: ( ) {

                Navigator.push(context, MaterialPageRoute(builder: (context) => UpiPaymentStateless()));

                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: 
                  Text("Add Credits", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [

                  Text("Transaction History", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),



                 ListView.builder(
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 16.0),
                   dragStartBehavior: DragStartBehavior.down,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: litems.length,
                        itemBuilder: (context, num) {
                          return new Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("${num+1}. ${litems[num]}", style: TextStyle(color: Colors.black),),
                            );
                        }
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
          ],
        ),
      ),
    ),
    );
  }

  void initState() {
    super.initState();

    arrayOfPatientsArrival = [0,0,0,0,0,0,0];


    var sevenDay = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print(DateTime.now().subtract(Duration(days: 1)));
    print(DateTime.now().subtract(Duration(days: 2)));
    print(DateTime.now().subtract(Duration(days: 3)));
    var sixDay = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    var fiveDay = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 2)));
    var fourDay = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 3)));
    var threeDay = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 4)));
    var twoDay = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 5)));
    var oneDay = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 6)));

    userName = widget.firebaseUser.displayName == null ? "there" : widget.firebaseUser.displayName;

    FirebaseAuth.instance.currentUser().then((value) {

        var refFirst = Firestore.instance.collection('doctors').document(value.email);

        refFirst.collection('personal_info').document('data').get().then((value) {
          hospitalName = value['hospitalName'];
        });



        refFirst.collection('patients_operated').getDocuments().then((value) {
            value.documents.forEach((element) {
              if(element.documentID.contains(oneDay)) {
                arrayOfPatientsArrival[0] = arrayOfPatientsArrival[0] + 1.0;
              } else if(element.documentID.contains(twoDay)) {
                arrayOfPatientsArrival[1] = arrayOfPatientsArrival[1] + 1.0;
                
              } else if(element.documentID.contains(threeDay)) {
                arrayOfPatientsArrival[2] = arrayOfPatientsArrival[2] + 1.0;
                
              } else if(element.documentID.contains(fourDay)) {
                arrayOfPatientsArrival[3] = arrayOfPatientsArrival[3] + 1.0;
                
              } else if(element.documentID.contains(fiveDay)) {
                arrayOfPatientsArrival[4] = arrayOfPatientsArrival[4] + 1.0;
                
              } else if(element.documentID.contains(sixDay)) {
                arrayOfPatientsArrival[5] = arrayOfPatientsArrival[5] + 1.0;
                
              } else if(element.documentID.contains(sevenDay)) {
                arrayOfPatientsArrival[6] = arrayOfPatientsArrival[6] + 1.0;
                
              } 
            });
        }).then((value) {
          isDataLoaded = !isDataLoaded;
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[0], xAxis: 1));
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[1], xAxis: 2));
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[2], xAxis: 3));
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[3], xAxis: 4));
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[4], xAxis: 5));
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[5], xAxis: 6));
          list.add(DataPoint<double>(value: arrayOfPatientsArrival[6], xAxis: 7));
          setState(( ) {

          });
        });
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
        backgroundColor: Colors.blue.shade700,
    
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
          isSelectedNumber == 2 ? paymentPage(context) :
          isSelectedNumber == 3 ? profileMenu(context) : 
          isSelectedNumber == 4 ? aboutUs(context) : 
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


  bool onLoaded = true;

  List<Widget> listForHistory = new List<Widget>();

  Widget userProfileOptions(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(24.0),
        color: Colors.blue.shade700.withOpacity(0.80),
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
              backgroundImage: AssetImage("assets/dv.png"),
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
            Text("Payment Board", style: TextStyle(
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
            Text("Profile", style: TextStyle(
              color: isSelectedNumber == 3 ? Colors.white : Colors.black,fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w500),),
                    ),
                    ),




                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelectedNumber = 4;
          isCollapsed = !isCollapsed;
                        });
                      },
                      child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: 
            Text("About us", style: TextStyle(
              color: isSelectedNumber == 4 ? Colors.white : Colors.black,fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w500),),
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
      top: isCollapsed ? 0 : 0 * screenHeight,
      bottom: isCollapsed ? 0 : 0 * screenWidth,
      left: isCollapsed ? 0 : screenWidth > 600 ? 0.2 * screenWidth : 0.4 * screenWidth,
      right: isCollapsed ? 0 : -0 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: isCollapsed ? BorderRadius.circular(0.0) : BorderRadius.circular(16.0),
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
        


            Center(
              child: Container(      
                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,

                child: 
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
              ),
            ),

           
           Center(
             child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(      
                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,

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
            ),
           ),




            Center(
              child: 
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
                child: Card(
                color: Colors.pink.shade500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 2.0,
              shadowColor: Colors.black,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: 
                  Text("Fact of the day", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700, color: Colors.white),),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child:  Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Text("In olden days, Doctors used to wear a rat mask as a recognition. ", style: TextStyle(color: Colors.white, fontSize: 16.0), textAlign: TextAlign.start,),
                    ),
                  ),

                ],
              ),
            ),
              ),
            ),
            ),









              isDataLoaded ? Center(
                child: 

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
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
        
        
        series: [
          BezierLine(
            lineColor: Colors.blue,
            data: list,
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black,
          xAxisTextStyle: TextStyle(color: Colors.black,),
          showVerticalIndicator: true,
          verticalLineFullHeight: true,
          verticalIndicatorFixedPosition: false,
          contentWidth: MediaQuery.of(context).size.width / 3,
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
            ),
              ) : Container(),





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
      top: isCollapsed ? 0 : 0 * screenHeight,
      bottom: isCollapsed ? 0 : 0 * screenWidth,
      left: isCollapsed ? 0 : screenWidth > 600 ? 0.2 * screenWidth : 0.4 * screenWidth,
      right: isCollapsed ? 0 : -0 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: isCollapsed ? BorderRadius.circular(0.0) : BorderRadius.circular(16.0),
          color: Colors.blue.shade700,
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
              Icon(Icons.person_outline, color: Colors.white, size: 250.00,),
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
              IconButton(icon: Icon(Icons.menu, color: Colors.white,), onPressed: () {
          isCollapsed = !isCollapsed;
          setState(() {
            
          });
        },),
            ],
          ),
          ),
        


          
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 16.0),
            child: Center(
            child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
      child: Text("Profile",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
              ),
            ),
          ),
          ),
          ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
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
              backgroundImage: AssetImage("assets/dv.png"),
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
              ),
            ),







            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
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
      top: isCollapsed ? 0 : 0 * screenHeight,
      bottom: isCollapsed ? 0 : 0 * screenWidth,
      left: isCollapsed ? 0 : screenWidth > 600 ? 0.2 * screenWidth : 0.4 * screenWidth,
      right: isCollapsed ? 0 : -0 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: isCollapsed ? BorderRadius.circular(0.0) : BorderRadius.circular(16.0),
          color: Colors.blue.shade700,
      child: SingleChildScrollView(
        child: Stack(
          children: [


              Align(
                alignment: Alignment.topRight,
                child: 
              Icon(Icons.history, color: Colors.white, size: 300.00,),
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
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Center(
              child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
                child: Text("History",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
              ),
            ),
              ),
            ),
          ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(),
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
                  child: Center(
                    child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
                      child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: ListTile(
                  trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () {

                  _launchURL(document['pdfLink']);

                  },),
                  title: new Text(document['patient_uid']),
                  subtitle: new Text(document.documentID),
                ),
                ),
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

  Widget aboutUs(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500,),
      curve: Curves.linearToEaseOut,
      top: isCollapsed ? 0 : 0 * screenHeight,
      bottom: isCollapsed ? 0 : 0 * screenWidth,
      left: isCollapsed ? 0 : screenWidth > 600 ? 0.2 * screenWidth : 0.4 * screenWidth,
      right: isCollapsed ? 0 : -0 * screenHeight,
      child: Material(

        elevation: 16.0,
        
          borderRadius: isCollapsed ? BorderRadius.circular(0.0) : BorderRadius.circular(16.0),
          color: Colors.blue.shade700,
             
      child: SingleChildScrollView(
        child: Stack(
          children: [




        CustomPaint(
      painter: AboutUsPainter(),
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
            child: Center(
              child: Container(
      width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
                child: Text("About us",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
              ),
            ),
              ),
            ),
          ),

           





     // width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Container( 
                  width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
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
              ),
            ),





            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
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





