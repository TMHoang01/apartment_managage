import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/domain/repository/file_repository.dart';
import 'package:apartment_managage/domain/repository/ecom/product_repository.dart';
import 'package:apartment_managage/utils/logger.dart';

part 'product_event.dart';
part 'product_state.dart';

class ManageProductBloc extends Bloc<ManageProductEvent, ManageProductState> {
  final ProductRepository productRepository;
  final FileRepository fileRepository;
  late List<ProductModel> listProducts;

  ManageProductBloc(
      {required this.productRepository, required this.fileRepository})
      : super(ManageProductInitial()) {
    on<ManageProductEvent>((event, emit) {});
    on<CreateManageProductEvent>(_createManageProduct);
    on<DeleteManageProductEvent>(_deleteManageProduct);
    on<GetManageProductsEvent>(_fetchManageProducts);
    on<ManageProductDetailEvent>(_productDetail);
  }
  FutureOr<void> _createManageProduct(
      CreateManageProductEvent event, Emitter<ManageProductState> emit) async {
    emit(ManageProductLoading());
    try {
      String imageUrl = '';
      if (event.image != null) {
        File file = event.image!;
        // update images random name
        String name = DateTime.now().millisecondsSinceEpoch.toString();
        name = '$name.${file.path.split('.').last}';

        imageUrl = await fileRepository.uploadFile(
          file: file,
          path: 'images/products/$name',
          onProgress: (percentage) {
            logger.w('Uploading file image: $percentage');
            emit(ManageProductInProgress(percentage));
          },
        );
      }
      final ProductModel newManageProduct = await productRepository.add(
        name: event.name,
        description: event.description,
        price: event.price,
        imageUrl: imageUrl,
      );
      listProducts.add(newManageProduct);
      emit(ManageProductSuccess(listProducts));
    } catch (e) {
      logger.e(e);
      emit(ManageProductError(e.toString()));
    }
  }

  FutureOr<void> _deleteManageProduct(
      DeleteManageProductEvent event, Emitter<ManageProductState> emit) async {
    emit(ManageProductLoading());
    try {
      await productRepository.delete(id: event.id);
      listProducts.removeWhere((element) => element.id == event.id);
      logger.i('ManageProduct deleted successfully');
      emit(ManageProductSuccess(listProducts));
    } catch (e) {
      logger.e(e);
      emit(ManageProductError(e.toString()));
    }
  }

  FutureOr<void> _fetchManageProducts(
      GetManageProductsEvent event, Emitter<ManageProductState> emit) async {
    emit(ManageProductLoading());
    try {
      listProducts = await productRepository.getAll();
      emit(ManageProductSuccess(listProducts));
    } catch (e) {
      logger.e(e);
      emit(ManageProductError(e.toString()));
    }
  }

  FutureOr<ProductModel> _productDetail(
      ManageProductDetailEvent event, Emitter<ManageProductState> emit) async {
    return listProducts.firstWhere((element) => element.id == event.id);
  }
}
