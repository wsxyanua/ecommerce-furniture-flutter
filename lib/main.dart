import 'package:furniture_app_project/provider/filter_provider.dart';
import 'package:furniture_app_project/screens/welcome.dart';
import 'provider/banner_provider.dart';
import 'provider/cart_provider.dart';
import 'provider/category_provider.dart';
import 'provider/country_city_provider.dart';
import 'provider/favorite_provider.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';
import 'provider/user_provider.dart';
import 'services/DatabaseHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo DB cục bộ (sqflite) nếu cần
  DatabaseHandler handler = DatabaseHandler();
  handler.initializeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<BannerProvider>(
          create: (context) => BannerProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<CountryCityProvider>(
          create: (context) => CountryCityProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<FilterProvider>(
          create: (context) => FilterProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Furniture App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xfff2f9fe),
          textTheme:
              GoogleFonts.dmSansTextTheme().apply(displayColor: Colors.black),
          primaryColor: const Color(0xff410000),
          iconTheme: const IconThemeData(color: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Welcom(),
      ),
    );
  }
}
