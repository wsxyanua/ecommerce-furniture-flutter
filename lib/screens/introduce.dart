import 'package:carousel_slider/carousel_slider.dart';
import '../screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Introduce extends StatefulWidget {
  const Introduce({super.key});

  @override
  State<Introduce> createState() => _IntroduceState();
}

final List<String> imgList = [
  'assets/images/introduce1.png',
  'assets/images/introduce2.png',
  'assets/images/introduce3.png',
  'assets/images/introduce4.png',
];

final List<String> textList = [
  'Easy Shopping Online',
  'Free Ship Everywhere',
  'Free installation at home',
  'Flash Sales Monthly'
];

final List<String> textDetail = [
  "With just one phone you can discover all our products easily",
  "We offer free shipping anywhere in the country on all orders",
  "We will install the furniture for you completely free of charge",
  "We will hold many discounts every month",
];

class _IntroduceState extends State<Introduce> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    storePref();
    super.initState();
  }

  Future<void> storePref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('SHOW_INTRODUCT_PAGE', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(0),
        child: OnBoardingSlider(
            finishButtonText: 'Sign up',
            finishButtonTextStyle: const TextStyle(
              color: Color(0xff410000),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            centerBackground: true,
            onFinish: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Register()));
            },
            skipIcon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            totalPage: 4,
            finishButtonStyle: const FinishButtonStyle(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)))),
            skipTextButton: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            controllerColor: Colors.white,
            headerBackgroundColor: const Color(0xff410000),
            pageBackgroundColor: const Color(0xff410000),
            background: [
              Image(
                image: AssetImage(imgList[2]),
                height: 300,
              ),
              Image(
                image: AssetImage(imgList[0]),
                height: 300,
              ),
              Image(
                image: AssetImage(imgList[1]),
                height: 300,
              ),
              Image(
                image: AssetImage(imgList[3]),
                height: 300,
              ),
            ],
            speed: 1.8,
            pageBodies: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 400,
                    ),
                    Text(
                      textList[0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      textDetail[0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 400,
                    ),
                    Text(
                      textList[1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      textDetail[1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 400,
                    ),
                    Text(
                      textList[2],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      textDetail[2],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 400,
                    ),
                    Text(
                      textList[3],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      textDetail[3],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
