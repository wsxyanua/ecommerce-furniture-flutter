import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:furniture_app_project/models/order_model.dart';
import 'package:furniture_app_project/models/product_model.dart';
import 'package:furniture_app_project/screens/cart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../provider/product_provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.orderModel});
  final OrderModel orderModel;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

ProductProvider productProvider = ProductProvider();

class _ReviewPageState extends State<ReviewPage> {
  double star = 0;
  TextEditingController messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);

    final ImagePicker imgpicker = ImagePicker();
    List<XFile>? imagefiles;

    openImages() async {
      try {
        var pickedfiles = await imgpicker.pickMultiImage();
        //you can use ImageCourse.camera for Camera capture
        if (pickedfiles != null) {
          setState(() {
            imagefiles = pickedfiles;
          });
        } else {
          print("No image is selected.");
        }
      } catch (e) {
        print("error while picking file.");
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xfff2f9fe),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Review',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xff81221e),
            ),
            label: const Text(''),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Image(
                  image: AssetImage("assets/images/review.png"),
                  width: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  itemSize: 40,
                  minRating: 0,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  unratedColor: Colors.grey,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      star = rating;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Text message
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff81221e),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                  //color: Color.fromRGBO(179, 213, 242, 0.2),
                                  color:
                                      const Color(0xff81221e).withOpacity(0.3),
                                  spreadRadius: 0.06,
                                  blurRadius: 24,
                                  offset: const Offset(12, 12)),
                              const BoxShadow(
                                  //color: Color.fromRGBO(179, 213, 242, 0.2),
                                  color: Color(0xffffffff),
                                  spreadRadius: 0.06,
                                  blurRadius: 24,
                                  offset: Offset(-12, -12)),
                            ],
                          ),
                          child: const Icon(Icons.message_rounded)),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Message',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Message Input
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                          color: Color(0xffe3eaef),
                          spreadRadius: 0.06,
                          blurRadius: 24,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                          color: Color(0xffffffff),
                          spreadRadius: 0.06,
                          blurRadius: 24,
                          offset: Offset(-4, -4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TextField(
                        maxLines: 5,
                        cursorColor: const Color(0xff410000),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        controller: messageController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          //hintText: currentPhoneNumber.format,
                          // prefixIcon: const Icon(
                          //   Icons.phone_android,
                          //   color: Color(0xff7c0019),
                          //   size: 30,
                          // ),
                          border: InputBorder.none,
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Input message
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff81221e),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: const Color(0xff81221e)
                                        .withOpacity(0.3),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: const Offset(12, 12)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-12, -12)),
                              ],
                            ),
                            child: const Icon(Icons.shopping_bag)),
                        onTap: () {
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Item Order',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Wrap(
                  children: widget.orderModel.cartList.map((e) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(179, 213, 242, 0.2),
                            spreadRadius: 5,
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage(
                                  e.imgProduct),width: 50,
                                  height: 50)
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            alignment: Alignment.topLeft,
                            height: 80,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  e.nameProduct,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  e.color,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  accumPrice( e.price,
                                     e.quantity),
                                  style: const TextStyle(
                                    color: Color(0xff5e1414),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: imagefiles != null
                      ? Wrap(
                          spacing: 0,
                          children: imagefiles!.map((e) {
                            return Container(
                              width: 100,
                              height: 100,
                              child: Image.file(File(e.path)),
                            );
                          }).toList(),
                        )
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    // The background color
                    backgroundColor: const Color(0xff560f20),
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
            
            var listProduct = productProvider.getListProduct;
            var product = Product(
                title: "",
                name: "",
                img: "",
                id: "",
                description: "",
                size: const {},
                rootPrice: 0,
                currentPrice: 0,
                categoryItemId: "",
                status: "",
                material: const {},
                review: 0,
                sellest: 0,
                productItemList: const [], reviewList: const [],
                timestamp: DateTime.now());

            for(var element in listProduct) {
              for(var e in element.productItemList) {
                if(e.id == widget.orderModel.cartList[0].idProduct) {
                  product = element;
                }
              }
            }

            int id = product.reviewList.length;

            var review = Review(
              id: 'RE${id + 1}',
              idUser: widget.orderModel.idUser,
              idOrder: widget.orderModel.idOrder,
              message: messageController.text,
              img: const [],
              date: DateTime.now(),
              service: const {},
              star: star,
            );

            productProvider.addReview(review, product.id).then((value) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return Dialog(
                      // The background color
                      backgroundColor: const Color(0xff560f20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Image(image: AssetImage("assets/icons/success.png"),width: 60,),
                            // Some text
                            SizedBox(height: 20,),
                            Text("Review successfully",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    );
                  }
              );
              Timer(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.5,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xffb23a48),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String accumPrice(double price, int quantity) {
    return "\$ ${price * quantity}";
  }

}
