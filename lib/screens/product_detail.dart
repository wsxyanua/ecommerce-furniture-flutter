import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:furniture_app_project/widgets/bottom_navy_bar.dart';
import '../models/favorite_model.dart';
import '../models/user_model.dart';
import '../provider/user_provider.dart';
import '../screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/favorite_provider.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productID});
  final Product productID;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
UserProvider userProvider = UserProvider();

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  late Cart cart;
  late Favorite favorite;

  late String imageMainCurrent;
  late ProductItem productItem;
  late int number = 0;
  bool showSubMenu = false;

  @override
  void initState() {
    number = 0;
    super.initState();
  }

  bool setActiveColor(String itemID) {
    if (itemID == productItem.id) {
      return true;
    } else {
      return false;
    }
  }

  setProductItemCurrent(ProductItem v2) {
    setState(() {
      productItem = v2;
      imageMainCurrent = v2.img[0];
    });
  }

  setCart(Cart v2) {
    setState(() {
      cart = v2;
    });
  }

  setFavorite(Favorite v2) {
    setState(() {
      favorite = v2;
    });
  }

  int cartBadgeAmount = 0;
  late bool showCartBadge;

  List<UserSQ> listUser = [];

  bool showDes = false;
  bool showMes = false;
  bool showMet = false;
  bool showRev = false;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    if (number == 0) {
      setState(() {
        productItem = widget.productID.productItemList[0];
        imageMainCurrent = productItem.img[0];
        number = 1;
      });
    }
    setState(() {
      int cartAmount = handler.getListCart.length;
      cartBadgeAmount = cartAmount;
    });

    bool showCartBadge = cartBadgeAmount > 0;
    userProvider.getListUser(widget.productID.reviewList);
    listUser = userProvider.getListUserSQ;

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          key: _key,
          backgroundColor: const Color(0xfff2f9fe),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const AutoSizeText(
              'Product detail',
              maxFontSize: 17,
              minFontSize: 12,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [getImage(), getInfor()],
                  )),
            ),
          ),
          bottomNavigationBar: getFooter(1, context),
        ));
  }

  Widget getImage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Image main
            Container(
              padding: const EdgeInsets.only(bottom: 180, top: 20),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.8,
                  colors: [
                    HexColor.fromHex(getHexColorFromMap(productItem.color))
                        .withOpacity(0.2),
                    HexColor.fromHex(getHexColorFromMap(productItem.color))
                        .withOpacity(0.4),
                    HexColor.fromHex(getHexColorFromMap(productItem.color))
                        .withOpacity(0.6),
                    HexColor.fromHex(getHexColorFromMap(productItem.color))
                        .withOpacity(0.8),
                    HexColor.fromHex(getHexColorFromMap(productItem.color))
                        .withOpacity(0.9),
                    HexColor.fromHex(getHexColorFromMap(productItem.color))
                        .withOpacity(1),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 4,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    height: 400,
                    child: ListView.builder(
                        itemCount: productItem.img.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              behavior: HitTestBehavior.deferToChild,
                              onTap: () {
                                setState(() {
                                  imageMainCurrent = productItem.img[index];
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Image(
                                  image: AssetImage(productItem.img[index]),
                                  fit: BoxFit.fill,
                                ),
                              ));
                        }),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 4,
                    height: 400,
                    child: Hero(
                      tag: widget.productID.id,
                      child: Image(
                        image: AssetImage(imageMainCurrent),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main button
            Container(
              margin: const EdgeInsets.only(top: 410),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showSubMenu = !showSubMenu;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animate) => RotationTransition(
                      turns: child.key == const ValueKey('close')
                          ? Tween<double>(begin: 1, end: 0.75).animate(animate)
                          : Tween<double>(begin: 0.75, end: 1).animate(animate),
                      child: FadeTransition(
                        opacity: animate,
                        child: child,
                      ),
                    ),
                    child: showSubMenu
                        ? const Icon(
                            Icons.close,
                            size: 30,
                            key: ValueKey('close'),
                          )
                        : const Icon(
                            Icons.more_horiz,
                            size: 30,
                            key: ValueKey('open'),
                          ),
                  ),
                ),
              ),
            ),
            // List color
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 510),
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 100),
                painter: RPSCustomPainter(),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                      top: 25, left: 20, right: 20, bottom: 10),
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: -1,
                      direction: Axis.vertical,
                      children: widget.productID.productItemList
                          .map(
                            (element) => Stack(
                              children: [
                                Visibility(
                                  visible: setActiveColor(element.id),
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: HexColor.fromHex(
                                          getColorFromMap(element.color)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.deferToChild,
                                  onTap: () {
                                    setState(() {
                                      setProductItemCurrent(element);
                                      setCart(Cart(
                                          quantity: 1,
                                          idProduct: element.id,
                                          price: widget.productID.currentPrice,
                                          imgProduct: productItem.img[0],
                                          nameProduct: widget.productID.name,
                                          color: getNameColorFromMap(
                                              element.color)));
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(13.5),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: HexColor.fromHex(
                                          getColorFromMap(element.color)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            // Sub button
            getSubMenu(),
          ],
        ),
      ],
    );
  }

  Widget getSubMenu() {
    if (showSubMenu) {
      return Container(
          margin: const EdgeInsets.only(top: 320),
          width: MediaQuery.of(context).size.width / 2,
          height: 150,
          child: Stack(children: [

            // Favorite
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 3,
              child: GestureDetector(
                onTap: () {

                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          // The background color
                          backgroundColor: const Color(0xff560f20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(height: 20,),
                                CircularProgressIndicator(color: Color(0xffecd8e0),),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        );
                      }
                  );

                  var fav = Favorite(
                      imgProduct: productItem.img[0],
                      nameProduct: widget.productID.name,
                      idProduct: widget.productID.id,
                      price: widget.productID.currentPrice);

                  final favProvider = Provider.of<FavoriteProvider>(context, listen: false);
                  favProvider.addFavorite(fav);

                  Navigator.pop(context);
                },
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.white,
                    ),
                    child: Consumer<FavoriteProvider>(
                      builder: (context, favProvider, child) {
                        final isFav = favProvider.isFavorite(widget.productID.id);
                        return Icon(
                          isFav ? Icons.favorite : Icons.favorite_border_outlined,
                          color: const Color(0xff81221e),
                        );
                      },
                    ),
                ),
              ),
            ),
            // Add cart
            Positioned(
              bottom: 90,
              left: MediaQuery.of(context).size.width / 4 - 25,
              child: GestureDetector(
                onTap: () {
                  var cartNew = Cart(
                      imgProduct: productItem.img[0],
                      nameProduct: widget.productID.name,
                      color: productItem.color.keys.elementAt(0),
                      quantity: 1, idProduct: productItem.id, price:widget.productID.currentPrice
                  );

                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.addToCart(cartNew);
                },
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xff81221e),
                      size: 40,
                    )),
              ),
            ),
            // Full screen
            Positioned(
              bottom: 50,
              right: MediaQuery.of(context).size.width / 3,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          insetPadding: const EdgeInsets.all(0),
                          // The background color
                          backgroundColor: Colors.white.withOpacity(0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    label: const Text(""),
                                  ),
                                ],
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  height:
                                      MediaQuery.of(context).size.height - 100,
                                  autoPlay: false,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: true,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                ),
                                items: productItem.img.map((e) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        margin: const EdgeInsets.all(6.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image(
                                            image: AssetImage(e),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Color(0xff81221e),
                      size: 40,
                    )),
              ),
            )
          ]));
    } else {
      return Container();
    }
  }

  Widget getInfor() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Product & Rice
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.productID.name,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                getDecorPrice(widget.productID.currentPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff81221e),
                ),
              ),
            ),
          ],
        ),
        // Color Product
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                getNameColorFromMap(productItem.color),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        // Title  Product
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.productID.title,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        // Rate star
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: RatingBar.builder(
            ignoreGestures: true,
            initialRating: widget.productID.review,
            itemSize: 20,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            unratedColor: Colors.grey,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              //print(rating);
            },
          ),
        ),
        // Product sold
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: Text(
            "Sells ${widget.productID.sellest.toStringAsFixed(0)}",
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Description
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(179, 213, 242, 0.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Good to know',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDes = !showDes;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(179, 213, 242, 1),
                        spreadRadius: 4,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xffffffff),
                        spreadRadius: 4,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animate) => RotationTransition(
                      turns: child.key == const ValueKey('close1')
                          ? Tween<double>(begin: 1, end: 0.75).animate(animate)
                          : Tween<double>(begin: 0.75, end: 1).animate(animate),
                      child: FadeTransition(
                        opacity: animate,
                        child: child,
                      ),
                    ),
                    child: showDes
                        ? const Icon(
                            Icons.close,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('close1'),
                          )
                        : const Icon(
                            Icons.expand_more,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('open1'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content Description
        Visibility(
          visible: showDes,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.productID.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Measurement
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(179, 213, 242, 0.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Measurement',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showMes = !showMes;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(179, 213, 242, 1),
                        spreadRadius: 4,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xffffffff),
                        spreadRadius: 4,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animate) => RotationTransition(
                      turns: child.key == const ValueKey('close2')
                          ? Tween<double>(begin: 1, end: 0.75).animate(animate)
                          : Tween<double>(begin: 0.75, end: 1).animate(animate),
                      child: FadeTransition(
                        opacity: animate,
                        child: child,
                      ),
                    ),
                    child: showMes
                        ? const Icon(
                            Icons.close,
                            color: Color(0xff81221e),
                            size: 30,
                            key: ValueKey('close2'),
                          )
                        : const Icon(
                            Icons.expand_more,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('open2'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content Measurement
        Visibility(
          visible: showMes,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: getDataTable(widget.productID.size, "Type", "Value"),
              ),
            ],
          ),
        ),
        // Material
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(179, 213, 242, 0.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Material',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showMet = !showMet;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(179, 213, 242, 1),
                        spreadRadius: 4,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xffffffff),
                        spreadRadius: 4,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animate) => RotationTransition(
                      turns: child.key == const ValueKey('close3')
                          ? Tween<double>(begin: 1, end: 0.75).animate(animate)
                          : Tween<double>(begin: 0.75, end: 1).animate(animate),
                      child: FadeTransition(
                        opacity: animate,
                        child: child,
                      ),
                    ),
                    child: showMet
                        ? const Icon(
                            Icons.close,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('close3'),
                          )
                        : const Icon(
                            Icons.expand_more,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('open3'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content Material
        Visibility(
          visible: showMet,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: getDataTable(widget.productID.material, "Type", "Value"),
              ),
            ],
          ),
        ),
        // Review
        Container(
          height: 50,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(179, 213, 242, 0.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Review',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showRev = !showRev;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(179, 213, 242, 1),
                        spreadRadius: 4,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xffffffff),
                        spreadRadius: 4,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animate) => RotationTransition(
                      turns: child.key == const ValueKey('close4')
                          ? Tween<double>(begin: 1, end: 0.75).animate(animate)
                          : Tween<double>(begin: 0.75, end: 1).animate(animate),
                      child: FadeTransition(
                        opacity: animate,
                        child: child,
                      ),
                    ),
                    child: showRev
                        ? const Icon(
                            Icons.close,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('close4'),
                          )
                        : const Icon(
                            Icons.expand_more,
                            size: 30,
                            color: Color(0xff81221e),
                            key: ValueKey('open4'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: showRev,
          child: getReview(),
        ),
        const SizedBox(
          height: 200,
        ),
      ],
    );
  }

  Widget getDataTable(Map<String, String> size, String text1, text2) {
    List<DefineSize> listSize = [];
    size.forEach((key, value) =>
        listSize.add(DefineSize(sizeType: key, sizeValue: value)));

    return DataTable(
      columns: [
        DataColumn(label: Text(text1)),
        DataColumn(label: Text(text2)),
      ],
      rows: listSize
          .map((e) => DataRow(cells: [
                DataCell(Text(e.sizeType)),
                DataCell(Text(e.sizeValue)),
              ]))
          .toList(),
    );
  }

  Widget getReview() {
    if (listUser.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
         child:  ListView.builder(
           shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.productID.reviewList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 2,
                      )
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar - name - date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  child: Image.network(
                                    listUser[index].img,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              // Name
                              Text(listUser[index].fullName),
                            ],
                          ),
                          Text(
                              getDate(widget.productID.reviewList[index].date) ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      // Star
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: widget.productID.reviewList[index].star,
                        itemSize: 18,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        unratedColor: Colors.grey,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          //print(rating);
                        },
                      ),
                      const SizedBox(height: 5,),
                      // Content
                      Text(widget.productID.reviewList[index].message),
                      const SizedBox(height: 5,),
                      // Image
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                            widget.productID.reviewList[index].img.length,
                            itemBuilder: (BuildContext context, int e) {
                              return SizedBox(
                                width: 100,
                                height: 100,
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      "assets/icons/spinner100.gif"),
                                  image: NetworkImage(widget
                                      .productID.reviewList[index].img[e]),
                                  //fit: BoxFit.fill,
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              }),
      );
    } else {
      return const Center(
        child: Text('No review'),
      );
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class DefineSize {
  late String sizeType;
  late String sizeValue;

  DefineSize({required this.sizeType, required this.sizeValue});
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

ProductItem changeValue(ProductItem v1, ProductItem v2) {
  return v2;
}

String getDate(DateTime date) {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  return dateFormat.format(date);
}

String getColorFromMap(Map<String, String> color) {
  var hexColor = "#ffffff";
  color.forEach((key, value) {
    hexColor = value;
  });

  return hexColor;
}

String getNameColorFromMap(Map<String, String> color) {
  var hexColor = "Grey";
  color.forEach((key, value) {
    hexColor = key;
  });

  return hexColor;
}

String getHexColorFromMap(Map<String, String> color) {
  var hexColor = "#ffffff";
  color.forEach((key, value) {
    hexColor = value;
  });

  return hexColor;
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
      color: Color(0xff81221e),
    );
  } else {
    return const Icon(
      Icons.favorite,
      color: Color(0xff81221e),
    );
  }
}

var bottomNavigationItems = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(
      Icons.threed_rotation_outlined,
      color: Colors.black,
    ),
    label: "3D",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(Icons.screenshot_outlined, color: Colors.black),
    label: "AR",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(Icons.add, color: Colors.black),
    label: "Cart",
  ),
  const BottomNavigationBarItem(
    backgroundColor: Color(0x00ffffff),
    icon: Icon(Icons.favorite_border_outlined, color: Colors.black),
    label: "Favorite",
  ),
];

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xfff2f9fe)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(size.width, size.height);
    path0.lineTo(size.width, size.height * 0.3);
    path0.quadraticBezierTo(size.width * 0.97, size.height * 0.1,
        size.width * 0.9, size.height * 0.08);
    path0.quadraticBezierTo(size.width * 0.67, size.height * -0.02,
        size.width * 0.6, size.height * 0.03);
    path0.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.03,
      size.width * 0.59,
      size.height * 0.05,
    );
    path0.quadraticBezierTo(size.width * 0.5, size.height * 0.6,
        size.width * 0.41, size.height * 0.06);
    path0.quadraticBezierTo(size.width * 0.40, size.height * 0.04,
        size.width * 0.39, size.height * 0.03);
    path0.quadraticBezierTo(size.width * 0.33, size.height * -0.02,
        size.width * 0.1, size.height * 0.08);
    path0.quadraticBezierTo(
        size.width * 0.03, size.height * 0.1, 0, size.height * 0.3);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


