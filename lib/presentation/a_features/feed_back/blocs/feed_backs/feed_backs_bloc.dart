import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/domain/repository/feed_back/feed_back_repository.dart';
import 'package:apartment_managage/utils/constants.dart';

part 'feed_backs_event.dart';
part 'feed_backs_state.dart';

class FeedBacksBloc extends Bloc<FeedBacksEvent, FeedBacksState> {
  final FeedBackRepository feedBackRepository;
  FeedBacksBloc(this.feedBackRepository) : super(FeedBacksInitial()) {
    on<FeedBacksEvent>((event, emit) {});
    on<FeedBacksStarted>(_onFeedBacksStarted, transformer: droppable());
    on<FeedBacksLoadMoreStarted>(_onFeedBacksLoadMored,
        transformer: droppable());
    on<FeedBacksUpdateItem>(_onFeedBacksUpdateItem);
    on<FeedBacksFilter>(_onFeedBacksFilter);
  }

  List<FeedBackModel> list = [];
  Map<String, String>? filter;
  bool isLoadMore = false;
  bool isLoadMoreEnd = false;

  Future<void> _onFeedBacksStarted(
      FeedBacksStarted event, Emitter<FeedBacksState> emit) async {
    emit(FeedBacksLoading());
    try {
      list = [];
      list = await feedBackRepository.getAll();
      emit(FeedBacksLoaded(feedBacks: list));
    } catch (e) {
      emit(FeedBacksFailure(message: e.toString()));
    }
  }

  Future<void> _onFeedBacksFilter(
      FeedBacksFilter event, Emitter<FeedBacksState> emit) async {
    if (state is FeedBacksLoaded) {
      try {
        // emit(FeedBacksLoading());
        filter = event.filter;
        list = [];
        emit(FeedBacksLoadingMore(oldPosts: list, filter: filter));
        list = await feedBackRepository.getAll(filter: filter);
        emit(FeedBacksLoaded(feedBacks: list, filter: filter));
      } catch (e) {
        emit(FeedBacksFailure(message: e.toString()));
      }
    }
  }

  Future<void> _onFeedBacksLoadMored(
      FeedBacksLoadMoreStarted event, Emitter<FeedBacksState> emit) async {
    if (state is FeedBacksLoading) return;
    if (state is FeedBacksLoaded || state is FeedBacksLoadMoreFailure) {
      try {
        DateTime? lastCreateAt = list.last.createdAt;

        emit(FeedBacksLoadingMore(oldPosts: list, filter: filter));
        // await Future.delayed(const Duration(seconds: 1));

        final feedBacksNew = await feedBackRepository.getAll(
            lastCreateAt: lastCreateAt, limit: LIMIT_PAGE, filter: filter);

        list.addAll(feedBacksNew);
        if (feedBacksNew.isEmpty || feedBacksNew.length < LIMIT_PAGE) {
          emit(FeedBacksLoadMoreEnd(feedBacks: list, filter: filter));
          return;
        } else {
          emit(FeedBacksLoaded(feedBacks: list, filter: filter));
        }
      } catch (e) {
        emit(FeedBacksLoadMoreFailure(oldPosts: list, message: e.toString()));
      }
    }
  }

  Future<void> _onFeedBacksUpdateItem(
      FeedBacksUpdateItem event, Emitter<FeedBacksState> emit) async {
    if (state is FeedBacksLoaded) {
      final feedBack = event.feedBack;
      if (filter != null && filter!['status'] == feedBack.status?.toJson()) {
        list = list.map((e) => e.id == feedBack.id ? feedBack : e).toList();
      } else {
        list = list.where((e) => e.id != feedBack.id).toList();
        if (list.length < LIMIT_PAGE / 2 && state is FeedBacksLoadMoreEnd) {
          list.insert(0, feedBack);
        }
      }
      emit(FeedBacksLoaded(feedBacks: list, filter: filter));
    }
  }

  @override
  Future<void> close() {
    feedBackRepository.dispose();
    return super.close();
  }
}
