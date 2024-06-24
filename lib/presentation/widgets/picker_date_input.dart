import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/text_format.dart';

class PickerDateInput extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final TextEditingController? controller;
  final BuildContext context;
  final String? title;
  final EdgeInsets? margin;
  const PickerDateInput(this.context,
      {super.key,
      required this.onDateSelected,
      this.title,
      this.margin,
      this.controller});

  @override
  State<PickerDateInput> createState() => _PickerDateInputState();
}

class _PickerDateInputState extends State<PickerDateInput> {
  DateTime dates = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      margin:
          widget.margin ?? const EdgeInsets.only(left: 20, right: 20, top: 4),
      hintText: widget.title ?? 'Chọn thờ gian',
      controller: widget.controller,
      textInputType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập chọn thời gian';
        }
        return null;
      },
      suffix: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () {
          showDatePicker(
            context: widget.context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2050),
          ).then((value) {
            if (value != null) {
              widget.onDateSelected(value);
              setState(() {
                dates = value;
                widget.controller!.text = TextFormat.formatDate(value);
              });
            }
          });
        },
      ),
    );
  }
}
