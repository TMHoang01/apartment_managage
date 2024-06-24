import 'package:apartment_managage/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'rectangle_event.dart';
import 'rectangle_state.dart';

class RectangleBloc extends Bloc<RectangleEvent, RectangleState> {
  int _idCounter = 0;
  List<Rectangle> _rectangles = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RectangleBloc() : super(RectangleInitial()) {
    on<FestchRectangle>((event, emit) async {
      final data = await _firestore.collection('parking').get();
      _rectangles = data.docs
          .map((e) => Rectangle(
                e['id'],
                e['x'],
                e['y'],
                false,
                docId: data.docs[0].id,
                zone: e['zone'],
                slot: e['slot'],
                floor: e['floor'],
                width: e['w'],
                height: e['h'],
              ))
          .toList();
      _idCounter = _rectangles.length;
      emit(RectangleLoaded(List.from(_rectangles)));
    });
    on<AddRectangle>((event, emit) {
      final newRectangle = Rectangle(_idCounter++, event.dx, event.dy, true);
      _rectangles.add(newRectangle);
      emit(RectangSelected(List.from(_rectangles), newRectangle));
    });

    on<UpdateRectangle>((event, emit) {
      final index = _rectangles.indexWhere((r) => r.id == event.id);
      print('index: $index');
      if (index != -1 && _rectangles[index].isMovable) {
        final rectangle = _rectangles[index].copyWith(x: event.dx, y: event.dy);
        _rectangles[index] = rectangle;
        emit(RectangSelected(List.from(_rectangles), rectangle));
      }
    });

    on<SaveRectangle>((event, emit) {
      final index = _rectangles.indexWhere((r) => r.id == event.id);
      if (index != -1) {
        _rectangles[index] =
            _rectangles[index].copyWith(isMovable: false, modified: true);

        emit(RectangleLoaded(List.from(_rectangles)));
      }
    });

    on<EditRectangle>((event, emit) {
      final index = _rectangles.indexWhere((r) => r.id == event.id);
      if (index != -1) {
        final rectangle = _rectangles[index].copyWith(isMovable: true);
        _rectangles[index] = rectangle;

        // emit(RectangleLoaded(List.from(_rectangles)));
        emit(RectangSelected(List.from(_rectangles), rectangle));
      }
    });

    on<EditInfo>((event, emit) {
      final index = _rectangles.indexWhere((r) => r.id == event.item.id);
      if (index != -1) {
        _rectangles[index] = event.item.copyWith(isMovable: false);

        emit(RectangleLoaded(List.from(_rectangles)));
      }
    });

    on<DeleteRectangle>((event, emit) async {
      final item = _rectangles.firstWhere((r) => r.id == event.id);
      emit(RectangleLoaded(List.from(_rectangles)));
      if (item.docId != null) {
        await _firestore.collection('parking').doc(item.docId).delete();
        _rectangles.removeWhere((r) => r.id == event.id);
      }
    });

    on<SubmitRectangleFirebase>((event, emit) async {
      print('submit');
      logger.d('submit rectangles: ${_rectangles.length}');
      try {
        for (var ele in _rectangles) {
          print('ele: $ele');
          final data = {
            'id': ele.id,
            'x': ele.x,
            'y': ele.y,
            'h': ele.height,
            'w': ele.width,
            'zone': ele.zone ?? '',
            'slot': ele.slot ?? '',
            'floor': ele.floor,
            'type': 'car',
          };
          final docId = ele.docId;
          if (docId != null) {
            if (ele.modified == false) {
              continue;
            }
            await _firestore.collection('parking').doc(docId).update(data);
          } else {
            final a = await _firestore.collection('parking').add(data);
            ele = ele.copyWith(docId: a.id, isMovable: false);
          }
          print('ele: $ele');

          final index = _rectangles.indexWhere((r) => r.id == ele.id);
          if (index != -1) {
            _rectangles[index] = ele.copyWith(modified: false);
          }
        }
      } catch (e) {
        print('error: $e');
      }

      emit(RectangleLoaded(List.from(_rectangles)));
    });

    on<RotatedRectangle>((event, emit) async {
      if (state is RectangSelected) {
        final index = _rectangles
            .indexWhere((r) => r.id == (state as RectangSelected).item.id);
        if (index != -1) {
          // emit(RectangleLoaded(List.from(_rectangles)));
          final rectangle = _rectangles[index].copyWith(
              width: _rectangles[index].height,
              height: _rectangles[index].width);
          _rectangles[index] = rectangle;
          emit(RectangSelected(List.from(_rectangles), rectangle));
        }
      }
    });
  }
}
