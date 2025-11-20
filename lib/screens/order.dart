import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app_project/provider/order_provider.dart';
import 'package:furniture_app_project/provider/user_provider.dart';
import 'package:furniture_app_project/screens/cart.dart';
import 'package:furniture_app_project/screens/favorite.dart';
import 'package:furniture_app_project/screens/order_detail.dart';
import 'package:furniture_app_project/widgets/bottom_navy_bar.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

OrderProvider orderProvider = OrderProvider();
UserProvider userProvider = UserProvider();

class _OrderPageState extends State<OrderPage> {

  List<OrderModel> listOrder = [];

  @override
  Widget build(BuildContext context) {
    orderProvider = Provider.of<OrderProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    orderProvider.getOrderByIDUser(userProvider.currentUser.idUser);
    listOrder = orderProvider.getLIstOrder;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: const Color(0xfff2f9fe),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Color(0xff81221e),
                ),
                label: const Text(''),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                },
                icon: const Icon(
                  Icons.shopping_bag,
                  color: Color(0xff81221e),
                ),
                label: const Text(''),
              )
            ],
            bottom: TabBar(
              indicatorColor: Colors.red[700],
              labelColor: Colors.red[700],
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'Checking',),
                Tab(text: 'Delivering',),
                Tab(text: 'Complete'),
              ],
            ), // Tab
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 20,bottom: 20),
            child: TabBarView(
              children: [
                getCart('CHECKING'),
                getCart('DELIVERING'),
                getCart('COMPLETE'),
              ],
            ),
          ),
          bottomNavigationBar: getFooter(2, context),
        ),
      ),
    );
  }
  
  Widget getCart(String checking) {

    var newList = listOrder.where((element) => element.statusOrder == checking).toList();
    if(newList.isNotEmpty) {
      return ListView(
        children: newList.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(order: e)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.all(Radius.circular(10)),
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
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(image: AssetImage('assets/icons/bill.png'),fit: BoxFit.fill,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text("#${e.idOrder.replaceAll('-', "").replaceAll(':', "").replaceAll('.', "")}" , style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),overflow: TextOverflow.ellipsis,),
                      ),
                      const SizedBox(height: 5,),
                      Text("Customer: ${e.fullName}" , style: const TextStyle(
                        fontSize: 14,
                      ),),
                      const SizedBox(height: 5,),
                      Text("Phone: ${e.phone}" , style: const TextStyle(
                        fontSize: 14,
                      ),),
                      const SizedBox(height: 5,),
                      Text("Address: ${e.address}" , style: const TextStyle(
                        fontSize: 14,
                      ),),
                      const SizedBox(height: 5,),
                      Text("Bill: \$ ${e.totalOrder.toStringAsFixed(2)}" , style: const TextStyle(
                        fontSize: 14,
                      ),),
                      const SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.6,
                        alignment: Alignment.bottomRight,
                        child: Text(e.statusOrder , textAlign: TextAlign.end,style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
    else {
      return Center(
        child: Column(
          children: const [
            Image(image: AssetImage("assets/icons/empty.png")),
            Text('No order' , style: TextStyle(
              fontSize: 20,
            ),),
          ],
        ),
      );
    }
  }
}