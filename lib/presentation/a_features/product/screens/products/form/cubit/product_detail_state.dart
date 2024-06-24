part of 'product_detail_cubit.dart';

abstract class ManageProductDetailState extends Equatable {
  final AutovalidateMode autovalidateMode;
  final String? id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String categoryId;
  final String imageUrl;
  final File? imageFile;
  final bool obscureText;

  const ManageProductDetailState({
    this.id,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.name = '',
    this.price = 0.0,
    this.quantity = 0,
    this.description = '',
    this.categoryId = '',
    this.imageUrl = '',
    this.imageFile,
    this.obscureText = true,
  });

  ManageProductDetailState copyWith({
    AutovalidateMode? autovalidateMode,
    String? name,
    double? price,
    int? quantity,
    String? description,
    String? categoryId,
    String? imageUrl,
    File? imageFile,
    bool? obscureText,
  });
}

class FormValidatorUpdate extends ManageProductDetailState {
  const FormValidatorUpdate({
    String? id,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    String name = '',
    double price = 0.0,
    int quantity = 0,
    String description = '',
    String imageUrl = '',
    File? imageFile,
    bool obscureText = true,
    String categoryId = '',
  }) : super(
          id: id,
          autovalidateMode: autovalidateMode,
          name: name,
          price: price,
          description: description,
          categoryId: categoryId,
          quantity: quantity,
          imageUrl: imageUrl,
          imageFile: imageFile,
          obscureText: obscureText,
        );

  @override
  FormValidatorUpdate copyWith({
    String? id,
    AutovalidateMode? autovalidateMode,
    String? name,
    double? price,
    int? quantity,
    String? description,
    String? categoryId,
    String? imageUrl,
    File? imageFile,
    bool? obscureText,
  }) {
    return FormValidatorUpdate(
      id: id ?? this.id,
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      obscureText: obscureText ?? this.obscureText,
    );
  }

  @override
  List<Object?> get props => [
        autovalidateMode,
        name,
        price,
        quantity,
        description,
        categoryId,
        imageUrl,
        imageFile,
        obscureText
      ];
}
