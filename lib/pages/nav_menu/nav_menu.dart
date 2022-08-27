import 'package:flutter/material.dart';

import '../home/home.dart';
import '../profile/connect_wallet.dart';

class NavMenu extends StatefulWidget {
  const NavMenu({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  final List<Widget> pageList = const [
    HomePage(),

    //TestConnectWallet(),
    ConnectWalletPage(),
    //  ProfilePage(),
  ];

  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList.elementAt(_tab),
      bottomNavigationBar: NavigationBar(
        height: 56,
        selectedIndex: _tab,
        onDestinationSelected: (index) {
          setState(() {
            _tab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
