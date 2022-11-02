// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/dialogs/dialog_helper.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/user_model.dart';
import 'package:prueba/view/home_screen.dart';
import 'package:prueba/services/local_storage.dart';

import 'package:soundpool/soundpool.dart';

// ignore: camel_case_types
class desarrollo extends StatefulWidget {
  const desarrollo({Key? key}) : super(key: key);

  @override
  State<desarrollo> createState() => _desarrolloState();
}

// ignore: camel_case_types
class _desarrolloState extends State<desarrollo> {
  late DatabaseHandler handler;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String urlImagen = '';
  String carrera = '';
  String nombre = '';

//Se inicializa cada botón que contendrá el menu principal del modulo actual
  late Image button1,
      button2,
      button3,
      button4,
      button5,
      button6,
      button7,
      button8,
      button9,
      button10;
  late Image button11;

  Image button1DSPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button1DSUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button2DSPressed = Image.asset(
    'assets/buttons/button_2_pushed.png',
  );
  Image button2DSUnpressed = Image.asset(
    'assets/buttons/button_2_unpushed.png',
  );

  Image button3DSPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button3DSUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button4DSPressed = Image.asset(
    'assets/buttons/button_4_pushed.png',
  );
  Image button4DSUnpressed = Image.asset(
    'assets/buttons/button_4_unpushed.png',
  );

  Image button5DSPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button5DSUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button6DSPressed = Image.asset(
    'assets/buttons/button_3_pushed.png',
  );
  Image button6DSUnpressed = Image.asset(
    'assets/buttons/button_3_unpushed.png',
  );

  Image button7DSPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button7DSUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button8DSPressed = Image.asset(
    'assets/buttons/button_2_pushed.png',
  );
  Image button8DSUnpressed = Image.asset(
    'assets/buttons/button_2_unpushed.png',
  );

  Image button9DSPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button9DSUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button10DSPressed = Image.asset(
    'assets/buttons/button_4_pushed.png',
  );
  Image button10DSUnpressed = Image.asset(
    'assets/buttons/button_4_unpushed.png',
  );

  @override
  void initState() {
    handler = DatabaseHandler();

    button1 = button1DSUnpressed;
    button2 = button2DSUnpressed;
    button3 = button3DSUnpressed;
    button4 = button4DSUnpressed;
    button5 = button5DSUnpressed;
    button6 = button6DSUnpressed;
    button7 = button7DSUnpressed;
    button8 = button8DSUnpressed;
    button9 = button9DSUnpressed;
    button10 = button10DSUnpressed;

    //si es la primera vez que el usuario entra
    if (LocalStorage.prefs.getBool('firstLog') == true) {
      if (LocalStorage.prefs.getString('url') != '') {
        print("Si contiene url----------------------------------------------");
        var url = LocalStorage.prefs.getString('url')?.length ??
            'http://gamilibre.com/imagenes/user.png';
        urlImagen = url.toString();

        //aqui se debe enviar a shared preferences que el booleano de firstlogin = false
        LocalStorage.prefs.setBool("firstLog", false);
      } else {
        print("NO CONTIENE URL -----------------------------------");
        urlImagen = "http://gamilibre.com/imagenes/user.png";
      }
    } else {
      //si el usuario ya entro por 2 o mas veces a la app
      if (LocalStorage.prefs.getString('url') != null) {
        print(
            "Si contiene avatar----------------------------------------------");

        var test = LocalStorage.prefs.getString('url');

        urlImagen = test.toString();
      } else {
        print("NO CONTIENE AVATAR ----------------------------");
        urlImagen = 'http://gamilibre.com/imagenes/user.png';
      }
    }

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        //dimension de ancho y alto de pantalla candy crush
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          //CONTAINER DEL FONDO QUE CONTIENE IMAGEN DE FONDO LADRILLOS
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo_ladrillos.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
          ),

          //IMAGE LEVELS BACKGROUND
          Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/esc1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              )),

          //name modulo
          const Positioned(
              top: 30,
              child: Text(
                "Diseño de Sotfware",
                style: TextStyle(
                    fontFamily: 'ZCOOL',
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              )),

          //banner superior
          Positioned(
              top: -280,
              child: ShakeWidgetY(
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(1.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/banners/banner_user.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 374,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(1, 50, 1, 1),
                      width: 58,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(urlImagen.toString()),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    child: Column(
                      children: [
                        Text(
                          loggedInUser.fullName.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'ZCOOL',
                              fontSize: 14),
                        ),
                        Text(
                          loggedInUser.carrera.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'ZCOOL',
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 40,
                    child: Column(
                      children: [
                        const Text(
                          "Puntaje acumulado",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'ZCOOL',
                              fontSize: 13),
                        ),
                        //SizedBox(height: 5),
                        Text(
                          loggedInUser.sumScoreDS.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'ZCOOL',
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              )),

          //btn regresar
          Positioned(
              top: 20,
              left: -10,
              child: ShakeWidgetX(
                child: IconButton(
                  icon: Image.asset('assets/flecha_left.png'),
                  iconSize: 50,
                  onPressed: () {
                    _soundBack();
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: const Duration(seconds: 1),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              animation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.elasticInOut);

                              return ScaleTransition(
                                alignment: Alignment.center,
                                scale: animation,
                                child: child,
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimattion) {
                              return const HomeScreen();
                            }));
                  },
                ),
              )),

/*               //btn final 11
              Positioned(
                top: 140,
                right: 120,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    child: button11,
                    onTapDown: (tap) {
                      
                      _soundbutton();
                      setState(() {
                        // when it is pressed
                        button11 = button11Pressed;
                      });
                    },
                    onTapUp: (tap) {
                      setState(() {
                        // when it is released
                        button11 = button11Unpressed;
                      });

                      DialogHelper.showDialoglevel11DS(context);
                    },
                  ),
                ),
              ),
 */
          //btn 10
          Positioned(
            top: 150,
            right: 132,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 54,
              height: 54,
              child: GestureDetector(
                child: button10, //color of button
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button10 = button10DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button10 = button10DSUnpressed;
                  });

                  DialogHelper.showDialoglevel10DS(context);
                },
              ),
            ),
          ),

          //btn 9
          Positioned(
            top: 200,
            left: 65,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 59,
              height: 59,
              child: GestureDetector(
                child: button9, //color of button
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button9 = button9DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button9 = button9DSUnpressed;
                  });

                  DialogHelper.showDialogLevel9DS(context);
                },
              ),
            ),
          ),

          //btn 8
          Positioned(
            top: 260,
            left: 150,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 62,
              height: 62,
              child: GestureDetector(
                child: button8, //color of button
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button8 = button8DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button8 = button8DSUnpressed;
                  });

                  DialogHelper.showDialogLevel8DS(context);
                },
              ),
            ),
          ),

          //btn 7
          Positioned(
            top: 310,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 65,
              height: 65,
              child: GestureDetector(
                child: button7, //color of button
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button7 = button7DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button7 = button7DSUnpressed;
                  });

                  DialogHelper.showDialogLevel7DS(context);
                },
              ),
            ),
          ),

          //btn 6
          Positioned(
            top: 310,
            left: 120,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 68,
              height: 68,
              child: GestureDetector(
                child: button6, //color of button
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button6 = button6DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button6 = button6DSUnpressed;
                  });

                  DialogHelper.showDialogLevel6DS(context);
                },
              ),
            ),
          ),

          //btn 5
          Positioned(
            top: 360,
            left: 30,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 71,
              height: 71,
              child: GestureDetector(
                child: button5, //color of button
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button5 = button5DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button5 = button5DSUnpressed;
                  });

                  DialogHelper.showDialogLevel5DS(context);
                },
              ),
            ),
          ),

          //btn 4
          Positioned(
            bottom: 300,
            right: 150,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 74,
              height: 74,
              child: GestureDetector(
                child: button4,
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button4 = button4DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button4 = button4DSUnpressed;
                  });

                  DialogHelper.showDialogLevel4DS(context);
                },
              ),
            ),
          ),

          //btn 3
          Positioned(
            bottom: 240,
            right: 40,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 77,
              height: 77,
              child: GestureDetector(
                child: button3,
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button3 = button3DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button3 = button3DSUnpressed;
                  });
                  DialogHelper.showDialogLevel3DS(context);
                },
              ),
            ),
          ),

          //btn 2
          Positioned(
            bottom: 120,
            right: 50,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 90,
              height: 90,
              child: GestureDetector(
                child: button2,
                onTapDown: (tap) {
                  _soundbutton();
                  setState(() {
                    // when it is pressed
                    button2 = button2DSPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button2 = button2DSUnpressed;
                  });

                  DialogHelper.showDialogLevel2DS(context);
                },
              ),
            ),
          ),

          //btn inicial 1
          Positioned(
            bottom: 10,
            right: 120,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 150,
              height: 150,
              child: GestureDetector(
                child: button1,
                onTapDown: (tap) {
                  setState(() {
                    // when it is pressed
                    button1 = button1DSPressed;
                  });
                },
                onTapUp: (tap) {
                  _soundbutton();

                  setState(() {
                    // when it is released
                    button1 = button1DSUnpressed;
                  });

                  DialogHelper.showDialoglevel1DS(context);
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  bool btn1Pressed = false;

  // ignore: non_constant_identifier_names
  void ChangedImageFunction() {
    Image.asset("assets/button_2_pushed.png");

    setState(() {
      btn1Pressed = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      Image.asset("assets/button_1_unpushed.png");
    });
  }

  Future<void> _soundbutton() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle
        .load("assets/soundFX/button.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  Future<void> _soundBack() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle
        .load("assets/soundFX/buttonBack.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }
}
