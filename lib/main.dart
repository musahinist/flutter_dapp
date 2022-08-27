import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dapp_template/pages/nav_menu/nav_menu.dart';
import 'bloc/bloc_observer.dart';
import 'bloc/cubit/wallet_cubit.dart';
import 'pages/home/home.dart';
import 'pages/profile/connect_wallet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WalletCubit()..initWalletConnect(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Intangible',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: NavMenu.routeName,
        routes: Pages.routes,
      ),
    );
  }
}

class Pages {
  static final Map<String, Widget Function(BuildContext)> routes = {
    NavMenu.routeName: (context) => const NavMenu(),
    HomePage.routeName: (context) => const HomePage(),
    ConnectWalletPage.routeName: (context) => const ConnectWalletPage(),
  };
}
