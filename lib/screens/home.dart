import 'package:auto_size_text/auto_size_text.dart';
import 'package:furniture_app_project/provider/user_provider.dart';
import 'package:furniture_app_project/screens/setting.dart';
import '../models/cart_model.dart';
import '../provider/banner_provider.dart';
import '../provider/category_provider.dart';
import '../provider/product_provider.dart';
import '../screens/cart.dart';
import '../screens/favorite.dart';
import '../screens/product_detail.dart';
import '../widgets/banner.dart';
import '../widgets/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../models/favorite_model.dart';
import '../models/product_model.dart';
import '../services/DatabaseHandler.dart';
import '../widgets/category_list.dart';
import '../widgets/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

BannerProvider bannerProvider = BannerProvider();
CategoryProvider categoryProvider = CategoryProvider();
ProductProvider productProvider = ProductProvider();
UserProvider userProvider = UserProvider();

class _HomePageState extends State<HomePage> {
  late DatabaseHandler handler;

  late List<Favorite> listFavorite;
  late List<Cart> listCart;
  late Favorite favorite;

  int cartBadgeAmount = 0;
  int favoriteBadgeAmount = 0;
  late bool showCartBadge;
  late bool showFavoriteBadge;

  late double height, width;

  void getCallAllFunction() {
    categoryProvider.getCategory();
    productProvider.getProduct();
    productProvider.getNewArchiveProduct();
    productProvider.getReview();
    productProvider.getTopSeller();
    userProvider.fetchCurrentUser();
  }

  setFavorite(Favorite v2) {
    setState(() {
      favorite = v2;
    });
  }

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    getCallAllFunction();
  }

  bool isSettingOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  @override
  Widget build(BuildContext context) {
    bannerProvider = Provider.of<BannerProvider>(context);
    categoryProvider = Provider.of<CategoryProvider>(context);
    productProvider = Provider.of<ProductProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    getCallAllFunction();

    setState(() {
      int cartAmount = handler.getListCart.length;
      int favoriteAmount = handler.getListFavorite.length;
      cartBadgeAmount = cartAmount;
      favoriteBadgeAmount = favoriteAmount;
      listFavorite = handler.getListFavorite;
      listCart = handler.getListCart;
    });

    showCartBadge = cartBadgeAmount > 0;
    showFavoriteBadge = favoriteBadgeAmount > 0;

    return Scaffold(
      body: Stack(
        children: [
          const SettingPage(),
          Positioned(
            top: 50,
            right: 50,
            child: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            }, icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Icon(Icons.close,  color: Colors.black,),
            ),
          ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateZ(isSettingOpen ? -50 : 0),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isSettingOpen
                  ? const BorderRadius.all(Radius.circular(50))
                  : const BorderRadius.all(Radius.circular(0))
            ),
            child: Scaffold(
              // Appbar
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    xOffset = 300;
                                    yOffset = 190;
                                    isSettingOpen = true;
                                    scaleFactor = 0.8;
                                  });
                                },
                                child: isSettingOpen ? IconButton(
                                  onPressed: () {
                                    xOffset = 0;
                                    yOffset = 0;
                                    scaleFactor = 1;
                                    isSettingOpen = false;
                                  }, icon: const Icon(Icons.arrow_back , color: Colors.black,),
                                ) : Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                  child: ClipRRect(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                    child: userProvider.currentUser.img.isNotEmpty
                                        ? FadeInImage(
                                      fit: BoxFit.fill,
                                      placeholder: const AssetImage(
                                          'assets/icons/user.png'),
                                      image: NetworkImage(
                                          userProvider.currentUser.img),
                                    )
                                        : const Image(
                                        image: AssetImage('assets/icons/user.png')),
                                  ),
                                )
                            )
                          ],
                        ),
                        searchField(context),
                        Row(
                          children: [
                            badges.Badge(
                              showBadge: showFavoriteBadge,
                              position: badges.BadgePosition.topEnd(top: 10, end: 5),
                              badgeContent: Text(
                                favoriteBadgeAmount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Color(0xff80221e),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const FavoritePage()));
                                  }),
                            ),
                            badges.Badge(
                              position: badges.BadgePosition.topEnd(top: 10, end: 5),
                              showBadge: showCartBadge,
                              badgeContent: Text(
                                cartBadgeAmount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Color(0xff80221e),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const CartPage()));
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              backgroundColor: const Color(0xfff2f9fe),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Banner Component
                          const BannerWidget(),

                          // Category Component
                          Container(
                              padding:
                              const EdgeInsets.only(left: 10, top: 20, right: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Category",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SecularOne Regular"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: const [
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Icon(
                                          Icons.double_arrow_rounded,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          getCategoryList(categoryProvider.getListCategory),

                          // Product New Archive Component
                          Container(
                              padding:
                              const EdgeInsets.only(left: 10, top: 20, right: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "New Archive",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SecularOne Regular"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: const [
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Icon(
                                          Icons.double_arrow_rounded,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          getProductList(
                              productProvider.getListNewArchiveProduct, context),

                          // Product Top Seller Component
                          Container(
                              padding:
                              const EdgeInsets.only(left: 10, top: 20, right: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Top Seller",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SecularOne Regular"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: const [
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Icon(
                                          Icons.double_arrow_rounded,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          getTopSellerProductList(
                              productProvider.getListTopSeller, context),

                          // Product Limited offer Component
                          Container(
                              padding:
                              const EdgeInsets.only(left: 10, top: 20, right: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Limited Offer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SecularOne Regular"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: const [
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Icon(
                                          Icons.double_arrow_rounded,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          getDiscountProductList(
                              productProvider.getListDiscount, context),

                          // Product Best Review Component
                          Container(
                              padding:
                              const EdgeInsets.only(left: 10, top: 20, right: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Best Review",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SecularOne Regular"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: const [
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Icon(
                                          Icons.double_arrow_rounded,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          getReviewProductList(
                              productProvider.getListReview, context),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
              bottomNavigationBar: getFooter(0, context),
            ),
          ),
        ],
      )
    );
  }

  // Widget Product New Archive
  Widget getProductList(List<Product> produceList, BuildContext context) {
    //AssetImage placeImage = const AssetImage("assets/images/logo.png");
    if (produceList.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: produceList
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                                  productID: element,
                                )));
                      },
                      child: Stack(
                        children: [
                          // img
                          Container(
                            width: 200,
                            height: 170,
                            padding: const EdgeInsets.all(10),
                            child: Hero(
                              tag: element.id,
                              child: FadeInImage(
                                image: AssetImage(element.img),
                                fadeInDuration:
                                    const Duration(milliseconds: 2000),
                                fit: BoxFit.contain,
                                placeholder: const AssetImage(
                                    "assets/icons/spinner170.gif"),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 150),
                            padding: const EdgeInsets.all(5),
                            height: 260,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name product
                                    AutoSizeText(
                                      element.name,
                                      maxFontSize: 18,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    // title product
                                    Text(
                                      element.title,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),

                                    // Rate
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: element.review,
                                      itemSize: 15,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      unratedColor: Colors.grey,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        //print(rating);
                                      },
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          "(Sold ${element.sellest.toStringAsFixed(0)})",
                                          maxFontSize: 12,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Cart cart = Cart(
                                            imgProduct: element.img,
                                            nameProduct: element.name,
                                            color: element
                                                .productItemList[0].color.keys
                                                .elementAt(0),
                                            quantity: 1,
                                            idProduct:
                                                element.productItemList[0].id,
                                            price: element.currentPrice);

                                        handler.insertCart(cart);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xff81220e)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          color: Color(0xff81220e),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AutoSizeText(
                                      getDecorPrice(element.currentPrice),
                                      maxFontSize: 15,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Color(0xff80221e),
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: const Image(
                                  image: AssetImage("assets/icons/new.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              IconButton(
                                icon: getIconFavorite(
                                    element.id, listFavorite, element),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return Dialog(
                                          // The background color
                                          backgroundColor:
                                              const Color(0xff560f20),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                CircularProgressIndicator(
                                                  color: Color(0xffecd8e0),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });

                                  var favorite = Favorite(
                                    imgProduct: element.img,
                                    nameProduct: element.name,
                                    idProduct: element.id,
                                    price: element.currentPrice,
                                  );

                                  handler.insertFavorite(favorite).then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: [1, 2]
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset("assets/icons/spinner170.gif"),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }

  Widget getTopSellerProductList(
      List<Product> produceList, BuildContext context) {
    if (produceList.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: produceList
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(productID: element)));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 170,
                            padding: const EdgeInsets.all(10),
                            child: FadeInImage(
                              image: AssetImage(element.img),
                              fit: BoxFit.contain,
                              fadeInDuration:
                                  const Duration(milliseconds: 2000),
                              placeholder: const AssetImage(
                                  "assets/icons/spinner170.gif"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 150),
                            padding: const EdgeInsets.all(5),
                            height: 260,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name product
                                    AutoSizeText(
                                      element.name,
                                      maxFontSize: 18,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    // title product
                                    Text(
                                      element.title,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),

                                    // Rate
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: element.review,
                                      itemSize: 15,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      unratedColor: Colors.grey,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        //print(rating);
                                      },
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          "(Sold ${element.sellest.toStringAsFixed(0)})",
                                          maxFontSize: 12,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Cart cart = Cart(
                                            imgProduct: element.img,
                                            nameProduct: element.name,
                                            color: element
                                                .productItemList[0].color.keys
                                                .elementAt(0),
                                            quantity: 1,
                                            idProduct:
                                                element.productItemList[0].id,
                                            price: element.currentPrice);

                                        handler.insertCart(cart);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xff81220e)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          color: Color(0xff81220e),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AutoSizeText(
                                      getDecorPrice(element.currentPrice),
                                      maxFontSize: 15,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Color(0xff80221e),
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: const Image(
                                  image:
                                      AssetImage("assets/icons/hot-sale.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              IconButton(
                                icon: getIconFavorite(
                                    element.id, listFavorite, element),
                                onPressed: () {
                                  var favorite = Favorite(
                                    imgProduct: element.img,
                                    nameProduct: element.name,
                                    idProduct: element.id,
                                    price: element.currentPrice,
                                  );
                                  handler.insertFavorite(favorite).then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: [1, 2]
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset("assets/icons/spinner170.gif"),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }

  Widget getDiscountProductList(
      List<Product> produceList, BuildContext context) {
    if (produceList.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: produceList
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(productID: element)));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 170,
                            padding: const EdgeInsets.all(10),
                            child: FadeInImage(
                              image: AssetImage(element.img),
                              fit: BoxFit.contain,
                              fadeInDuration:
                                  const Duration(milliseconds: 2000),
                              placeholder: const AssetImage(
                                  "assets/icons/spinner170.gif"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 150),
                            padding: const EdgeInsets.all(5),
                            height: 260,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name product
                                    AutoSizeText(
                                      element.name,
                                      maxFontSize: 18,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),

                                    // title product
                                    AutoSizeText(
                                      element.title,
                                      maxFontSize: 12,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),

                                    // Rate
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      initialRating: element.review,
                                      itemSize: 15,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      unratedColor: Colors.grey,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        //print(rating);
                                      },
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          "(Sold ${element.sellest.toStringAsFixed(0)})",
                                          maxFontSize: 12,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Cart cart = Cart(
                                            imgProduct: element.img,
                                            nameProduct: element.name,
                                            color: element
                                                .productItemList[0].color.keys
                                                .elementAt(0),
                                            quantity: 1,
                                            idProduct:
                                                element.productItemList[0].id,
                                            price: element.currentPrice);

                                        handler.insertCart(cart);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xff81220e)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          color: Color(0xff81220e),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AutoSizeText(
                                      getDecorPrice(element.rootPrice),
                                      maxFontSize: 12,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AutoSizeText(
                                      getDecorPrice(element.currentPrice),
                                      maxFontSize: 15,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Color(0xff80221e),
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Transform.rotate(
                                  angle: 380,
                                  child: SizedBox(
                                    height: 30,
                                    width: 60,
                                    child: CustomPaint(
                                      painter: PriceTagPaint(),
                                      child: Center(
                                        child: Transform.rotate(
                                          angle: 380,
                                          child: Text(
                                            returnDiscountPrice(
                                                element.rootPrice,
                                                element.currentPrice),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: getIconFavorite(
                                    element.id, listFavorite, element),
                                onPressed: () {
                                  var favorite = Favorite(
                                    imgProduct: element.img,
                                    nameProduct: element.name,
                                    idProduct: element.id,
                                    price: element.currentPrice,
                                  );
                                  handler.insertFavorite(favorite).then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: [1, 2]
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset("assets/icons/spinner170.gif"),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }

  Widget getReviewProductList(List<Product> produceList, BuildContext context) {
    if (produceList.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: produceList
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(productID: element)));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 170,
                            padding: const EdgeInsets.all(10),
                            child: FadeInImage(
                              image: AssetImage(element.img),
                              fit: BoxFit.contain,
                              placeholder: const AssetImage(
                                  "assets/icons/spinner170.gif"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 150),
                            padding: const EdgeInsets.all(5),
                            height: 260,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name product
                                    AutoSizeText(
                                      element.name,
                                      maxFontSize: 18,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),

                                    // title product
                                    AutoSizeText(
                                      element.title,
                                      maxFontSize: 12,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),

                                    // Rate
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      initialRating: element.review,
                                      itemSize: 15,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      unratedColor: Colors.grey,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        //print(rating);
                                      },
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          "(Sold ${element.sellest.toStringAsFixed(0)})",
                                          maxFontSize: 12,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Cart cart = Cart(
                                            imgProduct: element.img,
                                            nameProduct: element.name,
                                            color: element
                                                .productItemList[0].color.keys
                                                .elementAt(0),
                                            quantity: 1,
                                            idProduct:
                                                element.productItemList[0].id,
                                            price: element.currentPrice);

                                        handler.insertCart(cart);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xff81220e)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          color: Color(0xff81220e),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AutoSizeText(
                                      getDecorPrice(element.currentPrice),
                                      maxFontSize: 15,
                                      minFontSize: 12,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Color(0xff80221e),
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: const Image(
                                  image: AssetImage("assets/icons/best.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              IconButton(
                                icon: getIconFavorite(
                                    element.id, listFavorite, element),
                                onPressed: () {
                                  setState(() {
                                    var favorite = Favorite(
                                      imgProduct: element.img,
                                      nameProduct: element.name,
                                      idProduct: element.id,
                                      price: element.currentPrice,
                                    );

                                    handler.insertFavorite(favorite).then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: -1,
            direction: Axis.vertical,
            children: [1, 2]
                .map(
                  (element) => Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    width: 200,
                    height: 260,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset("assets/icons/spinner170.gif"),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }

  Widget getIconFavorite(
      String idProduct, List<Favorite> favorite, Product product) {
    bool check = false;
    for (var element in favorite) {
      if (element.idProduct == idProduct) {
        check = true;
      }
    }

    if (check == false) {
      return const Icon(
        Icons.favorite_border_outlined,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.favorite,
        color: Colors.red,
      );
    }
  }

  String getDecorPrice(double price) {
    String priceDecor = "";
    String test = price.toString();
    String temp = "";

    if (test.contains('.') == true) {
      temp = test.substring(test.indexOf('.'), test.length);
      test = test.substring(0, test.indexOf('.'));

      int number = 0;
      for (int i = test.length - 1; i >= 0; i--) {
        number++;
        if (number == 3) {
          priceDecor = '$priceDecor${test[i]},';
          number = 0;
        } else {
          priceDecor = '$priceDecor${test[i]}';
        }
      }
    } else {
      int number = 0;
      for (int i = test.length - 1; i >= 0; i--) {
        number++;
        if (number == 3) {
          priceDecor = '$priceDecor${test[i]},';
          number = 0;
        } else {
          priceDecor = '$priceDecor${test[i]}';
        }
      }
    }

    priceDecor = priceDecor.split('').reversed.join('');
    if (priceDecor.indexOf(',') == 0) {
      priceDecor = priceDecor.substring(1, priceDecor.length);
    }

    priceDecor = "\$ $priceDecor$temp";
    return priceDecor;
  }

  Widget drawShape(BuildContext context) {
    return ClipPath(
      clipper: Clipper(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter,
          height: 200,
          blur: 0,
          border: 0,
          borderGradient: LinearGradient(colors: [
            Colors.black.withOpacity(0.0),
            Colors.black12.withOpacity(0.0)
          ]),
          borderRadius: 0,
          linearGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xffa23c4c).withOpacity(0.4),
              const Color(0xffa23c4c).withOpacity(0.4),
              const Color(0xffa23c4c).withOpacity(0.4),
              const Color(0xffa23c4c).withOpacity(0.4),
              const Color(0xffa23c4c).withOpacity(0.4),
            ],
            stops: const [0.2, 0.4, 0.6, 0.8, 1],
          ),
        ),
      ),
    );
  }

  Widget getReviewStar(double review) {
    return Row(
      children: const [
        Icon(
          Icons.star,
          size: 15,
          color: Colors.grey,
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.grey,
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.grey,
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.grey,
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.grey,
        ),
      ],
    );
  }
}

String returnDiscountPrice(double priceRoot, double priceCurrent) {
  double discount = ((priceRoot - priceCurrent) / priceRoot) * 100;
  return "${discount.toStringAsFixed(0)} % ";
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 70);

    var firstStart = Offset(size.width / 2, size.height);
    var firstEnd = Offset(size.width, size.height - 70);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class PriceTagPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Path path = Path();

    path
      ..moveTo(0, size.height * .5)
      ..lineTo(size.width * .13, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .13, size.height)
      ..lineTo(0, size.height * .5)
      ..close();
    canvas.drawPath(path, paint);

    //* Circle
    canvas.drawCircle(
      Offset(size.width * .13, size.height * .5),
      size.height * .15,
      paint..color = Colors.redAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
