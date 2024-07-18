import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/posts_accept/posts_accept_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/widgets/post_accept_card.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/widgets/post_card.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListAccpetScreen extends StatefulWidget {
  const PostListAccpetScreen({super.key});

  @override
  State<PostListAccpetScreen> createState() => _PostListAccpetScreenState();
}

class _PostListAccpetScreenState extends State<PostListAccpetScreen> {
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => sl.get<PostsAcceptBloc>()..add(PostsAcceptStarted()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Duyệt bài đăng'),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
            context.read<PostsAcceptBloc>().add(PostsAcceptStarted());
          }),
          child: Container(
            width: size.width,
            height: size.height,
            color: kOfWhite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildListPost(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return BlocBuilder<PostsAcceptBloc, PostsAcceptState>(
      builder: (context, state) {
        return (switch (state) {
          PostsAcceptLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          PostsAcceptLoaded(list: final list) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final post = list[index];
                return PostAccpetCardWidget(post: post);
              },
            ),
          PostsAcceptError(error: final error) => Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<PostsAcceptBloc>().add(PostsAcceptStarted());
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
