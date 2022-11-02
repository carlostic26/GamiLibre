import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    //recibe el sharedPreferences como instancias necesarias para leer al momento de abrir la app
    prefs = await SharedPreferences.getInstance();
  }
}
