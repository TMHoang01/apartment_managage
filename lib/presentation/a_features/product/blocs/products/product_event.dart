part of 'product_bloc.dart';

sealed class ManageProductEvent extends Equatable {
  const ManageProductEvent();

  @override
  List<Object> get props => [];
}

class CreateManageProductEvent extends ManageProductEvent {
  final String name;
  final String description;
  final double price;
  final File? image;
  final int quantity;
  final String categoryId;

  const CreateManageProductEvent({
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.quantity,
    required this.categoryId,
  });
}

class GetManageProductsEvent extends ManageProductEvent {}

class UpdateManageProductEvent extends ManageProductEvent {
  final String id;
  final String name;
  final String description;
  final double price;
  final File image;
  final String category;

  const UpdateManageProductEvent(this.id, this.name, this.description,
      this.price, this.image, this.category);
}

class DeleteManageProductEvent extends ManageProductEvent {
  final String id;

  const DeleteManageProductEvent(this.id);
}

class ManageProductDetailEvent extends ManageProductEvent {
  final String id;

  const ManageProductDetailEvent(this.id);
}
