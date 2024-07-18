import 'dart:io';

import 'package:apartment_managage/presentation/a_features/posts/blocs/posts_accept/posts_accept_bloc.dart';
import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAccpetCardWidget extends StatelessWidget {
  final PostModel post;
  const PostAccpetCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kGrayLight.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: BlocBuilder<PostsAcceptBloc, PostsAcceptState>(
        builder: (context, state) {
          PostModel pos = post;
          if (state is PostsAcceptLoaded) {
            pos = (state as PostsAcceptLoaded)
                .list
                .firstWhere((element) => element.id == pos.id);
          }
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                height: 144,
                child: InkWell(
                  onTap: () => _onNavigateToPostDetail(context),
                  child: Row(
                    children: [
                      CustomImageView(
                        url: pos.image ?? '',
                        width: size.width * 0.3,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${pos.title}',
                                      maxLines: 1,
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${post.content}',
                                      style: theme.textTheme.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ChipCard(
                                    label: pos.typeString,
                                  ),
                                  const SizedBox(width: 8),
                                  pos.createdAt == null
                                      ? const SizedBox()
                                      : ChipCard(
                                          label: TextFormat.formatDate(
                                          pos.createdAt,
                                        )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (pos.status == 'pending')
                  ?
                  // Text('data'):           Text('data'),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          onPressed: () {
                            context
                                .read<PostsAcceptBloc>()
                                .add(PostsAcceptChangeStatus(post, 'rejected'));
                          },
                          title: 'Từ chối',
                          backgroundColor: kSecondaryColor,
                          height: size.width * 0.1,
                          width: size.width * 0.4,
                        ),
                        CustomButton(
                          onPressed: () {
                            context
                                .read<PostsAcceptBloc>()
                                .add(PostsAcceptChangeStatus(post, 'active'));
                          },
                          title: 'Chấp nhận',
                          height: size.width * 0.1,
                          width: size.width * 0.4,
                        ),
                      ],
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  _onNavigateToPostDetail(BuildContext context) {
    navService.pushNamed(context, RouterAdmin.postDetail, args: post);
  }
}
