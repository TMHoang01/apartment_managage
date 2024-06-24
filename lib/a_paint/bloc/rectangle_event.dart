import 'package:apartment_managage/a_paint/bloc/rectangle_state.dart';
import 'package:equatable/equatable.dart';

abstract class RectangleEvent extends Equatable {
  const RectangleEvent();

  @override
  List<Object> get props => [];
}

class FestchRectangle extends RectangleEvent {
  const FestchRectangle();

  @override
  List<Object> get props => [];
}

class AddRectangle extends RectangleEvent {
  final double dx;
  final double dy;
  const AddRectangle(this.dx, this.dy);
}

class UpdateRectangle extends RectangleEvent {
  final int id;
  final double dx;
  final double dy;

  const UpdateRectangle(this.id, this.dx, this.dy);

  @override
  List<Object> get props => [id, dx, dy];
}

class SaveRectangle extends RectangleEvent {
  final int id;

  const SaveRectangle(this.id);

  @override
  List<Object> get props => [id];
}

class EditRectangle extends RectangleEvent {
  final int id;

  const EditRectangle(this.id);

  @override
  List<Object> get props => [id];
}

class EditInfo extends RectangleEvent {
  final Rectangle item;

  const EditInfo(this.item);

  @override
  List<Object> get props => [item];
}

class DeleteRectangle extends RectangleEvent {
  final int id;

  const DeleteRectangle(this.id);

  @override
  List<Object> get props => [id];
}

class SubmitRectangleFirebase extends RectangleEvent {
  const SubmitRectangleFirebase();

  @override
  List<Object> get props => [];
}

class RotatedRectangle extends RectangleEvent {
  const RotatedRectangle();

  @override
  List<Object> get props => [];
}
