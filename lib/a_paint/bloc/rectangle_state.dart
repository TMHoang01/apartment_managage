import 'package:equatable/equatable.dart';

class Rectangle extends Equatable {
  final String? docId;
  final int id;
  final double x;
  final double y;
  final double width;
  final double height;
  final String floor;
  final String? zone;
  final String? slot;
  final String type = 'Car';
  final bool isMovable;
  final bool? modified;

  get name => '$slot-$zone-';

  Rectangle(this.id, this.x, this.y, this.isMovable,
      {this.docId,
      this.zone,
      this.slot,
      this.floor = "1",
      this.width = 6,
      this.height = 15,
      this.modified = false});

  Rectangle copyWith({
    String? docId,
    int? id,
    double? x,
    double? y,
    double? width,
    double? height,
    bool? isMovable,
    String? zone,
    String? slot,
    String? floor,
    bool? modified,
  }) {
    return Rectangle(
      id ?? this.id,
      x ?? this.x,
      y ?? this.y,
      isMovable ?? this.isMovable,
      zone: zone ?? this.zone,
      slot: slot ?? this.slot,
      docId: docId ?? this.docId,
      width: width ?? this.width,
      height: height ?? this.height,
      floor: floor ?? this.floor,
      modified: modified ?? this.modified,
    );
  }

  @override
  List<Object?> get props =>
      [id, x, y, width, height, floor, zone, slot, docId, isMovable, modified];
}

abstract class RectangleState extends Equatable {
  const RectangleState();

  @override
  List<Object> get props => [];
}

class RectangleInitial extends RectangleState {}

class RectangleLoaded extends RectangleState {
  final List<Rectangle> rectangles;

  const RectangleLoaded(this.rectangles);

  @override
  List<Object> get props => [rectangles];
}

class RectangSelected extends RectangleLoaded {
  final Rectangle item;

  RectangSelected(List<Rectangle> rectangles, this.item) : super(rectangles);

  @override
  List<Object> get props => [rectangles, item];
}
