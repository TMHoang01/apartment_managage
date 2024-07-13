import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/category/category_bloc.dart';
import 'package:apartment_managage/presentation/a_features/product/screens/form/cubit/product_detail_cubit.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/products/product_bloc.dart';
import 'package:apartment_managage/domain/models/ecom/category_model.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';
import 'package:apartment_managage/presentation/widgets/custom_button.dart';
import 'package:apartment_managage/presentation/widgets/custom_input.dart';
import 'package:apartment_managage/presentation/widgets/image_input.dart';

class ProductFormDetail extends StatefulWidget {
  const ProductFormDetail({super.key, this.product});

  final ProductModel? product;

  @override
  State<ProductFormDetail> createState() => _ProductFormDetailState();
}

class _ProductFormDetailState extends State<ProductFormDetail> {
  final ManaganeProductDetailCubit _formValidatorCubit =
      ManaganeProductDetailCubit();

  final _formKey = GlobalKey<FormState>();
  FocusNode? _focusNode;
  final ManaganeProductDetailCubit formCubit = ManaganeProductDetailCubit();

  late final ProductModel? product;

  @override
  void initState() {
    final ProductModel? product = widget.product;

    formCubit.initForm(
      name: product?.name ?? "",
      price: product?.price ?? 0,
      id: product?.id ?? "",
      imageUrl: product?.imageUrl ?? "",
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productId = widget.product?.id;

    return BlocProvider(
      create: (context) => formCubit,
      child: BlocListener<ManageProductBloc, ManageProductState>(
        listener: (context, state) {
          if (state is ManageProductSuccess) {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actionsIconTheme: const IconThemeData(color: kRed),
              actions: [
                // item add prodcut
                widget.product != null
                    ? IconButton(
                        onPressed: () {
                          // show dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Xác nhận"),
                                content: const Text(
                                    "Bạn có chắc chắn muốn xóa sản phẩm này không?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<ManageProductBloc>().add(
                                          DeleteManageProductEvent(productId!));
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Xác nhận"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Hủy"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : const SizedBox(),
              ],
              title: Text(widget.product != null
                  ? "Sửa sản phẩm"
                  : "Thêm mới sản phẩm"),
            ),
            body: SingleChildScrollView(
              child: widget.product != null
                  ? productForm(context)
                  : productForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget productForm(BuildContext context) {
    return BlocBuilder<ManaganeProductDetailCubit, ManageProductDetailState>(
      bloc: _formValidatorCubit,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                height: 120,
                width: 120,
                padding: const EdgeInsets.all(8),
                child: ImageInputPiker(
                  url: state.imageUrl,
                  onFileSelected: (File? selectedFile) {
                    _formValidatorCubit.changeImageFile(selectedFile);
                  },
                ),
              ),
              CustomTextFormField(
                initialValue: state.name,
                focusNode: _focusNode,
                // nextFocusNode: ,
                hintText: "Tên sản phẩm",
                onChanged: (value) {
                  _formValidatorCubit.changeName(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tên sản phẩm không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                initialValue: state.price.toString(),
                hintText: "Giá sản phẩm",
                textInputType: TextInputType.number,
                onChanged: (value) {
                  _formValidatorCubit.changePrice(double.parse(value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Giá sản phẩm không được để trống";
                  }
                  if (double.tryParse(value) == null) {
                    return "Giá sản phẩm không hợp lệ";
                  }
                  double price = double.parse(value);
                  if (price < 0) {
                    return "Giá sản phẩm không được nhỏ hơn 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: "Số lượng",
                textInputType: TextInputType.number,
                onChanged: (value) {
                  _formValidatorCubit.changeQuantity(int.parse(value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Số lượng không được để trống";
                  }
                  // not int value
                  if (int.tryParse(value) == null) {
                    return "Vui lòng nhập số lượng hợp lệ";
                  }
                  int quantity = int.parse(value);
                  if (quantity < 0) {
                    return "Số lượng không được nhỏ hơn 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is CategoryError) {
                    return InkWell(
                        onTap: () {
                          context
                              .read<CategoryBloc>()
                              .add(GetCategoriesEvent());
                        },
                        child: const Text("Lỗi không thể tải danh mục"));
                  }
                  if (state is CategoryLoaded) {
                    List<Category> categories =
                        context.watch<CategoryBloc>().categories;
                    // sao chép lại tất cả categories
                    // categories = [...categories, ...categories];
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 4),
                      child: DropdownButtonFormField<Category>(
                        borderRadius: BorderRadius.circular(8),
                        decoration: InputDecoration(
                          labelText: "Danh mục",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: kOfWhite,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 6),
                        ),
                        itemHeight: 50,
                        menuMaxHeight: 200,
                        isExpanded: true,
                        items: categories
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.title ?? ""),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (value) {
                          // Add your onChanged code here!
                          _formValidatorCubit.changeCategory(value!.id);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Danh mục không được để trống";
                          }
                          return null;
                        },
                      ),
                    );
                  }
                  return Text("$state");
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: "Lưu",
                onPressed: () {
                  final state = _formValidatorCubit.state;
                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else if ((state.imageUrl == null ||
                          state.imageUrl.isEmpty) &&
                      state.imageFile == null) {
                    // show error snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vui lòng chọn ảnh sản phẩm"),
                      ),
                    );

                    return;
                  } else {
                    context.read<ManageProductBloc>().add(
                          CreateManageProductEvent(
                            name: state.name,
                            price: state.price,
                            quantity: state.quantity,
                            image: state.imageFile,
                            categoryId: state.categoryId,
                            description: state.description,
                          ),
                        );
                    logger.i("Form is valid");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _formValidatorCubit.close();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
