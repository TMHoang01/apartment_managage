import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/post/event.dart';
import 'package:apartment_managage/domain/models/post/news.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_detail/post_detail_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/posts/posts_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/widgets/content_event_detail.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/widgets/content_news_detail.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isPinned = false;
  final double _expandedHeight = 200;
  final blocDetail = sl.get<PostDetailBloc>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!_isPinned &&
          _scrollController.hasClients &&
          _scrollController.offset > _expandedHeight) {
        setState(() {
          _isPinned = true;
        });
      } else if (_isPinned &&
          _scrollController.hasClients &&
          _scrollController.offset < _expandedHeight) {
        setState(() {
          _isPinned = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  void _deletePostInlist(BuildContext context) {
    context.read<PostsBloc>().add(PostDeleteStarted(post: widget.post));
    navService.pop(context);
  }

  void _navigateToPostEditScreen(BuildContext context) {
    final post = switch (blocDetail.state) {
      PostDetailLoadSuccess(post: final post) => post,
      _ => widget.post,
    };
    if (post != null) {
      final bloc = sl.get<PostFormBloc>()..add(PostFormEditInit(post));
      bloc.stream.listen(
        (state) {
          if (state is PostFormInProcess) {
            blocDetail.add(const PostDetailLoadStarted());
          }
          if (state is PostFormEditSuccess) {
            context.read<PostsBloc>().add(PostsUpdateStarted(post: state.post));
            blocDetail.add(PostDetailModifyStarted(post: state.post));
            bloc.close();
            //showSnackBar(context, 'Sửa bài viết thành công', Colors.green);
          }
        },
      );
      navService.pushNamed(context, RouterAdmin.postAdd, args: bloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PostModel post = widget.post;

    return Scaffold(
      body: BlocProvider.value(
        value: blocDetail,
        child: BlocConsumer<PostDetailBloc, PostDetailState>(
          listener: (context, state) {
            if (state is PostDetailDeleteSuccess) {
              showSnackBar(context, 'Xóa bài viết thành công', Colors.green);
              _deletePostInlist(context);
              // navService.pop(context);
            } else if (state is PostDetailLoadFailure) {
              showSnackBar(context, state.error, Colors.red);
            } else if (state is PostDetailLoadSuccess) {
              post = state.post;
            }
          },
          builder: (txt, state) {
            if (state is PostDetailLoadSuccess) {
              post = state.post;
            }
            return switch (state) {
              PostDetailLoadInProgress() => Stack(
                  children: [
                    _buildPostDetail(context, post),
                    Container(
                      color: Colors.white70,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              _ => _buildPostDetail(context, post),
            };
          },
        ),
      ),
    );
  }

  Widget _buildPostDetail(BuildContext context, PostModel post) {
    Size size = MediaQuery.of(context).size;

    return switch (post.type) {
      PostType.event => ContentEventsDetail(
          post: post as EventModel,
          isPinned: _isPinned,
          scrollController: _scrollController,
          onBottomUpEditPressed: () => _navigateToPostEditScreen(context),
        ),
      PostType.news => ContentNewsDetails(
          post: post as NewsModel,
          isPinned: _isPinned,
          scrollController: _scrollController,
          onBottomUpEditPressed: () => _navigateToPostEditScreen(context),
        ),
      _ => ContentNewsDetails(
          post: post,
          isPinned: _isPinned,
          scrollController: _scrollController,
          onBottomUpEditPressed: () => _navigateToPostEditScreen(context),
        ),
    };
  }
}
