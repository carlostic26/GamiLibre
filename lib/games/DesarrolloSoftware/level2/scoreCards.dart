import 'package:flutter/material.dart';

Widget scoreBoard1(String title, String info) {
  //retorna un expanded como forma responsiva de visualizar el widget segun la pantalla
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(26.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22.0,
              fontFamily: 'ZCOOL',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            info,
            style: const TextStyle(
                fontFamily: 'ZCOOL',
                fontSize: 34.0,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
