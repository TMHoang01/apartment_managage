// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apartment_managage/utils/constants.dart';

class CustomImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  String? svgPath;

  ///[file] is required parameter for fetching image file
  File? file;

  double? height;
  double? width;
  Color? color;
  BoxFit? boxFit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? borderRadius;
  BoxBorder? border;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    Key? key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.boxFit,
    this.alignment,
    this.onTap,
    this.borderRadius,
    this.margin,
    this.border,
    this.placeHolder = ImageConstant.imgNotFound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null || borderRadius != null) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
        ),
        child: _buildImageView(),
      );
    } else {
      return SizedBox(height: height, width: width, child: _buildImageView());
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SvgPicture.asset(
        svgPath!,
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.cover,
        color: color,
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.cover,
        color: color,
      );
    } else if (url != null && url!.isNotEmpty) {
      return CachedNetworkImage(
        fit: boxFit ?? BoxFit.cover,
        imageUrl: url!,
        color: color,
        placeholder: (context, url) => SizedBox(
          // height: 30,
          // width: 30,
          child: LinearProgressIndicator(
            color: Colors.grey.shade200,
            backgroundColor: kGray,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          placeHolder,
          height: height,
          width: width,
          fit: boxFit ?? BoxFit.cover,
          color: kGray,
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.cover,
        color: color,
      );
    }
    return Image.asset(
      placeHolder,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.cover,
    );
  }
}
