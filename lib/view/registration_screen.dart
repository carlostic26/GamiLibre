import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba/model/user_model.dart';
import 'package:prueba/view/home_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:prueba/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final fullNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  String? selectedCarrera;
  String? nombre;
  List<String> items_carreras = [
    'Ingeniería en TIC',
    'Ingeniería Industrial',
  ];

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("El nombre no puede estar vació");
          }
          if (!regex.hasMatch(value)) {
            return ("Tu nommbre debe ser de al menos 3 caracteres");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;

          setState(() {
            nombre = value as String;
          });
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre Completo",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Ingresa tu correo");
          }
          // reg expression for email validation
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return ("Ingresa un correo válido");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Correo institucional",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Se necesita una contraseña");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingresa una contraseña de al menos 6 caracteres");
          }
          return null;
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contraseña",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Opps! Las contraseñas no son iguales";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirmar contraseña",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text(
          "Registrarse",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final dropdownCarreras = DropdownButtonHideUnderline(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton2(
            isExpanded: true,
            hint: Text(
              'Seleccionar carrera',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: items_carreras
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedCarrera,
            onChanged: (value) {
              setState(() {
                selectedCarrera = value as String;
              });
            },
            buttonHeight: 50,
            buttonWidth: 200,
            itemHeight: 40,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 233, 230),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 220,
                        child: Image.asset(
                          "assets/logo_login_v2.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 20),
                    fullNameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 15),
                    dropdownCarreras,
                    const SizedBox(height: 15),
                    signUpButton,
                    const SizedBox(height: 15),
                  ],
                )),
          ),
        )),
      ),
    );
  }

  bool firstLog = false;

  void signUp(String eemail, String ppassword) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: eemail, password: ppassword)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });

      firstLog = true;

      //Se carga a sharedpreferences el buleano que validará el primer ingreso
      LocalStorage.prefs.setBool("firstLog", firstLog);
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    LocalStorage.prefs.setBool("firstLog", firstLog);

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullNameEditingController.text;
    userModel.carrera = selectedCarrera.toString();
    userModel.sumScoreRC = '0';
    userModel.sumScoreDS = '0';

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Tu cuenta Gamilibre ha sido creada con éxito");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
