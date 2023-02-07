import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:wasm';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp/operation.dart';
import './colors.dart';
import './graphingcalculator.dart';

class GraphView extends StatefulWidget {
  final List<FunctionOutput> functionOutput;

  GraphView(this.functionOutput);

  @override
  State<StatefulWidget> createState() {
    return _GraphViewState();
  }
}

class _GraphViewState extends State<GraphView> {
  Image graph;
  Int32List pixels;

  ui.Image graphImage;
  String miejscaZerowe;
  bool loaded = false;
  double functionScale = 10;

  double offsetX = 0;
  double offsetY = 0;

  @override
  void initState() {
    setState(() {
      graphImage = null;
      double width = 341;
      double height = 261;

      pixels = createImage(width: width.toInt(), height: height.toInt(), functionOutput: widget.functionOutput, scale: (1 / functionScale) * 100, offsetX: offsetX, offsetY: offsetY);

      ui.decodeImageFromPixels(pixels.buffer.asUint8List(), width.toInt(), height.toInt(), ui.PixelFormat.bgra8888, (ui.Image img) {
        graphImage = img;
      });
    });

    znajdzMiejscaZerowe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      graphImage = graphImage;
    });
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        title: Text("coś tam"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, left: 40, right: 40),
            color: Colors.white,
            child: loaded
                ? Container(
                    width: width,
                    height: height * 2 / 5,
                    color: Colors.white,
                    child: CustomPaint(
                      painter: GraphPainter(graphImage),
                      child: Container(
                        width: width,
                        height: height / 2,
                      ),
                    ),
                  )
                : Container(
                    height: height*2 / 5,
                    width: width,
                  ),
          ),
          Container(
            child: Text("Powiększenie"),
          ),
          Slider(
            onChanged: (double newVal) {
              setState(() {
                functionScale = newVal;
              });
            },
            label: '×' + (functionScale/10).toStringAsFixed(1),
            value: functionScale,
            max: 100,
            min: 1,
            onChangeEnd: (double newVal) {
              setState(() {
                functionScale = newVal;
                loaded = false;

                graphImage = null;
                double width = 341;
                double height = 261;

                pixels = createImage(width: width.toInt(), height: height.toInt(), functionOutput: widget.functionOutput, scale: (1 / functionScale) * 100, offsetX: offsetX, offsetY: offsetY);

                ui.decodeImageFromPixels(pixels.buffer.asUint8List(), width.toInt(), height.toInt(), ui.PixelFormat.bgra8888, (ui.Image img) {
                  graphImage = img;
                });
              });
            },
            divisions: 99,
          ),
          Container(
            child: Text("Przesunięcie"),
          ),
          Row(
            children: <Widget>[
              Slider(
                value: offsetX,
                onChanged: (double newVal) {
                  setState(() {
                    offsetX = newVal;
                  });
                },
                onChangeEnd: (double newVal) {
                  setState(() {
                    offsetX = newVal;
                    loaded = false;

                    graphImage = null;
                    double width = 341;
                    double height = 261;

                    pixels = createImage(width: width.toInt(), height: height.toInt(), functionOutput: widget.functionOutput, scale: (1 / functionScale) * 100, offsetX: offsetX, offsetY: offsetY);

                    ui.decodeImageFromPixels(pixels.buffer.asUint8List(), width.toInt(), height.toInt(), ui.PixelFormat.bgra8888, (ui.Image img) {
                      graphImage = img;
                    });
                  });
                },
                min: -10,
                max: 10,
                divisions: 40,
              ),
              Container(
                child: Text("X "),
              ),
              Container(
                child: Text(" Y"),
              ),
              Slider(
                value: offsetY,
                onChanged: (double newVal) {
                  setState(() {
                    offsetY = newVal;
                  });
                },
                onChangeEnd: (double newVal) {
                  setState(() {
                    offsetY = newVal;
                    loaded = false;

                    graphImage = null;
                    double width = 341;
                    double height = 261;

                    pixels = createImage(width: width.toInt(), height: height.toInt(), functionOutput: widget.functionOutput, scale: (1 / functionScale) * 100, offsetX: offsetX, offsetY: offsetY);

                    ui.decodeImageFromPixels(pixels.buffer.asUint8List(), width.toInt(), height.toInt(), ui.PixelFormat.bgra8888, (ui.Image img) {
                      graphImage = img;
                    });
                  });
                },
                min: -10,
                max: 10,
                divisions: 40,
              ),
            ],
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                loaded = true;
              });
            },
            child: Text("Załaduj"),
          ),
          Container(
            child: Text("jedna kratka odpowada : ${(functionScale / 10).toStringAsPrecision(2)}"),
          ),
          Container(
            child: Text("Miejsca zerowe: " + miejscaZerowe),
          )
        ],
      ),
    );
  }

  void znajdzMiejscaZerowe() {
    bool znaleziono = false;
    for (int i = 0; i < widget.functionOutput.length; i++) {
      if (widget.functionOutput[i].y == 0) {
        znaleziono = true;
        if (miejscaZerowe == null) {
          miejscaZerowe = widget.functionOutput[i].x.toString() + ", ";
        } else {
          miejscaZerowe += widget.functionOutput[i].x.toString() + ", ";
        }
      }
    }

    if (!znaleziono) {
      miejscaZerowe = "brak";
    }
  }
}

class GraphPainter extends CustomPainter {
  ui.Image graphImage;
  Int32List pixels;

  GraphPainter(this.graphImage);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(graphImage, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}

Int32List createImage({int width = 0, int height = 0, List<FunctionOutput> functionOutput, double scale = 10, double offsetX = 0, double offsetY = 0}) {
  Int32List pixels = new Int32List(width * height);

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = y * width + x;
      if (index >= pixels.length) {
        break;
      }

      pixels[index] = generatePixel(x, y, height, width, offsetX, offsetY);
    }
  }
  int lastPixelY;

  for (int i = 0; i < functionOutput.length; i++) {
    if (functionOutput[i].y == null || functionOutput[i].x == null) {
      continue;
    }

    int xcoordinate = -(functionOutput[i].x * scale + offsetX * 10).toInt();
    int ycoordinate = (functionOutput[i].y * scale - offsetY * 10).toInt();

    int pointindex = (-ycoordinate + 130) * width - xcoordinate + 170;

    if (pointindex < 0 || pointindex >= pixels.length) {
      continue;
    }

    pixels[pointindex] = Color.fromRGBO(255, 0, 0, 1.0).value;

    if (lastPixelY == null) {
      lastPixelY = ycoordinate;
    } else {
      int pixelsTorepaint = lastPixelY - ycoordinate;
      if (pixelsTorepaint > 0) {
        for (int y = 0; y <= pixelsTorepaint; y++) {
          int newindex = pointindex + y * width;
          if (newindex > 0 && newindex < pixels.length) {
            pixels[newindex] = Color.fromRGBO(255, 0, 0, 1.0).value;
          }
        }
      } else if (pixelsTorepaint < 0) {
        for (int y = 0; y >= pixelsTorepaint; y--) {
          int newindex = pointindex + y * width;
          if (newindex > 0 && newindex < pixels.length) {
            pixels[newindex] = Color.fromRGBO(255, 0, 0, 1.0).value;
          }
        }
      }
    }

    lastPixelY = ycoordinate;
  }

  return pixels;
}

int generatePixel(int x, int y, int height, int width, double offsetX, double offsetY) {
  if (x - (offsetX * 10) == 170 || y - (offsetY * 10) == 130) {
    return Color.fromRGBO(0, 0, 0, 1.0).value;
  } else if ((x - (offsetX * 10)) % 10 == 0 || (y - (offsetY * 10)) % 10 == 0) {
    return Color.fromRGBO(0, 0, 255, 0.3).value;
  } else {
    return Color.fromRGBO(170, 150, 150, 0.2).value;
  }
}
