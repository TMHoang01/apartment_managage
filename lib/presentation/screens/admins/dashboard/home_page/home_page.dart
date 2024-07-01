import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/widgets/custom_image_view.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemHomePage {
  final String title;
  final IconData icon;
  final Color? color;
  final Function onTap;
  ItemHomePage({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
// with AutomaticKeepAliveClientMixin<AdminHomePage>
{
  // @override
  // bool get wantKeepAlive => true;

  final List<ItemHomePage> listTypeUser = [
    ItemHomePage(
      title: 'Phê duyệt',
      icon: FontAwesomeIcons.userCheck,
      color: Colors.yellow,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.usersApprove);
      },
    ),
    ItemHomePage(
      title: 'Nhân viên',
      icon: FontAwesomeIcons.userTie,
      color: Colors.blue,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.employList);
      },
    ),
    ItemHomePage(
      title: 'Cư dân',
      icon: FontAwesomeIcons.buildingUser,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.users,
            args: Role.resident.toJson());
      },
    ),
    ItemHomePage(
      title: 'Nhà cung cấp',
      icon: FontAwesomeIcons.userGear,
      color: Colors.red,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.users,
            args: Role.provider.toJson());
      },
    ),
  ];

  final List<ItemHomePage> listinternalServices = [
    ItemHomePage(
      title: 'Phản ánh cư dân',
      icon: FontAwesomeIcons.ticket,
      color: Colors.red,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.feedback);
      },
    ),
    ItemHomePage(
      title: 'Khách thăm',
      icon: FontAwesomeIcons.addressCard,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.guestAccess);
      },
    ),
    // ItemHomePage(
    //   title: 'Phòng hội nghị',
    //   icon: FontAwesomeIcons.doorOpen,
    //   color: Colors.blue,
    //   onTap: (BuildContext context) {
    //     navService.pushNamed(context, AppRouter.products);
    //   },
    // ),
    ItemHomePage(
      title: 'Bài đăng',
      icon: FontAwesomeIcons.podcast,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.products);
      },
    ),
    ItemHomePage(
      title: 'Xe vào ra',
      icon: FontAwesomeIcons.carOn,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.parkingInout);
      },
    ),
    ItemHomePage(
      title: 'Đăng ký vé xe',
      icon: FontAwesomeIcons.car,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.parkingVehicleRegister);
      },
    ),
    ItemHomePage(
      title: 'Danh sách vé xe tháng',
      icon: FontAwesomeIcons.moneyBillTransfer,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.parkingVehicleTicket);
      },
    ),
    ItemHomePage(
      title: 'Bãi đỗ xe',
      icon: FontAwesomeIcons.squareParking,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.parking);
      },
    ),
  ];

  final List<ItemHomePage> listPost = [
    ItemHomePage(
      title: 'Tin tức,sự kiện',
      icon: FontAwesomeIcons.podcast,
      color: Colors.green,
      onTap: (BuildContext context) {
        // context.read<PostsBloc>().add(const PostsStarted(type: 'news'));
        navService.pushNamed(context, AppRouter.post);
      },
    ),
    // ItemHomePage(
    //   title: 'Sự kiện',
    //   icon: FontAwesomeIcons.hornbill,
    //   color: Colors.yellow,
    //   onTap: (BuildContext context) {
    //     // context.read<PostsBloc>().add(const PostsStarted(type: 'event'));
    //     navService.pushNamed(context, AppRouter.post);
    //   },
    // ),
    ItemHomePage(
      title: 'Hàng hóa',
      icon: FontAwesomeIcons.productHunt,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.products);
      },
    ),
    ItemHomePage(
      title: 'Dịch vụ',
      icon: FontAwesomeIcons.servicestack,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, AppRouter.services);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Trang chủ ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.24,
              width: size.width,
              child: CustomImageView(
                imagePath: ImageConstant.banners[1],
                boxFit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 6),
            // List type user
            if (userCurrent?.isAdmin ?? false)
              Column(
                children: [
                  Text('  Quản lý người dùng',
                      style:
                          theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
                  const SizedBox(height: 6),
                  _buildGridView(listTypeUser),
                ],
              ),
            Text('  Dịch vụ tiện ích',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 6),
            _buildGridView(listinternalServices.sublist(0, 2)),
            _buildGridView(listinternalServices.sublist(3)),
            Text('  Bài đăng, sản phẩm',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 6),
            _buildGridView(listPost),
          ],
        ),
      ),
    );
  }

  GridView _buildGridView(List<ItemHomePage> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 0,
        childAspectRatio: 1.34,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return ItemHomeBox(item: item);
      },
    );
  }
}

class ItemHomeBox extends StatelessWidget {
  final ItemHomePage item;
  const ItemHomeBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        item.onTap(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                shape: BoxShape.rectangle,
              ),
              child: Icon(
                item.icon,
                size: 28,
                color: item.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: BorderSide.strokeAlignCenter,
              ),
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
