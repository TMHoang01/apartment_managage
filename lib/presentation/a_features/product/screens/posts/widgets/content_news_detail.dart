import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/a_features/product/screens/posts/widgets/post_bottom_sheet.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';

class ContentNewsDetails extends StatelessWidget {
  ContentNewsDetails({
    super.key,
    required ScrollController scrollController,
    required bool isPinned,
    required this.post,
    this.onBottomUpEditPressed,
    this.onBottomUpDeletePressed,
  })  : _scrollController = scrollController,
        _isPinned = isPinned;
  final ScrollController _scrollController;
  final bool _isPinned;
  final PostModel post;
  final Function? onBottomUpEditPressed;
  final Function? onBottomUpDeletePressed;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          backgroundColor: _isPinned ? kPrimaryColor : Colors.white70,
          elevation: 0,
          expandedHeight: size.height * 0.3,
          pinned: true,
          title: _isPinned
              ? AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: Text(
                    '${post.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          flexibleSpace: FlexibleSpaceBar(
            background: CustomImageView(
              url: post.image,
              width: size.width,
              height: size.height * 0.3,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showBottomSheetApp(
                  context: context,
                  child: PostBottomSheet(
                    context: context,
                    post: post,
                    onEditPressed: onBottomUpEditPressed,
                  ),
                );
              },
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.title}',
                      style: theme.textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    if (post.createdAt != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: kGrayLight,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            TextFormat.formatDate(post.createdAt),
                            style: theme.textTheme.labelLarge!.copyWith(
                              color: kGrayLight,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${post.content}',
                    style: theme.textTheme.labelLarge!.copyWith(fontSize: 18)),
              ),
              Container(
                height: 2000,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
