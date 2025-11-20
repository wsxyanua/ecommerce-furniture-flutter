import 'package:auto_size_text/auto_size_text.dart';
import '../screens/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../provider/product_provider.dart';
import '../services/DatabaseHandler.dart';
import '../widgets/bottom_navy_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

ProductProvider productProvider = ProductProvider();

class _CartPageState extends State<CartPage> {
  late DatabaseHandler handler;
  late List<Cart> listCart;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    //handler.retrieveCarts();
    listCart = handler.getListCart;
    return Scaffold(
      backgroundColor: const Color(0xfff2f9fe),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const AutoSizeText(
          'Cart',
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
              Icons.favorite_border_outlined,
              color: Color(0xff81221e),
            ),
            label: const Text(''),
          )
        ],
      ),
      body: listCart.isNotEmpty ? ListView.builder(
          itemCount: listCart.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                color: const Color(0xfff2f9fe),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Icon(Icons.delete_forever),
              ),

              secondaryBackground: Container(
                color: const Color(0xff81221e),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Icon(Icons.delete_forever),
              ),
              key: ValueKey<int>(listCart[index].idCart!),
              onDismissed: (DismissDirection direction) {
                deleteCart(listCart[index].idCart!);
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
                      color: Color.fromRGBO(179, 213, 242, 0.2),
                      spreadRadius: 5,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*FadeInImage(
                                image: NetworkImage(snapshot.data![index].imgProduct
                                    ),
                                width: 90,
                                height: 90, placeholder: const AssetImage(
                                  "assets/images/logo.png"),
                              ),*/

                        Image(image: AssetImage(
                            listCart[index].imgProduct),width: 90,
                            height: 90)
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      alignment: Alignment.topLeft,
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            listCart[index].nameProduct,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              listCart[index].color,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            accumPrice(listCart[index].price,
                                listCart[index].quantity),
                            style: const TextStyle(
                              color: Color(0xff5e1414),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                updateDownQuantity(
                                    listCart[index].idCart!,
                                    listCart[index].quantity);
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.black,
                            )),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xff5e1414),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            listCart[index].quantity.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                updateUpQuantity(
                                    listCart[index].idCart!,
                                    listCart[index].quantity);
                              });
                            },
                            icon: const Icon(Icons.add,
                                color: Colors.black)),
                      ],
                    )
                  ],
                ),
              ),
            );
          }) : Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 2 - 200,),
            const Image(image: AssetImage("assets/icons/empty.png")),
            const Text(
              'Not Cart',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: listCart.isNotEmpty ? getCFooter() : getFooter(1, context),
    );
  }

  void deleteCart(int idCart) {
    handler.deleteCart(idCart);
  }


  Widget getCFooter() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(179, 213, 242, 0.2),
            spreadRadius: 5,
            blurRadius: 3,
          ),
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sub Item",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getQuantity(listCart),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.20,
                height: 1,
                color: Colors.grey,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                totalPrice(listCart),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.20,
                height: 1,
                color: Colors.grey,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
                },
                child:  Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xffb23a48),
                    borderRadius:  BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Text('Checkout' , style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String accumPrice(double price, int quantity) {
    return "\$ ${price * quantity}";
  }

  String getQuantity(List<Cart> listCart) {
    double quantity = 0;

    for (var element in listCart) {
      quantity += element.quantity;
    }

    return quantity.toStringAsFixed(0);
  }

  String totalPrice(List<Cart> listCart) {
    double total = 0;

    for (var element in listCart) {
      total += element.quantity * element.price;
    }

    String finalText = total.toStringAsFixed(2);

    return "\$ $finalText";
  }

  void updateUpQuantity(int idCart, int quantity) {
    handler.updateCart(idCart, quantity + 1);
  }

  void updateDownQuantity(int idCart, int quantity) {
    if (quantity == 1) {
      handler.deleteCart(idCart);
    } else {
      handler.updateCart(idCart, quantity - 1);
    }
  }
}
