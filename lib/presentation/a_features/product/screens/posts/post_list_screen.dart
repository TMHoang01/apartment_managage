import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/posts/posts_bloc.dart';
import 'package:apartment_managage/presentation/a_features/product/screens/posts/widgets/post_card.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';

// final  context.read<PostsBloc>() = sl.get<PostsBloc>()..add(PostsStarted());

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>
// with AutomaticKeepAliveClientMixin<PostsScreen>
{
  // @override
  // bool get wantKeepAlive => true;

  final List<PostFormBloc> _postCreateBlocs = [];
  _handleNewPostBtn(BuildContext context) {
    // show bottompopup
    showBottomSheetApp(
      context: context,
      title: 'Tạo bài đăng',
      child: Column(
        children: [
          ListTile(
            title: const Text('Tạo bài viết'),
            onTap: () {
              navService.pop(context);
              _navigateToPostCreateScreen(context, PostType.news);
            },
          ),
          ListTile(
            title: const Text('Tạo sự kiện'),
            onTap: () {
              navService.pop(context);
              _navigateToPostCreateScreen(context, PostType.event);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToPostCreateScreen(BuildContext context, PostType type) {
    final bloc = sl.get<PostFormBloc>()..add(PostFormCreateInit(type));
    setState(() {
      _postCreateBlocs.insert(0, bloc);
    });
    bloc.stream.listen(
      (state) {
        if (state is PostFormCreateSuccess) {
          setState(() {
            _postCreateBlocs.remove(bloc);
          });
          bloc.close();
        }
      },
    );

    navService.pushNamed(context, RouterAdmin.postAdd, args: bloc);
  }

  _handlePostReTry(PostFormBloc bloc) {
    final state = bloc.state as PostFormFailure;

    bloc.add(PostFormCreateRetryStart(
      title: state.post.title ?? '',
      content: state.post.content ?? '',
      imagePath: state.post.image ?? '',
    ));
  }

  Widget _buildFailurePost(PostFormBloc bloc) {
    final state = bloc.state as PostFormFailure;
    final theme = Theme.of(context);

    final pendingPost = Stack(
      children: [
        PostCardWidget(
          post: state.post,
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white70,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: theme.colorScheme.error,
                  ),
                  Text(
                    state.error,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      _handlePostReTry(bloc);
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return pendingPost;
  }

  Widget _buildPendingPost(PostFormInProcess state) {
    final pendingPost = Stack(
      children: [
        PostCardWidget(
          post: state.post,
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white70,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
    return pendingPost;
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    Size size = MediaQuery.of(context).size;

    final pendingPosts = _postCreateBlocs.map(
      (bloc) {
        return BlocProvider.value(
          value: bloc,
          child: BlocConsumer<PostFormBloc, PostFormState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is PostFormCreateSuccess) {
                context
                    .read<PostsBloc>()
                    .add(PostInsertStarted(post: state.post));
              }
            },
            builder: (context, state) {
              if (state is PostFormInProcess) {
                return _buildPendingPost(state);
              } else if (state is PostFormFailure) {
                return _buildFailurePost(bloc);
              }
              return const SizedBox();
            },
          ),
        );
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Bài đăng'),
        actions: [
          IconButton(
            onPressed: () {
              _handleNewPostBtn(context);
            },
            icon: const Icon(
              Icons.add,
              // color: Colors.white,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Đăng xuất'),
              ),
            ],
          ),
        ],
      ),
      body: BlocProvider.value(
        value: context.read<PostsBloc>(),
        child: Container(
          width: size.width,
          height: size.height,
          color: kOfWhite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  //sreach bar
                // CustomTextFormField(
                //   margin: const EdgeInsets.all(10),
                //   hintText: 'Tìm kiếm',
                //   suffix: const Icon(Icons.search),
                // ),
                // // status filter
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         ChipCard(
                //           label: 'Tất cả',
                //           backgroundColor: kPrimaryColor,
                //           onTap: () {
                //             context.read<PostsBloc>().add(PostsStarted());
                //           },
                //         ),
                //         const ChipCard(
                //           label: 'Chờ xác nhận',
                //         ),
                //         const ChipCard(
                //           label: 'Đã xác nhận',
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),
                ...pendingPosts,
                // PostCardWidget(
                //   post: PostModel(
                //     title: 'title',
                //     content: 'content',
                //     image: 'https://picsum.photos/200/300',
                //   ),
                // ),
                _buildListPost(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: context.read<PostsBloc>(),
      builder: (context, state) {
        return (switch (state) {
          PostsLoadInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
          PostsLoadSuccess(posts: final posts) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCardWidget(post: post);
              },
            ),
          PostsLoadFailure(error: final error) => Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<PostsBloc>().add(PostsStarted());
                },
                child: Text(error),
              ),
            ),
          _ => const SizedBox(),
        });
      },
    );
  }
}
