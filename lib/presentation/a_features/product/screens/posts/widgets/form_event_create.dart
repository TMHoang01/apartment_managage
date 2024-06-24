import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/post/event.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class FormEventCreate extends StatefulWidget {
  final PostModel? post;
  final Function(PostModel post, String image)? handleSubmit;

  FormEventCreate({super.key, this.post, this.handleSubmit});

  @override
  State<FormEventCreate> createState() => _FormEventCreateState();
}

class _FormEventCreateState extends State<FormEventCreate> {
  late final post = widget.post as EventModel?;
  final _keyForm = GlobalKey<FormState>();
  final _typePost = PostType.event;
  final _imageController = TextEditingController();
  final _titleController = TextEditingController(text: 'Sự kiện');
  final _contentController = TextEditingController(text: 'Nội dung sự kiện');
  final _localtionController = TextEditingController(text: 'Địa điểm tổ chức');
  final _maxJoinersController = TextEditingController(text: '100');
  final _beginDateController =
      TextEditingController(text: TextFormat.formatDate(DateTime.now()));
  final _endDateController =
      TextEditingController(text: TextFormat.formatDate(DateTime.now()));
  late String? id;
  bool _showLimitInput = false;
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PostFormBloc>().state;
    if (bloc is PostFormEditStarting) {
      final post = bloc.post as EventModel;
      id = post.id;
      _titleController.text = post.title ?? '';
      _contentController.text = post.content ?? '';
      _localtionController.text = post.location ?? '';
      _maxJoinersController.text = post.maxJoiners?.toString() ?? '';
      _beginDateController.text =
          TextFormat.formatDate(post.beginDate ?? DateTime.now());
      _endDateController.text =
          TextFormat.formatDate(post.endDate ?? DateTime.now());
      _showLimitInput = post.limitJoiners ?? false;
    }
    id = post?.id;
  }

  @override
  void dispose() {
    _imageController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _localtionController.dispose();
    _maxJoinersController.dispose();
    _beginDateController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (!_keyForm.currentState!.validate()) {
      showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
      return;
    }
    //else if (_imageController.text.isEmpty) {
    //   showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
    //   return;
    // }
    else {
      EventModel post = EventModel(
        id: id,
        title: _titleController.text,
        content: _contentController.text,
        type: _typePost,
        location: _localtionController.text,
        beginDate: TextFormat.parseJsonFormat(_beginDateController.text),
        endDate: TextFormat.parseJsonFormat(_endDateController.text),
        limitJoiners: _showLimitInput,
        maxJoiners:
            _showLimitInput ? int.parse(_maxJoinersController.text) : null,
        image: widget.post?.image,
      );
      if (id != null) {
        post = post.copyWith(id: id);
      }
      widget.handleSubmit!(post, _imageController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = CustomButton(
      title: 'Xác nhận',
      onPressed: () {
        _handleSubmit(context);
      },
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Form(
        key: _keyForm,
        child: Column(
          children: [
            BlocBuilder<PostFormBloc, PostFormState>(
              builder: (context, state) {
                if (state is PostFormEditStarting) {
                  final post = state.post as EventModel;
                }
                return SizedBox(
                  // height: 300,
                  child: ImageInputPiker(
                    url: state is PostFormEditStarting
                        ? (state.post as EventModel).image
                        : null,
                    onFileSelected: (file) {
                      _imageController.text = file!.path;
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _titleController,
              hintText: 'Nhập tiêu đề',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: PickerDateInput(
                      context,
                      title: 'Bắt đầu',
                      controller: _beginDateController,
                      onDateSelected: (date) {
                        // _dates = date;
                        _beginDateController.text = TextFormat.formatDate(date);
                      },
                      margin: const EdgeInsets.only(top: 4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PickerDateInput(
                      context,
                      title: 'Kết thúc',
                      controller: _endDateController,
                      onDateSelected: (date) {
                        _endDateController.text = TextFormat.formatDate(date);
                      },
                      margin: const EdgeInsets.only(top: 4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _localtionController,
              hintText: 'Địa điểm',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa điểm tổ chức';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _showLimitInput,
                    onChanged: (value) {
                      setState(() {
                        _showLimitInput = value!;
                      });
                    },
                  ),
                  const Text('Giới hạn số lượng người tham gia'),
                ],
              ),
            ),
            if (_showLimitInput)
              Column(
                children: [
                  CustomTextFormField(
                    controller: _maxJoinersController,
                    hintText: 'Số lượng giới hạn',
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số lượng người tham gia';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            const SizedBox(height: 16),
            submitButton,
          ],
        ),
      ),
    );
  }
}
