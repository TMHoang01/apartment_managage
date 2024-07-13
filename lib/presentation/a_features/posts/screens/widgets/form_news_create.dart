import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/post/news.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';

class FormNewsCreate extends StatefulWidget {
  final PostModel? post;
  final Function(PostModel post, String image)? handleSubmit;
  const FormNewsCreate({super.key, this.post, this.handleSubmit});

  @override
  State<FormNewsCreate> createState() => _FormNewsCreateState();
}

class _FormNewsCreateState extends State<FormNewsCreate> {
  final _keyForm = GlobalKey<FormState>();
  late final post = widget.post;
  late String? id;
  final _titleController = TextEditingController(text: 'Hoangf');
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PostFormBloc>().state;
    if (bloc is PostFormEditStarting) {
      final post = bloc.post as NewsModel;
      id = post.id;
      _titleController.text = post.title ?? '';
      _contentController.text = post.content ?? '';
    } else {
      id = post?.id;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();

    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (!_keyForm.currentState!.validate()) {
      showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
      return;
    }
    if (_imageController.text.isEmpty && post?.image == null) {
      showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
      return;
    } else {
      NewsModel post = NewsModel(
        title: _titleController.text,
        content: _contentController.text,
        image: widget.post?.image,
      );
      if (id != null) {
        post = post.copyWith(id: id);
      }
      widget.handleSubmit!(post, _imageController.text)();
      // if (context.read<PostFormBloc>().state is PostFormEditStarting) {
      //   context.read<PostFormBloc>().add(
      //         PostFormEditStart(
      //           post: post.copyWith(id: id),
      //           image: _imageController.text,
      //         ),
      //       );
      // } else {
      //   context.read<PostFormBloc>().add(
      //         PostFormCreateStart(
      //           post: post,
      //           image: _imageController.text,
      //         ),
      //       );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = CustomButton(
      title: 'Xác nhận',
      onPressed: () {
        logger.i('onPressed submit button');
        _handleSubmit(context);
      },
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Form(
        key: _keyForm,
        child: Column(
          children: [
            SizedBox(
              // height: 150,
              child: ImageInputPiker(
                url: switch (context.read<PostFormBloc>().state) {
                  PostFormEditStarting(post: final post) => post.image,
                  _ => null,
                },
                onFileSelected: (file) {
                  _imageController.text = file!.path;
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _titleController,
              hintText: 'Nhập tiêu đề bài viết',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tiêu đề';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _contentController,
              maxLines: 5,
              hintText: 'Nhập nội dung bài viết',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            submitButton,
          ],
        ),
      ),
    );
  }
}
