import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';

class ImageInputPiker extends StatefulWidget {
  final String? url;
  final int limitSize;
  final bool? isEmpty;
  final Function(File?)? onFileSelected;
  // default limit 2MB
  ImageInputPiker(
      {super.key,
      this.url,
      this.onFileSelected,
      this.limitSize = 2 * 1024 * 1024,
      this.isEmpty = false});

  @override
  State<ImageInputPiker> createState() => _ImageInputPikerState();
}

class _ImageInputPikerState extends State<ImageInputPiker> {
  final picker = ImagePicker();

  File? file;
  void onFileSelected(File? selectedFile) {
    // Gọi callback để truyền file vào parent screen
    widget.onFileSelected!(selectedFile);
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        // imageQuality: 50,
      );
      if (pickedFile != null) {
        // check size
        if (File(pickedFile.path).lengthSync() > widget.limitSize) {
          showSnackBar(
            context,
            "Vui lòng chọn ảnh có dung lượng nhỏ hơn 2MB",
            Colors.red,
          );
          return;
        }
        setState(() {
          file = (File(pickedFile.path));
          onFileSelected(file);
        });
        // onImageSelected(file);
      } else {}
    } on PlatformException catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1.0),
      ),
      // color: Colors.yellow,
      child: InkWell(
        onTap: () {
          // logger.i('onTap ${widget.url} file: $file');
          getImage();
          logger.i('check file: ${widget.isEmpty}');
        },
        child: CustomImageView(
          height: 150,
          // width: 150,
          file: file,
          url: widget.url,
        ),
      ),
    );
  }
}
