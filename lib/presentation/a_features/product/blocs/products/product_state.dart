part of 'product_bloc.dart';

sealed class ManageProductState extends Equatable {
  const ManageProductState();

  @override
  List<Object> get props => [];
}

final class ManageProductInitial extends ManageProductState {}

final class ManageProductInProgress extends ManageProductState {
  final int progress;
  const ManageProductInProgress(this.progress);
  @override
  List<Object> get props => [progress];

  ManageProductInProgress copyWith({
    int? progress,
  }) {
    return ManageProductInProgress(
      progress ?? this.progress,
    );
  }
}

final class ManageProductLoading extends ManageProductState {}

final class ManageProductSuccess extends ManageProductState {
  final List<ProductModel> products;
  const ManageProductSuccess(this.products);
  @override
  List<Object> get props => [products];

  ManageProductSuccess copyWith({
    List<ProductModel>? products,
  }) {
    return ManageProductSuccess(
      products ?? this.products,
    );
  }
}

final class ManageProductError extends ManageProductState {
  final String error;
  const ManageProductError(this.error);
  @override
  List<Object> get props => [error];
}
