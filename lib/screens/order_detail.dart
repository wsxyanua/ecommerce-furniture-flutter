import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_app_project/models/order_model.dart';
import 'package:barcode/barcode.dart';
import 'package:furniture_app_project/screens/order.dart';
import 'package:furniture_app_project/screens/review_product.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  final bc = Barcode.gs128();

  @override
  Widget build(BuildContext context) {
    final svg = bc.toSvg(widget.order.idOrder, width: 200.0, height: 70.0);

    return Scaffold(
      backgroundColor: const Color(0xfff2f9fe),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: CustomPaint(
                    painter: CustomBill(
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        // Part 1
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('ORDER DETAIL' , style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Order code' , style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.string(svg)
                          ],
                        ),
                        const SizedBox(height: 25,),

                        // Line Dash
                        Container(
                          margin: const EdgeInsets.only(left: 20,right: 20),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: List.generate(( MediaQuery.of(context).size.width / (2 * 10.0)).floor(), (_) {
                              return const SizedBox(
                                width: 10.0,
                                height: 2.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.grey),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        // Part 2
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Order code
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Order code:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("#${widget.order.idOrder}" , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Date Order
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Date order:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(getDate(widget.order.dateOrder) , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Payment Method
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Payment method:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.paymentMethod , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Status
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Status:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.statusOrder , style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Total Bill
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Bill:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("\$ ${widget.order.totalOrder.toStringAsFixed(2)}" , style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12,),
                        // Line Dash
                        Container(
                          margin: const EdgeInsets.only(left: 20,right: 20),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: List.generate(( MediaQuery.of(context).size.width / (2 * 10.0)).floor(), (_) {
                              return const SizedBox(
                                width: 10.0,
                                height: 2.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.grey),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20,),

                        // Part 3
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Total Item
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Total Item:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.cartList.length.toString() , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              Wrap(
                                spacing: 0,
                                runSpacing: 10,
                                children: widget.order.cartList.map((e) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.quantity.toString() , style: const TextStyle(
                                            fontSize: 16,
                                          ),),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: const [
                                          Text('X' , style: TextStyle(
                                              fontSize: 16
                                          ),),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.nameProduct , style: const TextStyle(
                                              fontSize: 16
                                          ),),
                                          Text(e.color , style: const TextStyle(
                                              fontSize: 16
                                          ),),
                                        ],
                                      ),),
                                      const SizedBox(width: 10,),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("\$ ${e.price.toStringAsFixed(2)}" , style: const TextStyle(
                                              fontSize: 16
                                          ),),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 20,),

                              // Fee Item
                              // VAT
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Sub Item: ' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("\$${widget.order.subTotal.toStringAsFixed(2)}" , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Sub total
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('VAT (10%):' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("\$${widget.order.vat.toStringAsFixed(2)}" , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Deli fee
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Delivery fee:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("\$${widget.order.deliveryFee.toStringAsFixed(2)}" , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                        // Line Dash
                        Container(
                          margin: const EdgeInsets.only(left: 20,right: 20),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: List.generate(( MediaQuery.of(context).size.width / (2 * 10.0)).floor(), (_) {
                              return const SizedBox(
                                width: 10.0,
                                height: 2.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.grey),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 10,),

                        // Part 4
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Customer
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Customer:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.fullName , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Phone
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Phone:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.phone , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Address
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Address:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.address , style: const TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // Country
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Country:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.country , style: const TextStyle(
                                        fontSize: 16,
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // City
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('City:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.city , style: const TextStyle(
                                        fontSize: 16,
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),

                              // City
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Note:' , style: TextStyle(
                                          fontSize: 16
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.order.note , style: const TextStyle(
                                        fontSize: 16,
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: getFoo(),
    );
  }

  String getDate(DateTime date) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy  hh:MM:ss");
    return dateFormat.format(date);
  }

  Widget getFoo() {

    if(widget.order.statusOrder == 'CHECKING') {
      return Container(
        margin: const EdgeInsets.all(10),
        child:
        GestureDetector(
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
            orderProvider.updateOrder(widget.order, userProvider.currentUser.idUser).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
          child:  Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.5,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xffb23a48),
              borderRadius:  BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text('Cancel order' , style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),),
          ),
        ),
      );
    }
    else if(widget.order.statusOrder == 'COMPLETE') {
      return Container(
        margin: const EdgeInsets.all(10),
        child:
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(orderModel: widget.order)));
          },
          child:  Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.5,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xffb23a48),
              borderRadius:  BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text('Review' , style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),),
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

}

class CustomBill extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(0, 30);
    path0.quadraticBezierTo(size.width * 0.03, 0,
        size.width*0.1, 0);
    path0.lineTo(size.width * 0.5, 0);
    path0.lineTo(size.width * 0.5, 200);
    path0.lineTo(0, 200);
    path0.quadraticBezierTo(size.width * 0.08, 180,0, 160);
    path0.lineTo(0, 30);

    path0.moveTo(size.width * 0.5, 0);
    path0.lineTo(size.width * 0.9, 0);
    path0.quadraticBezierTo(size.width * 0.97, 0,
        size.width, 30);
    path0.lineTo(size.width, 160);
    path0.quadraticBezierTo(size.width * 0.92, 180,size.width, 200);
    path0.lineTo(size.width*0.5, 200);

    path0.moveTo(size.width, 200);
    path0.lineTo(size.width, 370);
    path0.lineTo(size.width * 0.5, 370);
    path0.lineTo(0, 370);
    path0.lineTo(0, 200);

    path0.moveTo(0, 370);
    path0.lineTo(size.width*0.5, 370);
    path0.lineTo(size.width*0.5, 680);
    path0.lineTo(0, 680);
    path0.lineTo(0, 410);
    path0.quadraticBezierTo(size.width * 0.08, 390,0, 370);

    path0.moveTo(size.width * 0.5, 370);
    path0.lineTo(size.width, 370);
    path0.quadraticBezierTo(size.width * 0.92, 390,size.width, 410);
    path0.lineTo(size.width, 680);
    path0.lineTo(size.width * 0.5, 680);

    path0.moveTo(0, 680);
    path0.lineTo(size.width*0.5, 680);
    path0.lineTo(size.width*0.5, 900);
    path0.lineTo(0, 900);
    path0.lineTo(0, 720);
    path0.quadraticBezierTo(size.width * 0.08, 700,0, 680);

    path0.moveTo(size.width * 0.5, 680);
    path0.lineTo(size.width, 680);
    path0.quadraticBezierTo(size.width * 0.92, 700,size.width, 720);
    path0.lineTo(size.width, 900);
    path0.lineTo(size.width * 0.5, 900);


    path0.moveTo(0, 900);
    path0.quadraticBezierTo(size.width * 0.03, 930,size.width * 0.1, 930);
    path0.lineTo(size.width * 0.9, 930);
    path0.quadraticBezierTo(size.width * 0.97, 930,size.width, 900);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

