import 'dart:math';

import 'package:flutter/material.dart';

import 'curvesAnimation.dart';
import 'dashboard.dart';


class UpiPaymentStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: UpiPaymentStateful(),
      ),
    );
  }
}

class UpiPaymentStateful extends StatefulWidget {
  @override
  UpiPaymentState createState() => UpiPaymentState();
}

class UpiPaymentState extends State<UpiPaymentStateful> {

  final _upiAddressController = TextEditingController(text: 
    "8801853078@paytm",);
  final _amountController = TextEditingController(
    text: "100.00",
  );

  bool _isUpiEditable = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiAddressController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

             
      body: SingleChildScrollView(
        child: Stack(
          children: [




        CustomPaint(
      painter: NewPatientPainter(),
      size: MediaQuery.of(context).size,
    ),








            Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [


          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(),
          ),


          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: Colors.white), onPressed: () {
                Navigator.of(globalContext).pop();
        },),
            ],
          ),
          ),
        
        
            Padding(

            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text("Payment",
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [





                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("Payment info", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),




                  
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [



            Row(
              children: <Widget>[

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                    controller: _upiAddressController,
                    enabled: false,
                    style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                      hintText: 'address@upi',
                      labelText: 'Receiving UPI Address',
                      ),
                  ),
                  ),
                ),

              ],
            ),
 




            Row(
              children: <Widget>[
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                    controller: _amountController,
                    enabled: _isUpiEditable,
                    style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                      labelText: 'Amount',
                      ),
                  ),
                  ),
                ),
              ],
            ),


          ],
        ),
      ),

                ]),
                ),









                
                
                
                
                ),






            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [





                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("Pay the amount by scanning the below QR code with your email ID as Description. Payment may get reflected into the account within 1-2 days", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),


                  Center(
                    child: 
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image.asset("assets/response.png", width: 200.0, height: 200.0,),
                  ),
                  ),







                ]),
                ),









                
                
                
                
                ),

         ]),
         
         
         
           ]),
           
     ),
     
     
      );


  }
}