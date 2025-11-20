import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
Widget getCategoryList(List<Category> categoryList) {

  if(categoryList.isNotEmpty) {
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10),
      height: 160,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: -1,
          direction: Axis.vertical,
          children: categoryList
              .map(
                (element) => Container(
              // margin: EdgeInsets.symmetric(horizontal: 5),
              width: 130,
              height: 160,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffe3eaef),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(12, 12)
                        ),
                        BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffffffff),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(-12, -12)
                        ),
                      ],
                    ),
                    //child: Image(image: NetworkImage(element.img),fit: BoxFit.fill),
                    child: FadeInImage(image: AssetImage(element.img),fit: BoxFit.fill,placeholder: const AssetImage("assets/icons/spinner100.gif"),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 40,
                    child: AutoSizeText(
                      element.name,
                      maxFontSize: 13,
                      minFontSize: 12,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
  else {
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10),
      height: 160,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: -1,
          direction: Axis.vertical,
          children: [1,2,3]
              .map(
                (element) => Container(
              // margin: EdgeInsets.symmetric(horizontal: 5),
              width: 130,
              height: 160,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffe3eaef),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(12, 12)
                        ),
                        BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                            color: Color(0xffffffff),
                            spreadRadius: 0.06,
                            blurRadius: 24,
                            offset: Offset(-12, -12)
                        ),
                      ],
                    ),
                    //child: Image(image: NetworkImage(element.img),fit: BoxFit.fill),
                    child: Image.asset("assets/icons/spinner100.gif" , fit: BoxFit.contain,)
                  ),
                ],
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
