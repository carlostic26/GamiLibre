import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/dialogs/dialog_helper.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/model/user_model.dart';
import 'package:prueba/view/home_screen.dart';
import 'package:prueba/services/local_storage.dart';

import 'package:soundpool/soundpool.dart';

class razonamiento extends StatefulWidget {
  const razonamiento({Key? key}) : super(key: key);

  @override
  State<razonamiento> createState() => _razonamientoState();
}

class _razonamientoState extends State<razonamiento> {
  late DatabaseHandler handler;
  Future<List<scoregamilibre>>? _scoregamilibreRC;
  //String scoreTotal = "";

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String urlImagen = '';
  String carrera = '';
  String nombre = '';

  int sumScore = 0;

  late Image button1RC,
      button2RC,
      button3RC,
      button4RC,
      button5RC,
      button6RC,
      button7RC,
      button8RC,
      button9RC,
      button10RC;
  late Image button11RC;

  Image button1RCPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button1RCUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button2RCPressed = Image.asset(
    'assets/buttons/button_2_pushed.png',
  );
  Image button2RCUnpressed = Image.asset(
    'assets/buttons/button_2_unpushed.png',
  );

  Image button3RCPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button3RCUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button4RCPressed = Image.asset(
    'assets/buttons/button_4_pushed.png',
  );
  Image button4RCUnpressed = Image.asset(
    'assets/buttons/button_4_unpushed.png',
  );

  Image button5RCPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button5RCUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button6RCPressed = Image.asset(
    'assets/buttons/button_3_pushed.png',
  );
  Image button6RCUnpressed = Image.asset(
    'assets/buttons/button_3_unpushed.png',
  );

  Image button7RCPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button7RCUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button8RCPressed = Image.asset(
    'assets/buttons/button_2_pushed.png',
  );
  Image button8RCUnpressed = Image.asset(
    'assets/buttons/button_2_unpushed.png',
  );

  Image button9RCPressed = Image.asset(
    'assets/buttons/button_1_pushed.png',
  );
  Image button9RCUnpressed = Image.asset(
    'assets/buttons/button_1_unpushed.png',
  );

  Image button10RCPressed = Image.asset(
    'assets/buttons/button_4_pushed.png',
  );
  Image button10RCUnpressed = Image.asset(
    'assets/buttons/button_4_unpushed.png',
  );

  /*   Image button11RCPressed = Image.asset(
        'assets/buttons/button_2_pushed.png',
      );
      Image button11RCUnpressed = Image.asset(
        'assets/buttons/button_2_unpushed.png',
      ); */

  @override
  void initState() {
    handler = DatabaseHandler();

    handler.initializeDB().whenComplete(() async {
      setState(() {
        _scoregamilibreRC = getListRC();
      });
    });

    button1RC = button1RCUnpressed;
    button2RC = button2RCUnpressed;
    button3RC = button3RCUnpressed;
    button4RC = button4RCUnpressed;
    button5RC = button5RCUnpressed;
    button6RC = button6RCUnpressed;
    button7RC = button7RCUnpressed;
    button8RC = button8RCUnpressed;
    button9RC = button9RCUnpressed;
    button10RC = button10RCUnpressed;

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

//receiving carera
    if (LocalStorage.prefs.getString('carrera') != '') {
      print(
          "Si contiene carrera----------------------------------------------");
      var carrer =
          LocalStorage.prefs.getString('carrera')?.length ?? 'No Carrera';
      carrera = carrer.toString();
    } else {
      print("NO CONTIENE carrera -----------------------------------");
      carrera = 'No carrera';
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

  Future<List<scoregamilibre>> getListRC() async {
    return await handler.QueryAllScoresRC();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _scoregamilibreRC = getListRC();
    });
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
              top: 50,
              child: Text(
                "Razonamiento Cuantitativo",
                style: TextStyle(
                    fontFamily: 'ZCOOL',
                    color: Colors.white,
                    fontSize: 27,
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
                          Text(
                            loggedInUser.sumScoreRC.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'ZCOOL',
                              fontSize: 22,
                            ),
                          ),
                        ],
                      )),
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
                top: 120,
                right: 110,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  width: 100,
                  height: 100,
                  child: GestureDetector(
                    child: button11RC,
                    onTapDown: (tap) {
                      setState(() {
                        //sound fx
                        _buttonSound();
                        // when it is pressed
                        button11RC = button11RCPressed;
                      });
                    },
                    onTapUp: (tap) {
                      setState(() {
                        // when it is released
                        button11RC = button11RCUnpressed;
                      });

                      DialogHelper.showDialoglevel11RC(context);
                    },
                  ),
                ),
              ), */

          //btn 10
          Positioned(
            top: 150,
            right: 132,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 54,
              height: 54,
              child: GestureDetector(
                child: button10RC, //color of button
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button10RC = button10RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button10RC = button10RCUnpressed;
                  });

                  DialogHelper.showDialoglevel10RC(context);
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
                child: button9RC, //color of button
                onTapDown: (tap) {
                  setState(() {
                    //sound fx
                    _buttonSound();

                    // when it is pressed
                    button9RC = button9RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button9RC = button9RCUnpressed;
                  });

                  DialogHelper.showDialogLevel9RC(context);
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
                child: button8RC, //color of button
                onTapDown: (tap) {
                  setState(() {
                    //sound fx
                    _buttonSound();

                    // when it is pressed
                    button8RC = button8RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button8RC = button8RCUnpressed;
                  });

                  DialogHelper.showDialogLevel8RC(context);
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
                child: button7RC, //color of button
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button7RC = button7RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button7RC = button7RCUnpressed;
                  });

                  DialogHelper.showDialogLevel7RC(context);
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
                child: button6RC, //color of button
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button6RC = button6RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button6RC = button6RCUnpressed;
                  });

                  DialogHelper.showDialogLevel6RC(context);
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
                child: button5RC, //color of button
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button5RC = button5RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button5RC = button5RCUnpressed;
                  });

                  DialogHelper.showDialogLevel5RC(context);
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
                child: button4RC,
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button4RC = button4RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button4RC = button4RCUnpressed;
                  });

                  DialogHelper.showDialogLevel4RC(context);
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
                child: button3RC,
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button3RC = button3RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button3RC = button3RCUnpressed;
                  });

                  DialogHelper.showDialogLevel3RC(context);
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
                child: button2RC,
                onTapDown: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is pressed
                    button2RC = button2RCPressed;
                  });
                },
                onTapUp: (tap) {
                  setState(() {
                    // when it is released
                    button2RC = button2RCUnpressed;
                  });

                  DialogHelper.showDialogLevel2RC(context);
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
                child: button1RC,
                onTapDown: (tap) {
                  setState(() {
                    // when it is pressed
                    button1RC = button1RCPressed;
                  });
                },
                onTapUp: (tap) {
                  //sound fx
                  _buttonSound();

                  setState(() {
                    // when it is released
                    button1RC = button1RCUnpressed;
                  });

                  DialogHelper.showDialoglevel1RC(context);
                },
              ),
            ),
          ),

          //onImagePressed
        ]),
      ),
    );
  }

  bool btn1RCPressed = false;

  // ignore: non_constant_identifier_names
  void ChangedImageFunction() {
    Image.asset("assets/button_2_pushed.png");

    setState(() {
      btn1RCPressed = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      Image.asset("assets/button_1_unpushed.png");
    });
  }

  Future<void> _buttonSound() async {
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

  void scoreRefresh(int sumatoria) {
    setState(() {
      sumScore = sumatoria;
    });
  }
}
