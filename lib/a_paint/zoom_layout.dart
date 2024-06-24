import 'package:apartment_managage/a_paint/bloc/rectangle_bloc.dart';
import 'package:apartment_managage/a_paint/bloc/rectangle_event.dart';
import 'package:apartment_managage/a_paint/bloc/rectangle_state.dart';
import 'package:apartment_managage/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Interactive Parking Map')),
        body: Column(
          children: [
            BlocProvider(
              create: (context) => RectangleBloc()..add(FestchRectangle()),
              child: ParkingMap(),
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingMap extends StatefulWidget {
  @override
  _ParkingMapState createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  final TransformationController _transformationController =
      TransformationController();

  TapDownDetails _doubleTapDetails = TapDownDetails();
  late final rectangleBloc = BlocProvider.of<RectangleBloc>(context);

  final pointXController = TextEditingController();
  final pointYController = TextEditingController();
  get getX => double.parse(pointXController.text);
  get getY => double.parse(pointYController.text);

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Matrix4 matrix = Matrix4.identity();
    final double _imageWidth = 406.7;
    final double _imageHeight = 240.8;
    // Calculate target point coordinates
    final targetX = _imageWidth / 3;
    final targetY = _imageHeight / 3;
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    // printMatrix();
    // Calculate the center point of the visible part of the image
    final matrix = _transformationController.value;

    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();
    final centerX = -translation.x / scale +
        (MediaQuery.of(context).size.width / (2 * scale));
    final centerY = -translation.y / scale +
        (MediaQuery.of(context).size.height / (2 * scale));

    print('Center of the visible part of the image: ($centerX, $centerY)');

    _transformationController.value.getMaxScaleOnAxis();

    setState(() {
      // final matrix = _transformationController.value;
      // _currentScale = matrix.getMaxScaleOnAxis();
      // _currentTranslation = matrix.getTranslation();
    });
  }

  String getPoint() {
    return '[x: ${pointXController.text}, y: ${pointYController.text}]';
  }

  void printMatrix() {
    // Lấy ma trận biến đổi hiện tại
    final Matrix4 matrix = _transformationController.value;

    // Lấy hệ số scale
    final double scale = matrix.getMaxScaleOnAxis();

    // Lấy tọa độ dịch chuyển (translation)
    final translation = matrix.getTranslation();

    print('Scale: $scale');
    print('Translation: $translation');
    print(getPoint());
  }

  Offset checkInBoundScale(
      double dx, double dy, double scale, double width, double height) {
    Offset ponitA = Offset(width / scale / 2, height / scale / 2);
    Offset ponitB = Offset(width - width / scale / 2, height / scale / 2);
    Offset ponitC = Offset(width / scale / 2, height - height / scale / 2);
    Offset ponitD =
        Offset(width - width / scale / 2, height - height / scale / 2);

    Offset point = Offset(dx, dy);
    print(' A(${ponitA.dx}, ${ponitA.dy})');
    print(' B(${ponitB.dx}, ${ponitB.dy})');
    print(' D(${ponitD.dx}, ${ponitD.dy})');
    print(' C(${ponitC.dx}, ${ponitC.dy})');
    print(' Check(${point.dx}, ${point.dy})');

    // kiểm tra ponit có nằm trong ABCD không
    if (point.dx > ponitA.dx &&
        point.dx < ponitB.dx &&
        point.dy > ponitA.dy &&
        point.dy < ponitC.dy) {
      print('point in bound:');
      return point;
    }

    // return điểm gần nhất trong A,B,C,D nếu nằm ngoài ABCD

    if (point.dx < width / 2) {
      if (point.dy < height / 2) {
        print('point out bound: A');
        return ponitA;
      } else {
        print('point out bound: C');

        return ponitC;
      }
    } else {
      if (point.dy < height / 2) {
        print('point out bound: B');

        return ponitB;
      } else {
        print('point out bound: D');

        return ponitD;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            final Matrix4 matrix = _transformationController.value;

            final double scale = matrix.getMaxScaleOnAxis();

            // Lấy tọa độ dịch chuyển (translation)
            final translation = matrix.getTranslation();

            // Tính vị so với renalX
            double renalXValue = double.parse(pointXController.text);
            double renalYValue = double.parse(pointYController.text);
            final double centerX = renalXValue;
            final double centerY = renalYValue;
            rectangleBloc.add(AddRectangle(
              centerX,
              centerY,
            ));
          },
        ),
        ElevatedButton(
            onPressed: () {
              const initialScale = 2.0;
              const xOffset = -(319.173828125 * initialScale) + (406.7 / 2);
              final yOffset = -(177.783203125 * initialScale) + (240.8 / 2);
              _transformationController.value = Matrix4.identity()
                ..translate(xOffset, yOffset)
                ..scale(initialScale);
            },
            child: const Text('go default')),
        ElevatedButton(
            onPressed: () {
              final Matrix4 matrix = Matrix4.identity();
              _transformationController.value = matrix;
            },
            child: Text('go default')),
        ElevatedButton(
            onPressed: () {
              double dx = getX;
              double dy = getY;
              Offset defaultCenter = Offset(406.7 / 2, 240.8 / 2);
              final scale = 3.0;
              Offset newCenter = checkInBoundScale(dx, dy, scale, 406.7, 240.8);
              final double xOffset = -(newCenter.dx * scale) + (406.7 / 2);
              final double yOffset = -(newCenter.dy * scale) + (240.8 / 2);
              print('xOffset: $xOffset, yOffset: $yOffset');
              _transformationController.value = Matrix4.identity()
                ..translate(xOffset, yOffset)
                ..scale(scale);
            },
            child: Text('go 40, 40')),
        Center(
          child: GestureDetector(
            // onDoubleTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: () {
              final position = _doubleTapDetails.localPosition;
              final double scale =
                  _transformationController.value.getMaxScaleOnAxis();
              _transformationController.value = Matrix4.identity()
                ..translate(-getX * (scale - 1), -getX * (scale - 1))
                ..scale(scale * 2.0 > 4.0 ? 1.0 : 2.0, 2.0, 2.0);

              print(
                  'double tap at: ${_doubleTapDetails.localPosition}  gobal  ${_doubleTapDetails.globalPosition}');
            },
            onTapUp: (details) {
              // Vị trí tương đối trên màn hình khi chạm
              Offset position = details.localPosition;

              // Ma trận biến đổi hiện tại
              Matrix4 matrix = _transformationController.value;

              // Chuyển đổi vị trí chạm từ hệ tọa độ hiển thị sang hệ tọa độ của ảnh
              Matrix4 inverseMatrix = Matrix4.inverted(matrix);
              Offset transformedPosition =
                  MatrixUtils.transformPoint(inverseMatrix, position);

              // Vị trí của điểm trên ảnh
              double imageX = transformedPosition.dx;
              double imageY = transformedPosition.dy;
              pointXController.text = imageX.toString();
              pointYController.text = imageY.toString();
              print('Tọa độ điểm nhấn: ($imageX, $imageY)');
              checkInBoundScale(imageX, imageY, 2.0, 406.7, 240.8);
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              // panEnabled: true,
              // boundaryMargin: const EdgeInsets.all(double.infinity),

              minScale: 0.1,
              maxScale: 4.0,
              child: BlocBuilder<RectangleBloc, RectangleState>(
                builder: (context, state) {
                  if (state is RectangleLoaded) {
                    return Stack(children: [
                      Image.asset('assets/floor_plan_1.jpg'),
                      Transform.translate(
                        offset: const Offset(9, 2), // Tọa độ x và y
                        child: Container(
                          width: 6,
                          height: 13,
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                      ...state.rectangles.map((rectangle) {
                        return ItemParkLot(
                          rectangleBloc: rectangleBloc,
                          slot: rectangle,
                        );
                      }),
                    ]);
                  }
                  return const Center(
                    child: Text('Press + to add a rectangle'),
                  );
                },
              ),
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            // Lấy ma trận biến đổi hiện tại
            final Matrix4 matrix = _transformationController.value;

            // Lấy hệ số scale
            final double scale = matrix.getMaxScaleOnAxis();

            // Lấy tọa độ dịch chuyển (translation)
            final translation = matrix.getTranslation();
            setState(() {
              // dịch chuyển x [1,0,0]
              matrix.translate(1.0, 0.0, 0.0);
              matrix.scale(2.0); // Tùy chỉnh mức độ phóng to (2.0 chỉ là ví dụ)
              // Áp dụng ma trận biến
              _transformationController.value = matrix;
            });
            printMatrix();
          },
          child: Icon(Icons.info),
        ),
        const FormItem(),
        ElevatedButton(
          onPressed: () async {
            // print('object ${rectangleBloc.state}');
            rectangleBloc.add(const SubmitRectangleFirebase());
          },
          child: const Text('Submitfirebase'),
        ),
      ],
    );
  }
}

class ItemParkLot extends StatelessWidget {
  const ItemParkLot({
    super.key,
    required this.rectangleBloc,
    required this.slot,
  });

  final RectangleBloc rectangleBloc;
  final Rectangle slot;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: slot.x,
      top: slot.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (slot.isMovable) {
            rectangleBloc.add(UpdateRectangle(
              slot.id,
              slot.x + details.delta.dx,
              slot.y + details.delta.dy,
            ));
          }
        },
        onLongPress: () {
          if (!slot.isMovable) {
            rectangleBloc.add(EditRectangle(slot.id));
          } else {
            rectangleBloc.add(SaveRectangle(slot.id));
          }
        },
        child: Container(
          width: slot.width,
          height: slot.height,
          color: slot.isMovable ? Colors.blue : Colors.red,
          child: Center(
            child: RotatedBox(
              quarterTurns: slot.width > slot.height ? 0 : 3,
              child: Text(
                slot.name,
                style: const TextStyle(
                  fontSize: 5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormItem extends StatefulWidget {
  const FormItem({
    super.key,
  });

  @override
  State<FormItem> createState() => _FormItemState();
}

class _FormItemState extends State<FormItem> {
  final _formKey = GlobalKey<FormState>();
  final _zoneController = TextEditingController();
  final _lotController = TextEditingController();

  @override
  void dispose() {
    _zoneController.dispose();
    _lotController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final rectangleBloc = BlocProvider.of<RectangleBloc>(context);
    if (rectangleBloc.state is RectangSelected) {
      final item = (rectangleBloc.state as RectangSelected).item;
      _zoneController.text = item.zone ?? '';
      _lotController.text = item.slot ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RectangleBloc, RectangleState>(
      builder: (context, state) {
        if (state is RectangSelected) {
          return Form(
              key: _formKey,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      final bloc = BlocProvider.of<RectangleBloc>(context);
                      final item = (bloc.state as RectangSelected).item;
                      bloc.add(DeleteRectangle(item.id));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<RectangleBloc>(context)
                          .add(const RotatedRectangle());
                    },
                    icon: const Icon(Icons.rotate_right),
                  ),
                  TextFormField(
                    controller: _zoneController,
                    decoration: InputDecoration(
                      labelText: 'Zone',
                      hintText: 'Enter your name',
                      suffixIcon: IconButton(
                          onPressed: () {
                            final listZone = ['A', 'B', 'C', 'D', 'E', 'F'];
                            setState(() {
                              _zoneController.text = listZone[
                                  (listZone.indexOf(_zoneController.text) + 1) %
                                      listZone.length];
                            });
                          },
                          icon: Icon(Icons.add)),
                      prefixIcon: IconButton(
                          onPressed: () {
                            final listZone = ['A', 'B', 'C', 'D', 'E', 'F'];
                            setState(() {
                              _zoneController.text = listZone[
                                  (listZone.indexOf(_zoneController.text) - 1) %
                                      listZone.length];
                            });
                          },
                          icon: Icon(Icons.add)),
                    ),
                  ),
                  TextFormField(
                    controller: _lotController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'sô lot',
                      hintText: 'Enter your email',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            // try parse catch 1
                            try {
                              _lotController.text =
                                  (int.parse(_lotController.text) + 1)
                                      .toString();
                            } catch (e) {
                              _lotController.text = '1';
                            }
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            // try parse catch 1
                            try {
                              final res = (int.parse(_lotController.text) - 1);
                              _lotController.text =
                                  res > 0 ? res.toString() : '1';
                            } catch (e) {
                              _lotController.text = '1';
                            }
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        // Process data.
                        final item = (state as RectangSelected).item.copyWith(
                              zone: _zoneController.text,
                              slot: _lotController.text,
                            );
                        print(item.toString());
                        BlocProvider.of<RectangleBloc>(context)
                            .add(EditInfo(item));
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ));
        } else {
          if (state is RectangleLoaded) {
            Map<String, List<Rectangle>> map = {};
            state.rectangles.forEach((element) {
              if (map.containsKey(element.zone)) {
                // check key exist
                map[element.zone]!.add(element);
              } else {
                map[element.zone ?? 'F'] = [element];
              }
            });
            map.entries.forEach((element) {
              print('key: ${element.key}');
              element.value.forEach((element) {
                // print('value: ${element.id}');
              });
            });
          }
        }
        return Container();
      },
    );
  }
}
