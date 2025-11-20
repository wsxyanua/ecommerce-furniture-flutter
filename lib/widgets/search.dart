import '../screens/search.dart';
import 'package:flutter/material.dart';

Widget searchField(BuildContext context) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Search()));
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 1),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.03),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child:const Text('Search . . .' , style: TextStyle(
                color: Colors.grey,
              ),),
            ),
            //const SizedBox(width: 5,),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: const Color(0xff80221e),
                borderRadius: BorderRadius.circular(15),
                // shape: BoxShape.circle
              ),
              child: const Center(child: Icon(Icons.search_rounded)),
            ),
          ],
        ),
      ),
    ),
  );
}
