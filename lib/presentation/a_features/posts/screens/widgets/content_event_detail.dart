import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/post/event.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/widgets/post_bottom_sheet.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';

class ContentEventsDetail extends StatefulWidget {
  const ContentEventsDetail({
    super.key,
    required this.post,
    required ScrollController scrollController,
    required bool isPinned,
    this.onBottomUpEditPressed,
    this.onBottomUpDeletePressed,
  })  : _scrollController = scrollController,
        _isPinned = isPinned;
  final ScrollController _scrollController;
  final bool _isPinned;
  final EventModel post;
  final Function? onBottomUpEditPressed;
  final Function? onBottomUpDeletePressed;

  @override
  State<ContentEventsDetail> createState() => _ContentEventsDetailState();
}

class _ContentEventsDetailState extends State<ContentEventsDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    final EventModel post = widget.post;
    return NestedScrollView(
      controller: widget._scrollController,
      scrollBehavior:
          // This only wraps scrollbars around the header <---
          ScrollConfiguration.of(context).copyWith(scrollbars: true),
      headerSliverBuilder: (BuildContext cxt, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: widget._isPinned ? kPrimaryColor : Colors.white70,
            elevation: 0,
            expandedHeight: size.height * 0.3,
            pinned: true,
            title: widget._isPinned
                ? AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Text(
                      '${post.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
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
                      onEditPressed: widget.onBottomUpEditPressed,
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Chi tiết"),
                Tab(text: "Người tham dụ"),
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context),
            child: _buildCotent(context),
          ),
          Text("Service"),
        ],
      ),
    );
  }

  Widget _buildCotent(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
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
                  '${widget.post.title}',
                  style: theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TextFormat.formatDate(widget.post.beginDate!),
                      style: theme.textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      ' - ',
                      style: theme.textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      TextFormat.formatDate(widget.post.endDate!),
                      style: theme.textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.location}',
                      style: theme.textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.people_alt_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.title}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: theme.textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widget.post.content}',
                style: theme.textTheme.labelLarge!.copyWith(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
