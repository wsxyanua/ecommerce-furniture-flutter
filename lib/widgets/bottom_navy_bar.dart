import 'package:furniture_app_project/screens/order.dart';
import 'package:furniture_app_project/screens/search.dart';
import 'package:furniture_app_project/screens/test.dart';
import '../screens/home.dart';
import '../screens/notification.dart';
import 'package:flutter/material.dart';

var bottomNavigationBarItems = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    activeIcon: Icon(
      Icons.home,
      color: Color(0xff80221e),
    ),
    icon: Icon(
      Icons.home_outlined,
      color: Colors.black,
    ),
    label: "Home",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(Icons.grid_view_outlined, color: Colors.black),
    activeIcon: Icon(
      Icons.grid_view_rounded,
      color: Color(0xff80221e),
    ),
    label: "Collection",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
    activeIcon: Icon(
      Icons.shopping_bag,
      color: Color(0xff80221e),
    ),
    label: "Order",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    activeIcon: Icon(
      Icons.notifications,
      color: Color(0xff80221e),
    ),
    icon: Icon(Icons.notifications_outlined, color: Colors.black),
    label: "Notification",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(Icons.account_circle_outlined, color: Colors.black),
    activeIcon: Icon(
      Icons.account_circle,
      color: Color(0xff80221e),
    ),
    label: "Account",
  ),
];

Widget getFooter(int selectedItem, BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: const Color(0xff80221e),
    selectedFontSize: 20,
    elevation: 0.0,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    currentIndex: selectedItem,
    selectedIconTheme: const IconThemeData(
      color: Color(0xff80221e),
    ),
    backgroundColor: const Color(0x00ffffff),
    items: bottomNavigationBarItems,
    onTap: (selectedItem) => itemClick(selectedItem, context),
  );
}

void itemClick(int selectedItem, BuildContext context) {
  if (selectedItem == 0) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  } else if (selectedItem == 1) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Search()));
  } else if (selectedItem == 2) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OrderPage()));
  } else if (selectedItem == 3) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NotificationPage()));
  } else if (selectedItem == 4) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
}
