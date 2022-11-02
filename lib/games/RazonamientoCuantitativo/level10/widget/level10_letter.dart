import 'package:flutter/material.dart';

Widget letter(String character, bool hidden) {
  return Container(
    height: 50,
    width: 25,
    padding: EdgeInsets.all(1.0),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 61, 13, 4), //color red dark
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Visibility(
      visible: !hidden,
      child: Center(
        child: Text(
          //color text pinted word
          character,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    ),
  );
}
