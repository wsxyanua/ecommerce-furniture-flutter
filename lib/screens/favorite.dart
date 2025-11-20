import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app_project/models/product_model.dart';
import 'package:furniture_app_project/provider/product_provider.dart';
import 'package:furniture_app_project/screens/product_detail.dart';
import 'package:furniture_app_project/widgets/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../services/DatabaseHandler.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

ProductProvider productProvider = ProductProvider();

class _FavoritePageState extends State<FavoritePage> {
  late DatabaseHandler handler;
  late List<Cart> listCart;
  late List<Favorite> listFavorite;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);

    listFavorite = handler.getListFavorite;

    return Scaffold(
      backgroundColor: const Color(0xfff2f9fe),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const AutoSizeText(
          'Favorite',
          maxFontSize: 17,
          minFontSize: 12,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xff81221e),
            ),
            label: const Text(''),
          )
        ],
      ),
      body: listFavorite.isNotEmpty
          ? ListView.builder(
              itemCount: listFavorite.length,
              itemBuilder: (BuildContext context, int index) {

                var pro = getProduct(listFavorite[index].idProduct);

                return Container(
                  color: const Color(0xfff2f9fe),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                  productID: pro)));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffe3eaef),
                              spreadRadius: 0.06,
                              blurRadius: 12,
                              offset: Offset(6, 6)),
                          BoxShadow(
                            //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffffffff),
                              spreadRadius: 0.06,
                              blurRadius: 12,
                              offset: Offset(-6, -6)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Img Product
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image(
                                  image: AssetImage(pro.img),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                          // Name Product
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                pro.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                pro.title,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$ ${pro.currentPrice}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.all(5),
                                  onPressed: () {
                                    setState(() {
                                      handler.deleteFavorite(
                                          listFavorite[index].idFavorite!);
                                    });
                                  },
                                  icon: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                    child: const Icon(Icons.delete_forever , color: Colors.grey,),
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 2 - 200,),
                  const Image(image: AssetImage("assets/icons/empty.png")),
                  const Text(
                    'Not Favorite',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
      //
      bottomNavigationBar: getFooter(1, context),
    );
  }

  Product getProduct(String idProduct) {
    var newList = productProvider.getListProduct
        .where((element) => element.id == idProduct)
        .toList();
    return newList[0];
  }

  void getLFavorite() {
    handler = DatabaseHandler();
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

    listFavorite = handler.getListFavorite;

    Navigator.pop(context);
  }

  // Widget getFooter() {
  //   return Container(
  //     height: 120,
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.all(30),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.6),
  //       boxShadow: const [
  //         BoxShadow(
  //           color: Color.fromRGBO(179, 213, 242, 0.2),
  //           spreadRadius: 5,
  //           blurRadius: 3,
  //         ),
  //       ],
  //       borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(30), topRight: Radius.circular(30)),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Row(
  //           mainAxisSize: MainAxisSize.max,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   for (var element in listFavorite) {
  //                     //handler.deleteFavorite(element.idFavorite!);
  //                   }
  //                   listFavorite = handler.getListFavorite;
  //                 });
  //               },
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 width: MediaQuery.of(context).size.width / 1.5,
  //                 height: 60,
  //                 decoration: const BoxDecoration(
  //                   color: Color(0xffb23a48),
  //                   borderRadius: BorderRadius.all(Radius.circular(20)),
  //                 ),
  //                 child: const Text(
  //                   'Delete All',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
