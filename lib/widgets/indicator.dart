import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({@required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: IndicatorPainter(
            percent: 1,
            color: Colors.grey,
            strokeWidth: 5.0,
          ),
          child: Container(),
        ),
        CustomPaint(
          painter: IndicatorPainter(
            percent: percent,
            color: Theme.of(context).accentColor,
            strokeWidth: 10.0,
          ),
          child: Container(),
        ),
      ],
    );
  }
}

class IndicatorPainter extends CustomPainter {
  IndicatorPainter({this.percent, this.color, this.strokeWidth});

  double percent;
  Color color;
  double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint myPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;

    final Path path = Path()
      ..moveTo(
        size.width * (1 - percent),
        size.height * 1 / 10,
      )
      ..lineTo(
        size.width,
        size.height * 1 / 10,
      );

    canvas.drawPath(path, myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class IndicatorBasePainter extends CustomPainter {
  IndicatorBasePainter({this.color, this.strokeWidth});

  Color color;
  double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint myPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color;

    final Path path = Path()
      ..lineTo(
        size.width,
        size.height / 10,
      );

    canvas.drawPath(path, myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
