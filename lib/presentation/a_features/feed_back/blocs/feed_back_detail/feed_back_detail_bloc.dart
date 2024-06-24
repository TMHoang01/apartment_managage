import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/domain/repository/feed_back/feed_back_repository.dart';
import 'package:apartment_managage/utils/firebase.dart';

part 'feed_back_detail_event.dart';
part 'feed_back_detail_state.dart';

class FeedBackDetailBloc
    extends Bloc<FeedBackDetailEvent, FeedBackDetailState> {
  final FeedBackRepository feedBackRepository;
  FeedBackDetailBloc(this.feedBackRepository) : super(FeedBackDetailInitial()) {
    on<FeedBackDetailEvent>((event, emit) {});
    on<FeedBackDetailStarted>(_onFeedBackDetailStart);
    on<FeedBackDetailChangeStatus>(_onFeedBackDetailChangeStatus,
        transformer: droppable());
    on<FeedBackDetailUpdateSubmit>(_onFeedBackDetailUpdateSubmit,
        transformer: droppable());
  }

  void _onFeedBackDetailStart(
      FeedBackDetailStarted event, Emitter<FeedBackDetailState> emit) async {
    emit(FeedBackDetailLoading());
    try {
      // final String id = event.feedBack.id ?? '';
      // if (id.isEmpty) {
      //   throw Exception('Không xác định phản ánh cần xem');
      // }
      // final feedBack = await feedBackRepository.getById(id: id);
      // if (feedBack == null) {
      //   throw Exception('Không tìm thấy phản ánh');
      // }
      emit(FeedBackDetailLoaded(feedBack: event.feedBack));
    } catch (e) {
      emit(FeedBackDetailFailure(message: e.toString()));
    }
  }

  void _onFeedBackDetailChangeStatus(FeedBackDetailChangeStatus event,
      Emitter<FeedBackDetailState> emit) async {
    final oldFeedBack = state.feedBack;
    final id = state.feedBack?.id;
    emit(FeedBackDetailLoading());
    try {
      final status = event.status;
      await feedBackRepository.changeStatus(id: id, status: status);
      final feedBack = oldFeedBack!.copyWith(status: status);
      emit(FeedBackDetailUpdated(feedBack: feedBack));
    } catch (e) {
      emit(FeedBackDetailFailure(message: e.toString(), feedBack: oldFeedBack));
    }
  }

  void _onFeedBackDetailUpdateSubmit(FeedBackDetailUpdateSubmit event,
      Emitter<FeedBackDetailState> emit) async {
    final oldFeedBack = state.feedBack;
    emit(FeedBackDetailLoading());
    try {
      await feedBackRepository.update(
          feedBack: event.fb.copyWith(updatedBy: userCurrent!.id));
      emit(FeedBackDetailUpdated(feedBack: event.fb));
    } catch (e) {
      emit(FeedBackDetailFailure(message: e.toString(), feedBack: oldFeedBack));
    }
  }
}
