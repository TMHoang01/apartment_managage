import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_detail_state.dart';

class ManaganeProductDetailCubit extends Cubit<ManageProductDetailState> {
  ManaganeProductDetailCubit() : super(const FormValidatorUpdate());

  void initForm({
    String id = '',
    String email = '',
    String name = '',
    double price = 0.0,
    String description = '',
    String categoryId = '',
    String imageUrl = '',
    bool obscureText = true,
  }) {
    emit(FormValidatorUpdate(
      id: id,
      name: name,
      price: price,
      description: description,
      categoryId: categoryId,
      imageUrl: imageUrl,
      obscureText: obscureText,
    ));
  }

  void changeName(String? name) {
    emit(state.copyWith(name: name));
  }

  void changePrice(double? price) {
    emit(state.copyWith(price: price));
  }

  void changeQuantity(int? quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void changeDescription(String? description) {
    emit(state.copyWith(description: description));
  }

  void changeCategory(String? categoryId) {
    emit(state.copyWith(categoryId: categoryId));
  }

  void changeImageUrl(String? imageUrl) {
    emit(state.copyWith(imageUrl: imageUrl));
  }

  void changeImageFile(File? imageFile) {
    emit(state.copyWith(imageFile: imageFile));
  }

  void changeAutovalidateMode(AutovalidateMode? autovalidateMode) {
    emit(state.copyWith(autovalidateMode: autovalidateMode));
  }

  void updateAutovalidateMode(AutovalidateMode? autovalidateMode) {
    emit(state.copyWith(autovalidateMode: autovalidateMode));
  }

  void toggleObscureText() {
    emit(state.copyWith(obscureText: !state.obscureText));
  }

  void reset() {
    emit(FormValidatorUpdate());
  }
}
