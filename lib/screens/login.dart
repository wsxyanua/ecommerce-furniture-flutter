import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home.dart';
import '../screens/register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../services/api_service.dart';

import '../models/phone_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

bool isLoading = false;
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = RegExp(p);
RegExp digitExp = RegExp(r'^[0-9]+$');

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

bool obSerText = true;

List<PhoneNumber> listPhoneNumber = const [
  PhoneNumber(
      name: "United States", value: "+1", format: '(XXX)-XXX-XXXX', digit: 10),
  PhoneNumber(name: "Viet nam", value: "+84", format: 'XX XXX XXXX', digit: 9),
  PhoneNumber(name: "China", value: "+86", format: 'XXX XXXX XXXX', digit: 11),
  PhoneNumber(name: "Japan", value: "+81", format: 'X-XXXX-XXXX', digit: 9),
  PhoneNumber(name: "Japan", value: "+44", format: 'XX XXXX XXXX', digit: 10),
];

class _LoginState extends State<Login> {

  PhoneNumber currentPhoneNumber = listPhoneNumber[0];
  String phoneInput = listPhoneNumber[0].value + listPhoneNumber[0].format;

  bool passwordVisible = true;
  bool validatePhone = true;
  bool validatePass = true;

  void submit(context) async {
    try {
      setState(() { isLoading = true; });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Dialog(
          backgroundColor: Color(0xff560f20),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator(color: Color(0xffecd8e0))),
            ),
          ),
        ),
      );

      final api = ApiService.instance;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await api.login(phoneController.text, passwordController.text);
      prefs.setString('AUTH_TOKEN', token);

      Navigator.pop(context);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const Dialog(
          backgroundColor: Color(0xff560f20),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: AssetImage("assets/icons/success.png"), width: 60),
                SizedBox(height: 20),
                Text("Login successfully", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );

      Timer(const Duration(milliseconds: 1200), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
      });
    } catch (error) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      setState(() { isLoading = false; });
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: const Color(0xff560f20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(image: AssetImage("assets/icons/cancel.png"), width: 60),
                const SizedBox(height: 20),
                Text("Login failed: ${error.toString()}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffecd8e0))),
                  onPressed: () { Navigator.pop(context); },
                  child: const Text('OK', style: TextStyle(color: Color(0xff560f20), fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void validation(BuildContext context) async {
    if (phoneController.text.isEmpty &&
        passwordController.text.isEmpty) {
      setState(() {
        validatePhone = false;
        validatePass  = false;
      });
    }

    if(validatePhone) {
      if (validatePass) {
        if (validatePass) {
          submit(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    List<String> errorMessage = [
      "Phone is only ${currentPhoneNumber.digit} number and not empty",
      'Password must least 8 digit and not empty',
    ];

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom / 2,
        ),
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_login.jpg"),
              fit: BoxFit.fill,
            )),
        child: SafeArea(
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(20),
            borderRadius: 20,
            linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                ],
                stops: const [
                  0.5,
                  1
                ]),
            border: 0,
            blur: 20,
            borderGradient: const LinearGradient(colors: [
              Colors.white,
              Colors.white,
            ]),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipPath(
                      clipper: Clipper(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/background_login.jpg"),
                              fit: BoxFit.fill,
                            )),
                        padding: const EdgeInsets.only(left: 70, right: 70),
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                    ),
                    const Text(
                      "Welcom back",
                      style: TextStyle(
                          color: Color(0xff410000),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Login to your account",
                      style: TextStyle(
                        color: Color(0xff410000),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    // Phone Number
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 10, top: 20, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
                          ],
                          stops: const [
                            0.5,
                            0.8,
                            1
                          ]),
                      border: 0,
                      blur: 0,
                      borderGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.2),
                          ],
                          stops: const [
                            0.5,
                            1
                          ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/6,
                            margin: const EdgeInsets.only(left: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<PhoneNumber>(
                                menuMaxHeight:
                                MediaQuery.of(context).size.height / 2,
                                isExpanded: true,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                                dropdownColor: const Color(0xfff2f9fe),
                                value: currentPhoneNumber,
                                items: listPhoneNumber.map((e) {
                                  return DropdownMenuItem<PhoneNumber>(
                                    value: e,
                                    child: Text(e.value , style: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff410000),
                                    ),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    currentPhoneNumber = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (text) {
                                if((text.isEmpty || digitExp.hasMatch(text)) && text.length == currentPhoneNumber.digit) {
                                  setState(() {
                                    validatePhone = true;
                                  });
                                }
                                else {
                                  setState(() {
                                    validatePhone = false;
                                  });
                                }

                                if(text.isEmpty) {
                                  validatePhone = true;
                                }
                              },
                              cursorColor: const Color(0xff410000),
                              style: const TextStyle(
                                letterSpacing: 1,
                                fontSize: 20,
                                color: Color(0xff410000),
                              ),
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: currentPhoneNumber.format,
                                prefixIcon: const Icon(
                                  Icons.phone_android,
                                  color: Color(0xff7c0019),
                                  size: 30,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !validatePhone,
                      child: Column(
                        children: [
                          Text(
                            errorMessage[0],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 5,),
                        ],
                      ),
                    ),

                    // Password
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
                          ],
                          stops: const [
                            0.5,
                            0.8,
                            1
                          ]),
                      border: 0,
                      blur: 0,
                      borderGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.2),
                          ],
                          stops: const [
                            0.5,
                            1
                          ]),
                      child: TextField(
                        onChanged: (text) {
                          validatePass = true;
                        },
                        cursorColor: const Color(0xff410000),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Color(0xff410000),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        obscureText: passwordVisible,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.key_outlined,
                            color: Color(0xff7c0019),
                            size: 30,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xff7c0019),
                            ),
                            onPressed: (() {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            }),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !validatePass,
                      child: Column(
                        children: [
                          Text(
                            errorMessage[1],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 5,),
                        ],
                      ),
                    ),

                    // Forget password
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(right: 30),
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget Password ?",
                            style: TextStyle(
                                color: Color(0xff410000),
                                fontStyle: FontStyle.italic,
                                fontSize: 17),
                          )),
                    ),

                    // Button submit
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 0, top: 10, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xff410000).withOpacity(0.8),
                            const Color(0xff410000).withOpacity(0.6),
                            const Color(0xff410000).withOpacity(0.3),
                          ],
                          stops: const [
                            0.5,
                            0.8,
                            1
                          ]),
                      border: 0,
                      blur: 0,
                      borderGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.2),
                          ],
                          stops: const [
                            0.5,
                            1
                          ]),
                      child: ButtonTheme(
                        child: MaterialButton(
                          minWidth: double.infinity,
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            validation(context);
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have account ?",
                          style: TextStyle(
                              color: Color(0xff410000),
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            });
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
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