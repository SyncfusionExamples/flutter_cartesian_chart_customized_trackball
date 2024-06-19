import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart' hide TextDirection;

late bool isTransposed;

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CustomizedTrackball(),
    );
  }
}

class CustomizedTrackball extends StatefulWidget {
  const CustomizedTrackball({super.key});

  @override
  State<CustomizedTrackball> createState() => _CustomizedTrackballState();
}

class _CustomizedTrackballState extends State<CustomizedTrackball> {
  late List<ChartData> chartData;

  @override
  void initState() {
    isTransposed = false;
    chartData = [
      ChartData(DateTime(2024, 2, 1), 21),
      ChartData(DateTime(2024, 2, 2), 34),
      ChartData(DateTime(2024, 2, 3), 30),
      ChartData(DateTime(2024, 2, 4), 42),
      ChartData(DateTime(2024, 2, 5), 34),
      ChartData(DateTime(2024, 2, 6), 35),
      ChartData(DateTime(2024, 2, 7), 21),
      ChartData(DateTime(2024, 2, 8), 34),
      ChartData(DateTime(2024, 2, 9), 30),
      ChartData(DateTime(2024, 2, 10), 42),
      ChartData(DateTime(2024, 2, 11), 35),
      ChartData(DateTime(2024, 2, 12), 34),
      ChartData(DateTime(2024, 2, 13), 30),
      ChartData(DateTime(2024, 2, 14), 42),
      ChartData(DateTime(2024, 2, 15), 35),
      ChartData(DateTime(2024, 2, 16), 21),
      ChartData(DateTime(2024, 2, 17), 30),
      ChartData(DateTime(2024, 2, 18), 34),
      ChartData(DateTime(2024, 2, 19), 30),
      ChartData(DateTime(2024, 2, 20), 42),
      ChartData(DateTime(2024, 2, 21), 35),
      ChartData(DateTime(2024, 2, 22), 30),
      ChartData(DateTime(2024, 2, 23), 42),
      ChartData(DateTime(2024, 2, 24), 42),
      ChartData(DateTime(2024, 2, 25), 35),
      ChartData(DateTime(2024, 2, 26), 34),
      ChartData(DateTime(2024, 2, 27), 30),
      ChartData(DateTime(2024, 2, 28), 12),
      ChartData(DateTime(2024, 2, 29), 42),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: SfCartesianChart(
              isTransposed: isTransposed,
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.MEd(),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              trackballBehavior: _CustomTrackballBehavior(),
              series: <CartesianSeries<ChartData, DateTime>>[
                SplineAreaSeries(
                  dataSource: chartData,
                  xValueMapper: (ChartData sales, _) => sales.x,
                  yValueMapper: (ChartData sales, _) => sales.y,
                  borderWidth: 2,
                  borderColor: Colors.blue,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    borderWidth: 2,
                    borderColor: Colors.blue,
                  ),
                  gradient: LinearGradient(
                    colors: const <Color>[
                      Color.fromARGB(255, 151, 208, 234),
                      Colors.white,
                    ],
                    stops: const <double>[0.65, 1],
                    begin: isTransposed
                        ? Alignment.centerRight
                        : Alignment.topCenter,
                    end: isTransposed
                        ? Alignment.bottomLeft
                        : Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isTransposed = !isTransposed;
                });
              },
              child: const Text('Transposed chart'),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final dynamic x;
  final num y;
}

class _CustomTrackballBehavior extends TrackballBehavior {
  @override
  bool get enable => true;

  @override
  ActivationMode get activationMode => ActivationMode.singleTap;

  @override
  void onPaint(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    if (chartPointInfo.isEmpty || parentBox == null) {
      return;
    }

    final Rect plotAreaBounds = parentBox!.paintBounds;
    final Offset position =
        Offset(chartPointInfo[0].xPosition!, chartPointInfo[0].yPosition!);
    // Draws custom trackball line.
    _drawCustomTrackballLine(context, position, plotAreaBounds);
    // Draws custom trackball text.
    _drawCustomTooltip(context, position, plotAreaBounds);
  }

  void _drawCustomTrackballLine(
      PaintingContext context, Offset position, Rect plotAreaBounds) {
    if (lineType != TrackballLineType.none) {
      final Offset startPos = position;
      Offset endPos = Offset.zero;
      if (isTransposed) {
        endPos = Offset(plotAreaBounds.left, position.dy);
      } else {
        endPos = Offset(position.dx, plotAreaBounds.bottom);
      }

      final Paint fillPaint = Paint()
        ..color = Colors.blueGrey
        ..style = PaintingStyle.fill;
      final Paint linePaint = Paint()
        ..isAntiAlias = true
        ..color = Colors.red
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..shader = ui.Gradient.linear(
          startPos,
          endPos,
          <Color>[Colors.blueGrey, Colors.white],
          <double>[0.65, 1],
        );

      context.canvas.drawLine(startPos, endPos, linePaint);
      context.canvas.drawCircle(startPos, 5, fillPaint);
    }
  }

  void _drawCustomTooltip(
      PaintingContext context, Offset position, Rect plotAreaBounds) {
    final TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      background: Paint()
        ..color = Colors.blueGrey
        ..strokeWidth = 17
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    final String label = chartPointInfo[0].label!;
    final Size labelSize = measureText(label, textStyle);
    final Offset customPos = isTransposed
        ? position.translate((labelSize.height + 5), -((labelSize.width / 2)))
        : position.translate(-(labelSize.width / 2),
            -((labelSize.height + 10) + (labelSize.height / 2)));
    final Offset textPos =
        _withInBounds(customPos, label, labelSize, plotAreaBounds);
    _drawText(context.canvas, label, textPos, textStyle);
  }

  Offset _withInBounds(
      Offset position, String label, Size labelSize, Rect plotAreaBounds) {
    double xPos = position.dx;
    double yPos = position.dy;
    const double padding = 5;
    if (xPos + labelSize.width > plotAreaBounds.right) {
      xPos = plotAreaBounds.right - padding - labelSize.width;
    }
    if (xPos <= plotAreaBounds.left) {
      xPos = plotAreaBounds.left + labelSize.width;
    }

    if (yPos - labelSize.height <= plotAreaBounds.top) {
      yPos = plotAreaBounds.top + labelSize.height;
    }
    if (yPos + labelSize.height >= plotAreaBounds.bottom) {
      yPos = plotAreaBounds.bottom - padding - labelSize.height;
    }

    return Offset(xPos, yPos);
  }

  void _drawText(Canvas canvas, String text, Offset point, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter
      ..layout()
      ..paint(canvas, point);
  }
}
