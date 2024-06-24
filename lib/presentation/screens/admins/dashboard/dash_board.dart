import 'package:apartment_managage/presentation/screens/admins/dashboard/home_page/home_page.dart';
import 'package:apartment_managage/presentation/screens/admins/dashboard/settings/setting_screen.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:flutter/material.dart';

class DashBoarAdmindScreen extends StatefulWidget {
  const DashBoarAdmindScreen({super.key});

  @override
  State<DashBoarAdmindScreen> createState() => _DashBoarAdmindScreenState();
}

class _DashBoarAdmindScreenState extends State<DashBoarAdmindScreen> {
  final List<Widget> _pages = [
    const AdminHomePage(),
    const Center(child: Text('Thông báo')),
    const SettingScreen(),
    // const ProfileScreen(),
    // const ServiceBookingListScreen(),
    // const SettingScreen(),
    // const Text('data'),
    // const ManageProductsScreen(),
    // const Text('data'),
  ];
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    if (navService.canPop(context)) {
      navService.pop(context);
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  onTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        padEnds: true,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.newspaper_rounded),
          //   label: 'Tin tức',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        // backgroundColor: kOfWhite,
        unselectedItemColor: kGrayLight,
        onTap: onTap,
      ),
    );
  }
}
