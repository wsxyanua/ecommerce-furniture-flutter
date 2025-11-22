import 'package:auto_size_text/auto_size_text.dart';
import 'package:furniture_app_project/provider/user_provider.dart';
import '../models/order_model.dart';
import '../provider/country_city_provider.dart';
import '../provider/cart_provider.dart';
import '../screens/result/result_order.dart';
import '../services/DatabaseHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

UserProvider userProvider = UserProvider();
CountryCityProvider countryCityProvider = CountryCityProvider();

class _CheckoutPageState extends State<CheckoutPage> {
  late List<Cart> listCart;
  late List<UserSQ> currentUser;

  @override
  void initState() {
    super.initState();
    final handler = DatabaseHandler();
    currentUser = handler.getListUser;
  }

  // Step 1
  TextEditingController fullNameInput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();
  TextEditingController addressInput = TextEditingController();
  TextEditingController noteInput = TextEditingController();

  bool validatePhone = true;
  bool validateName = true;
  bool validateForm = false;
  bool validateAddress = true;

  //Step 2
  TextEditingController cardNumberInput = TextEditingController();
  TextEditingController expireDateInput = TextEditingController();
  TextEditingController cVVInput = TextEditingController();

  bool validateCard = true;
  bool validateCVV = true;
  bool validateDate = true;

  // Validate payment method

  bool validateCreditCard = true;
  bool validateEWallet = true;

  late Country cityInput;
  late String countryInput;

  int activeCurrentStep = 1;
  int i = 0;

  RegExp digitValidator = RegExp("[0-9]+");
  RegExp nameValidator = RegExp("[a-zA-z]+");

  List<Country> listCountry = [];

  // Step 2
  String paymentMethod = 'Pay on delivery';
  String paymentMethodCollection = 'Pay on delivery';

  bool checkActiveCard(String cardName) {
    return (paymentMethod == cardName);
  }

  String currentActionText = "Next";
  void setValidateMethod() {
    setState(() {
      if (paymentMethodCollection == "Credit cards") {
        if (paymentMethod == "Visa" || paymentMethod == "Mastercard") {
          validateCreditCard = true;
        } else {
          validateCreditCard = false;
        }
      } else if (paymentMethodCollection == "E-wallets") {
        if (paymentMethod == 'Webmoney' ||
            paymentMethod == 'Paypal' ||
            paymentMethod == "Zalopay") {
          validateEWallet = true;
        } else {
          validateEWallet = false;
        }
      }

      if (validateEWallet == true && validateCreditCard == true) {
        activeCurrentStep = 3;
      }
    });
  }

  void setValidateForm() {
    setState(() {
      if (fullNameInput.text.isNotEmpty && validateName == true) {
        if (phoneInput.text.isNotEmpty && validatePhone == true) {
          if (addressInput.text.isNotEmpty) {
            validateForm = true;
            activeCurrentStep = 2;
          }
        }
      }

      if (addressInput.text.isEmpty) {
        validateAddress = false;
      } else {
        validateAddress = true;
      }

      if (fullNameInput.text.isEmpty) {
        validateName = false;
      } else {
        validateName = true;
      }

      if (phoneInput.text.isEmpty) {
        validatePhone = false;
      } else {
        validatePhone = true;
      }
    });
  }

  void setCurrentActionText() {
    if (activeCurrentStep == 3) {
      setState(() {
        currentActionText = "Order";
      });
    }
  }

  int num = 0;

  @override
  Widget build(BuildContext context) {
    countryCityProvider = Provider.of<CountryCityProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    if (num == 0) {
      fullNameInput.text = userProvider.currentUser.fullName;
      phoneInput.text = userProvider.currentUser.phone;
      addressInput.text = userProvider.currentUser.address;

      num = 1;
    }

    countryCityProvider.getListCountry();
    listCountry = countryCityProvider.getCountryCityList;
    final cartProvider = Provider.of<CartProvider>(context);
    listCart = cartProvider.cartItems;
    final handler = DatabaseHandler();
    currentUser = handler.getListUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff2f9fe),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const AutoSizeText(
          'Checkout',
          maxFontSize: 17,
          minFontSize: 12,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Step 1
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Color(0xfff2f9fe),
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
                        child: const Icon(
                          Icons.local_shipping_outlined,
                          color: Color(0xff81221e),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Shipping'),
                    ],
                  ),
                  // Line 1
                  Visibility(
                    visible: !setVisibilityLineStep(2),
                    child: Column(
                      children: [
                        Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 5,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setVisibilityLineStep(2),
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width / 5,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  // Step 2
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Color(0xfff2f9fe),
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
                        child: const Icon(
                          Icons.payment_outlined,
                          color: Color(0xff81221e),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Payment'),
                    ],
                  ),
                  // Line 2
                  Visibility(
                    visible: !setVisibilityLineStep(3),
                    child: Column(
                      children: [
                        Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 5,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setVisibilityLineStep(3),
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width / 5,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  //Step 3
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Color(0xfff2f9fe),
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
                        child: const Icon(
                          Icons.reviews_outlined,
                          color: Color(0xff81221e),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Review'),
                    ],
                  ),
                ],
              ),
              getIndexStep(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: getFooter(),
    );
  }

  bool setVisibilityLineStep(int index) {
    return (activeCurrentStep >= index);
  }

  Widget getFooter() {
    if(activeCurrentStep == 3) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),

          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
            Container(
              height: 160,
              width: MediaQuery.of(context).size.width/1.2,
              padding: const EdgeInsets.all(10),

              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('Order Summary' , style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal',style: TextStyle(
                        fontSize: 15,
                      ),),
                      Text("\$ ${totalPrice(listCart).toStringAsFixed(2)}",style: const TextStyle(
                        fontSize: 15,
                      ),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('VAT (10%)',style: TextStyle(
                        fontSize: 15,
                      ),),
                      Text('\$ ${accumVAT().toStringAsFixed(2)}',style: const TextStyle(
                        fontSize: 15,
                      ),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Delivery fee',style: TextStyle(
                        fontSize: 15,
                      ),),
                      Text('\$ 20',style: TextStyle(
                        fontSize: 15,
                      ),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [Container(
                      width: MediaQuery.of(context).size.width/1.29,
                      height: 1,
                      color: Colors.black,
                    )],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                      Text("\$ ${accumALLBILL().toStringAsFixed(2)}",style: const  TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10, left: 30),
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xff81221e),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    child: Container(
                      width: 200,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 10, right: 30),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xffe5665a),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(179, 213, 242, 1),
                            spreadRadius: 0.3,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Color(0xffffffff),
                            spreadRadius: 0.3,
                            offset: Offset(-5, -5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResultOrder(order: setOrder(), listCart: listCart)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 0,
                              ),
                              Text(
                                currentActionText,
                                style: const TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: 18,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: Color(0xffffffff),
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                            ],
                          )),
                    )),
              ],
            ),
          ],
        ),
      );
    }
    else {
      return Row(
        children: [
          Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 10),
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xff81221e),
                      fontSize: 18,
                    ),
                  ),
                ),
              )),
          Expanded(
              child: Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xffe5665a),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(179, 213, 242, 1),
                      spreadRadius: 0.3,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Color(0xffffffff),
                      spreadRadius: 0.3,
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextButton(
                    onPressed: () {
                      if (activeCurrentStep == 1) {
                        setValidateForm();
                      } else if (activeCurrentStep == 2) {
                        setValidateMethod();
                        setCurrentActionText();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 0,
                        ),
                        Text(
                          currentActionText,
                          style: const TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 18,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_outlined,
                          color: Color(0xffffffff),
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                      ],
                    )),
              )),
        ],
      );
    }
  }

  Widget getIndexStep() {
    if (activeCurrentStep == 1) {
      return getStep1Shipping();
    } else if (activeCurrentStep == 2) {
      return getStep2Payment();
    } else if (activeCurrentStep == 3) {
      return getStep3Review();
    } else {
      return Container();
    }
  }

  Widget getStep1Shipping() {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 10),
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom / 1.5,
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full name Input
            const Text(
              'Full name',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty || nameValidator.hasMatch(value)) {
                    setState(() {
                      validateName = true;
                    });
                  } else {
                    setState(() {
                      validateName = false;
                    });
                  }

                },

                controller: fullNameInput,
                keyboardType: TextInputType.text,
                maxLines: 1,
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Visibility(
              visible: !validateName,
              child: const Text(
                'Full name is only character and not empty',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Phone Input
            const Text(
              'Phone',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                readOnly: true,
                onChanged: (value) {
                  if (value.isEmpty || digitValidator.hasMatch(value)) {
                    setState(() {
                      validatePhone = true;
                    });
                  } else {
                    setState(() {
                      validatePhone = false;
                    });
                  }
                },
                keyboardType: TextInputType.number,
                controller: phoneInput,
                maxLines: 1,
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            Visibility(
              visible: !validatePhone,
              child: const Text(
                'Phone is only number and not empty',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            getDropDownButton(),

            // Address Input
            const Text(
              'Address',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      validateAddress = true;
                    });
                  }
                },
                keyboardType: TextInputType.text,
                controller: addressInput,
                maxLines: 1,
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            Visibility(
              visible: !validateAddress,
              child: const Text(
                'Address is not empty',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Note Input
            const Text(
              'Note',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: noteInput,
                maxLines: 1,
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget getStep2Payment() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom / 1.5,
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Credit card
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Choose payment method',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                RadioListTile(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  title: const Text('Credit cards'),
                  value: 'Credit cards',
                  groupValue: paymentMethodCollection,
                  toggleable: true,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                      paymentMethodCollection = value;
                    });
                  },
                )
              ],
            ),
            Visibility(
              visible: !validateCreditCard,
              child: const Text(
                'You must choose payment methods under',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      paymentMethod = "Visa";
                      paymentMethodCollection = 'Credit cards';
                    });
                  },
                  child: getContainerActivePaymentCard('Visa'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      paymentMethod = "Mastercard";
                      paymentMethodCollection = 'Credit cards';
                    });
                  },
                  child: getContainerActivePaymentCard('Mastercard'),
                )
              ],
            ),

            getActiveFromCard(paymentMethod),

            // E-wallets
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                RadioListTile(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  title: const Text('E-wallets'),
                  value: 'E-wallets',
                  groupValue: paymentMethodCollection,
                  toggleable: true,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                      paymentMethodCollection = value;
                    });
                  },
                )
              ],
            ),
            Visibility(
              visible: !validateEWallet,
              child: const Text(
                'You must choose payment methods under',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      paymentMethod = "Webmoney";
                      paymentMethodCollection = 'E-wallets';
                    });
                  },
                  child: getContainerActiveEWallet('Webmoney'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      paymentMethod = "Paypal";
                      paymentMethodCollection = 'E-wallets';
                    });
                  },
                  child: getContainerActiveEWallet('Paypal'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      paymentMethod = "Zalopay";
                      paymentMethodCollection = 'E-wallets';
                    });
                  },
                  child: getContainerActiveEWallet('Zalopay'),
                ),
              ],
            ),

            // Pay on delivery
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                RadioListTile(
                  value: 'Pay on delivery',
                  groupValue: paymentMethodCollection,
                  toggleable: true,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                      paymentMethodCollection = value;
                    });
                  },
                  title: const Text('Pay on delivery'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getStep3Review() {
    return Container(
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
    alignment: Alignment.topLeft,
    width: MediaQuery.of(context).size.width,

    height: MediaQuery.of(context).size.height / 3.5,
    child: SingleChildScrollView(
    //reverse: true,
      child: Column(
        children: [
          // Shipping address
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Shipping address main
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shipping address' , style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          activeCurrentStep = 1;
                          currentActionText = "Next";
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
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xff81221e),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),

                // Full name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Fullname' , style: TextStyle(
                      fontSize: 15,
                    ),),
                    Text("Nguyen Thi Thu Thao" , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),

                //Phone
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Phone' , style: TextStyle(
                      fontSize: 15,
                    ),),
                    Text("0868286420" , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),

                // country
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Country' , style: TextStyle(
                      fontSize: 15,
                    ),),
                    Text("Vietnam" , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),

                // city
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('State/City/Province' , style: TextStyle(
                      fontSize: 15,
                    ),),
                    Text("Ho Chi Minh City" , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),

                // address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Address' , style: TextStyle(
                      fontSize: 15,
                    ),),
                    Text("HCM" , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),

                // note
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Note' , style: TextStyle(
                      fontSize: 15,
                    ),),
                    Text("" , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          // Method Payment Infor
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),

            child: Column(
              children: [
                // Shipping address main
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Payment Method' , style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          activeCurrentStep = 2;
                          currentActionText = "Next";
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
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xff81221e),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                // Payment name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Pay on delivery' , style: TextStyle(
                      fontSize: 15,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          const SizedBox(height: 40,),
          // Order Item
          Row(
            children: const [
              Text('Order Item' , style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
            ],
          ),const SizedBox(height: 20,),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
              //scrollDirection: Axis.vertical,
              shrinkWrap: true,
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
                  key: ValueKey<int>(listCart[index].idCart!),
                  onDismissed: (DismissDirection direction) async {
                    //await handler.deleteCart(listCart[index].idCart!);
                    setState(() {
                      listCart.remove(listCart[index]);
                    });
                  },
                  child: Container(
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
                                listCart[index].imgProduct),width: 50,
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
                                listCart[index].nameProduct,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                listCart[index].color,
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
                                accumPrice(listCart[index].price,
                                    listCart[index].quantity),
                                style: const TextStyle(
                                  color: Color(0xff5e1414),
                                  fontSize: 15,
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
                                  size: 15,
                                )),
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                listCart[index].quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
                                  color: Colors.black,size: 15,)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
          const SizedBox(height: 20,),
        ],
      ),
    ),
    );
  }

  Widget getContainerActivePaymentCard(String paymentName) {
    String image = "assets/payments/$paymentName.png";
    if (checkActiveCard(paymentName) == true) {
      return Container(
        width: MediaQuery.of(context).size.width / 2.5,
        padding: const EdgeInsets.all(5),
        height: 100,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                offset: Offset(10, 10),
                color: Color.fromRGBO(179, 213, 242, 0.6),
                spreadRadius: 1,
                blurRadius: 20,
              ),
              BoxShadow(
                offset: Offset(-10, -10),
                color: Color(0xffffffff),
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
            border: Border.all(
              color: const Color.fromRGBO(179, 213, 242, 1),
              width: 2,
            )),
        child: Image(
          image: AssetImage(image),
          fit: BoxFit.contain,
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 100,
        child: Image(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget getContainerActiveEWallet(String paymentName) {
    String image = "assets/payments/$paymentName.png";
    if (checkActiveCard(paymentName) == true) {
      return Container(
        width: MediaQuery.of(context).size.width / 5,
        padding: const EdgeInsets.all(5),
        height: 70,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                offset: Offset(10, 10),
                color: Color.fromRGBO(179, 213, 242, 0.6),
                spreadRadius: 1,
                blurRadius: 20,
              ),
              BoxShadow(
                offset: Offset(-10, -10),
                color: Color(0xffffffff),
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
            border: Border.all(
              color: const Color.fromRGBO(179, 213, 242, 1),
              width: 2,
            )),
        child: Image(
          image: AssetImage(image),
          fit: BoxFit.contain,
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: 70,
        child: Image(
          image: AssetImage(image),
          fit: BoxFit.fill,
        ),
      );
    }
  }

  Widget getActiveFromCard(String paymentName) {
    if (paymentName == "Visa" || paymentName == "Mastercard") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          // Card number
          const Text(
            'Card number',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.transparent,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: TextField(
              onChanged: (value) {
                if (value.isEmpty || digitValidator.hasMatch(value)) {
                  setState(() {
                    validateCard = true;
                  });
                } else {
                  setState(() {
                    validateCard = false;
                  });
                }
              },
              controller: cardNumberInput,
              keyboardType: TextInputType.number,
              maxLines: 1,
              cursorColor: Colors.black,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "**** **** **** ****",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Visibility(
            visible: !validateCard,
            child: const Text(
              'Card number only number and not empty',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expire Date',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.center,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          if (value.isEmpty || digitValidator.hasMatch(value)) {
                            setState(() {
                              validateDate = true;
                            });
                          } else {
                            setState(() {
                              validateDate = false;
                            });
                          }
                        },
                        controller: expireDateInput,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: "MM/YY",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !validateDate,
                      child: const Text(
                        'Card Expire date only number and not empty',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CVV',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.center,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          if (value.isEmpty || digitValidator.hasMatch(value)) {
                            setState(() {
                              validateCVV = true;
                            });
                          } else {
                            setState(() {
                              validateCVV = false;
                            });
                          }
                        },
                        controller: cVVInput,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !validateCVV,
                      child: const Text(
                        'Card CVV only number and not empty',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else if (paymentMethod == "Mastercard") {
      return Container();
    } else if (paymentMethod == "Webmoney") {
      return Container();
    } else if (paymentMethod == "Paypal") {
      return Container();
    } else if (paymentMethod == "Zalopay") {
      return Container();
    } else {
      return Container();
    }
  }

  Widget getDropDownButton() {
    if (listCountry.isNotEmpty) {
      if (i == 0) {
        cityInput = listCountry[0];
        countryInput = listCountry[0].city[0];
        i += 1;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Country>(
                      menuMaxHeight: MediaQuery.of(context).size.height / 2,
                      isExpanded: true,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      dropdownColor: const Color(0xfff2f9fe),
                      value: cityInput,
                      items: listCountry.map((e) {
                        return DropdownMenuItem<Country>(
                          value: e,
                          child: Text(e.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          cityInput = Country(
                              name: value!.name,
                              id: value.id,
                              city: value.city);
                          countryInput = value.city[0];
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'State/City/Province',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      menuMaxHeight: MediaQuery.of(context).size.height / 2,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      dropdownColor: const Color(0xfff2f9fe),
                      isExpanded: true,
                      value: countryInput,
                      items: cityInput.city.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (e) {
                        setState(() {
                          countryInput = e!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
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

  double totalPrice(List<Cart> listCart) {
    double total = 0;

    for (var element in listCart) {
      total += element.quantity * element.price;
    }

    return total;
  }
  double accumVAT() {
    double price = totalPrice(listCart);
    return price * 0.1 ;
  }
  double accumALLBILL() {
    return totalPrice(listCart) + 20 + accumVAT();
  }

  void updateUpQuantity(int idCart, int quantity) {
    handler.updateCart(idCart, quantity + 1);
    setState(() {
      listCart = handler.retrieveCarts() as List<Cart>;
    });
  }

  OrderModel setOrder() {
    return OrderModel(idUser: userProvider.currentUser.idUser,
        paymentMethod: paymentMethod,
        fullName: fullNameInput.text, address: addressInput.text, city: countryInput, country: cityInput.name, dateOrder: DateTime.now(), deliveryFee: 20, idOrder: DateTime.now().toString().replaceAll(" ", "").replaceAll("-", "").replaceAll(".", "").replaceAll(":", ""), note: noteInput.text, phone: phoneInput.text, statusOrder: "CHECKING", statusPayment: "NO PAY", subTotal: totalPrice(listCart), totalOrder: accumALLBILL(), vat: accumVAT(), cartList: const []);
  }

  void updateDownQuantity(int idCart, int quantity) {
    if (quantity == 1) {
      handler.deleteCart(idCart);
    } else {
      handler.updateCart(idCart, quantity - 1);
    }

    setState(() {
      listCart = handler.retrieveCarts() as List<Cart>;
    });
  }
}
