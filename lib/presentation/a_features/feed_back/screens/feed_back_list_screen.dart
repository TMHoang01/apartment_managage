import 'package:apartment_managage/data/datasources/feed_back/feed_back_local.dart';
import 'package:apartment_managage/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/blocs/feed_backs/feed_backs_bloc.dart';
import 'package:apartment_managage/utils/constants.dart';

import 'widgets/widgets.dart';

class FeedBackListScreen extends StatefulWidget {
  const FeedBackListScreen({super.key});

  @override
  State<FeedBackListScreen> createState() => _FeedBackListScreenState();
}

class _FeedBackListScreenState extends State<FeedBackListScreen> {
  final scrollController = ScrollController();
  final Map<String, String?> filter = {};
  late FeedbackLocalDataSource local = FeedbackLocalDataSource();

  @override
  void initState() {
    super.initState();
    final _feedBackBloc = context.read<FeedBacksBloc>();
    if (_feedBackBloc.state is FeedBacksInitial) {
      _initFetch(context);
    }

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll < 200) {
        _loadMore();
      }
    });
  }

  void _initFetch(BuildContext context) {
    context.read<FeedBacksBloc>().add(FeedBacksStarted());
  }

  void _loadMore() {
    final bloc = context.read<FeedBacksBloc>();
    if (bloc.state is FeedBacksLoadingMore ||
        bloc.state is FeedBacksLoadMoreEnd) return;
    context.read<FeedBacksBloc>().add(FeedBacksLoadMoreStarted());
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý phản ánh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<FeedBacksBloc>().add(FeedBacksStarted());
            },
          ),
        ],
      ),
      body: SizedBox(
        child: BlocBuilder<FeedBacksBloc, FeedBacksState>(
          builder: (ctx, state) {
            return RefreshIndicator(
              onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
                _initFetch(context);
              }),
              child: _builderState(ctx, state),
            );
          },
        ),
      ),
    );
  }

  Widget _builderState(BuildContext context, FeedBacksState state) {
    return switch (state) {
      FeedBacksLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      FeedBacksLoaded(feedBacks: final feedBacks) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              _builderFilterHeader(context, state),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedBacks.length,
                itemBuilder: (context, index) {
                  final feedBack = feedBacks[index].copyWith(
                      content: '$index - ${feedBacks[index].content}');

                  return ItemFeedBack(feedBack);
                },
              ),
              // CustomButton(
              //   title: 'clear',
              //   onPressed: () {
              //     local.clear();
              //   },
              // ),
              // CustomButton(
              //   title: 'add',
              //   onPressed: () {
              //     local.addFeedbacks(feedBacks
              //         .sublist(feedBacks.length > 16 ? 16 : feedBacks.length));
              //     // local.clear();
              //   },
              // ),
              // CustomButton(
              //   title: 'get',
              //   onPressed: () {
              //     print('get');
              //     local.getFeedback();
              //   },
              // ),
            ],
          ),
        ),
      FeedBacksLoadingMore(oldPosts: final oldPosts) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              _builderFilterHeader(context, state),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: oldPosts.length + 1,
                itemBuilder: (context, index) {
                  if (index < oldPosts.length) {
                    final feedBack = oldPosts[index];
                    return ItemFeedBack(feedBack);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              // CustomButton(
              //   title: 'clear',
              //   onPressed: () {
              //     local.clear();
              //   },
              // ),
              // CustomButton(
              //   title: 'add',
              //   onPressed: () {
              //     local.addFeedbacks(oldPosts
              //         .sublist(oldPosts.length > 16 ? 16 : oldPosts.length));
              //     // local.clear();
              //   },
              // ),
              // CustomButton(
              //   title: 'get',
              //   onPressed: () {
              //     print('get');
              //     local.getFeedback();
              //   },
              // ),
            ],
          ),
        ),
      FeedBacksFailure(message: final message) => InkWell(
          onTap: () => _initFetch(context),
          child: Center(
            child: Text(message),
          ),
        ),
      _ => Center(
          child: Text('$state'),
        )
    };
  }

  Widget _builderFilterHeader(BuildContext context, FeedBacksState state) {
    _item(FeedBackStatus? status, bool isSelected) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kSecondaryLightColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {
            if (status != null) {
              context.read<FeedBacksBloc>().add(
                    FeedBacksFilter(
                      filter: {'status': status.toJson()},
                    ),
                  );
            } else {
              context.read<FeedBacksBloc>().add(
                    const FeedBacksFilter(),
                  );
            }
          },
          child: Text(
            status == null ? 'Tất cả' : status.toName(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    Widget gap = const SizedBox(width: 8);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _item(null, state.filter == null),
            gap,
            ...FeedBackStatus.values.map(
              (e) => Row(
                children: [
                  _item(e, state.filter?['status'] == e.toJson()),
                  gap,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
