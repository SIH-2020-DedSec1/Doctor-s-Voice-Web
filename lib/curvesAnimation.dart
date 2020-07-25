import 'package:flutter/material.dart';

class LoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.blue.shade700
    ..style = PaintingStyle.fill;

  final path = new Path()
    ..moveTo(size.width * .6, 0)
    ..quadraticBezierTo(
    size.width * .7,
    size.height * .08,
    size.width * .9,
    size.height * .05,
  )
    ..arcToPoint(
    Offset(
      size.width * .93,
      size.height * .15,
    ),
    radius: Radius.circular(size.height * .05),
    largeArc: true,
  )
    ..cubicTo(
    size.width * .6,
    size.height * .15,
    size.width * .5,
    size.height * .46,
    0,
    size.height * .3,
  )
    ..lineTo(0, 0)
    ..close();



  canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}






class RegisterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.blue.shade700
    ..style = PaintingStyle.fill;

  final path = new Path()
    ..moveTo(size.width * .6, 0)
    ..quadraticBezierTo(
    size.width * .5,
    size.height * .1,
    size.width * .99,
    size.height * .10,
  )
    ..arcToPoint(
    Offset(
      size.width * .0,
      size.height * .15,
    ),
    radius: Radius.circular(size.height * .05),
    largeArc: true,
  )
  //   ..cubicTo(
  //   size.width * .5,
  //   size.height * .20,
  //   size.width * .5,
  //   size.height * .46,
  //   0,
  //   size.height * .3,
  // )
    ..lineTo(0, 0)
    ..close();



  canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}





class ForgotPasswordPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.blue.shade700
    ..style = PaintingStyle.fill;

  final path = new Path()
    ..moveTo(size.width * .6, 0)
    
    ..arcToPoint(
    Offset(
      size.width * .0,
      size.height * .15,
    ),
    radius: Radius.circular(size.height * 0.25),
    largeArc: true,
  )
    ..lineTo(0, 0)
    ..close();



  canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}








class DashboardPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.blue.shade700
    ..style = PaintingStyle.fill;

  final path = new Path()
    ..moveTo(size.width,0)
    
    ..arcToPoint(
    Offset(
      size.width * .0,
      size.height * .45,
    ),
    radius: Radius.circular(size.height * 0.50),
    largeArc: false,
  )
    ..lineTo(0, 0)
    ..close();



  canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}








class NewPatientPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.blue.shade700
    ..style = PaintingStyle.fill;



    var path = Path();

    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width , size.height * 0.1);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);





  canvas.drawPath(path, paint);


  // canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class ProfilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue.shade700;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}




class AboutUsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}