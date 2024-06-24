import 'package:flutter/material.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';

class OrdersListWidget extends StatefulWidget {
  final Function? changeView;

  const OrdersListWidget({super.key, this.changeView});

  @override
  State<OrdersListWidget> createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tin tức'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              // color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        color: kOfWhite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // sreach bar
              // CustomTextFormField(
              //   margin: const EdgeInsets.all(10),
              //   hintText: 'Tìm kiếm',
              //   suffix: const Icon(Icons.search),
              // ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ChipCard(
                        label: 'Tin tức',
                        backgroundColor: kPrimaryColor,
                        onTap: () {
                          print('Tin tức');
                        },
                      ),
                      const ChipCard(
                        label: 'Tuyển dụng',
                      ),
                      const ChipCard(
                        label: 'Tuyển dụng',
                      ),
                      const ChipCard(
                        label: 'Tuyển dụng',
                      ),
                      const ChipCard(
                        label: 'Tuyển dụng',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
