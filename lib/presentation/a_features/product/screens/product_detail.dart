import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/presentation/widgets/custom_image_view.dart';
import 'package:apartment_managage/utils/app_styles.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/text_format.dart';
import 'package:flutter/material.dart';

class AdminProductDetail extends StatelessWidget {
  const AdminProductDetail({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiết sản phẩm"),
          actions: [
            IconButton(
              onPressed: () {
                // context.go(AppRouter.settings);
              },
              icon: const Icon(Icons.add_location_alt),
            ),
          ],
        ),
        body: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomImageView(
                  url: product?.imageUrl,
                  width: double.infinity,
                  height: size.height * 0.36,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                product?.name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              child: Text(
                                "${TextFormat.formatMoney(product?.price ?? 0)}đ",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Mô tả sản phẩm",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product?.description ?? '',
                        style: appStyle(15, Colors.grey, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              // Expanded(
              //   child: CustomButton(
              //     onPressed: () {

              //     },
              //     title: 'Thêm vào giỏ hàng',
              //   ),
              // ),
              // Expanded(
              //   child: CustomButton(
              //     onPressed: () {},
              //     title: 'Mua ngay',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
