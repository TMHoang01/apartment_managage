import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/products/product_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/custom_image_view.dart';
import 'package:apartment_managage/presentation/widgets/custom_input.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  @override
  void initState() {
    context.read<ManageProductBloc>().add(GetManageProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBuilder(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // //sreach bar
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   child: CustomTextFormField(
            //     hintText: "Tìm kiếm",
            //     suffix: const Icon(Icons.search),
            //   ),
            // ),

            BlocBuilder<ManageProductBloc, ManageProductState>(
              builder: (context, state) {
                if (state is ManageProductLoading ||
                    state is ManageProductInitial) {
                  return const CircularProgressIndicator();
                }
                if (state is ManageProductError) {
                  return const Text("Load product failure");
                }
                if (state is ManageProductSuccess) {
                  List<ProductModel> products =
                      context.read<ManageProductBloc>().listProducts;
                  logger.i(products.length);
                  int length = products.length;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: length,
                        itemBuilder: (ctt, index) {
                          ProductModel product = products[index];
                          return InkWell(
                            onTap: () {
                              logger.d(product);
                              navService.pushNamed(
                                  context, RouterAdmin.productEdit,
                                  args: product);
                            },
                            child: ListTile(
                              leading: CustomImageView(
                                url: product.imageUrl,
                                width: 54,
                                height: 54,
                                boxFit: BoxFit.cover,
                              ),
                              title: Text(
                                '${product.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${TextFormat.formatMoney(product.price ?? 0)}đ',
                                style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return Text('No data found');
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBuilder(BuildContext context) {
    return AppBar(
      title: const Text("Danh sách sản phẩm"),
      actions: [
        // item add prodcut
        IconButton(
          style: ButtonStyle(),
          onPressed: () {
            navService.pushNamed(context, RouterAdmin.productAdd);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  _showPopupMenu(BuildContext context, ProductModel product) {
    navService.pushNamed(context, RouterAdmin.productDetail, args: product);
  }
}
