import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {super.key,
      this.alignment,
      this.width,
      this.margin,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.initialValue,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator,
      this.errorText,
      this.readOnly = false,
      this.onChanged,
      this.controller,
      this.onFieldSubmitted,
      this.focusNode,
      this.nextFocusNode});

  Alignment? alignment;
  double? width;
  EdgeInsetsGeometry? margin;
  Function(String)? onFieldSubmitted;
  bool? readOnly;
  Function(String)? onChanged;
  bool? isObscureText;
  TextInputAction? textInputAction;
  TextInputType? textInputType;
  int? maxLines;
  String? initialValue;
  String? hintText;
  Widget? prefix;
  BoxConstraints? prefixConstraints;
  Widget? suffix;
  BoxConstraints? suffixConstraints;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  String? errorText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: widget.width ?? double.infinity,
      margin:
          widget.margin ?? const EdgeInsets.only(left: 20, right: 20, top: 4),
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        initialValue: widget.initialValue,
        controller: widget.controller ?? null,
        focusNode: widget.focusNode,
        onFieldSubmitted: (_) => widget.onFieldSubmitted,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        obscureText: widget.isObscureText!,
        textInputAction: widget.textInputAction,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: widget.validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      labelText: widget.hintText ?? "",
      prefixIcon: widget.prefix,
      prefixIconConstraints: widget.prefixConstraints,
      suffixIcon: widget.suffix,
      suffixIconConstraints: widget.suffixConstraints,
      errorText: widget.errorText,
    );
  }
}
