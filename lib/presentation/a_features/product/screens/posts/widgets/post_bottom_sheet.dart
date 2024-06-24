import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_detail/post_detail_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/posts/posts_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';

class PostBottomSheet extends StatefulWidget {
  const PostBottomSheet(
      {super.key,
      required this.context,
      required this.post,
      this.child,
      this.onEditPressed,
      this.onDeletePressed});
  final BuildContext context;
  final PostModel post;
  final Widget? child;

  final Function? onEditPressed;
  final Function? onDeletePressed;

  @override
  State<PostBottomSheet> createState() => _PostBottomSheetState();
}

class _PostBottomSheetState extends State<PostBottomSheet> {
  late final PostDetailBloc blocDetail;
  // late PostModel post;
  @override
  void initState() {
    blocDetail = widget.context.read<PostDetailBloc>();
    // post = switch (blocDetail.state) {
    //   PostDetailLoadSuccess(post: final post) => post,
    //   _ => post,
    // };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // phần dữ liệu dùng chung
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Chỉnh sửa '),
          onTap: () {
            navService.pop(context);
            widget.onEditPressed!();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Xóa'),
          onTap: () {
            navService.pop(context);
            _handleDeletePost(context);
          },
        ),
        // phần có thể thêm vào
        //. ...

        // Column(
        //   children: [
        //     const Divider(),
        //     ListTile(
        //       leading: const Icon(Icons.person_add),
        //       title: const Text('Mời bạn bè'),
        //       onTap: () {
        //         navService.pop(context);
        //       },
        //     ),
        //     ListTile(
        //       leading: const Icon(Icons.share),
        //       title: const Text('Chia sẻ'),
        //       onTap: () {
        //         navService.pop(context);
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
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

  void _handleDeletePost(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa bài viết này không?'),
          actions: [
            TextButton(
              onPressed: () {
                navService.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                blocDetail.add(PostDetailDeleteStarted(post: widget.post));
                navService.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
