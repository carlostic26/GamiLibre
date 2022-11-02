import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level1/level1.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level2/level2.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level3/level3.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level5/level5.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level6/level6.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level7/level7.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level8/level8.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level9/level9.dart';
import 'package:prueba/view/scores_screen.dart';

import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:soundpool/soundpool.dart';

import '../games/RazonamientoCuantitativo/level10/level10.dart';
import '../games/RazonamientoCuantitativo/level4/level4.dart';

//ESTAS CLASES CONTIENEN EL DIALOGO PERSONALIZADO QUE DA EL AVISO ANTES DE ENTRAR AL NIVEL
//SE DEBE TENER UNO A UNO SEGUN CADA NIVEL Y SEGUN CADA MODULO DEL ICFES

// es un archivo dart que contiene todas las clases de cada dialogo, porteriormente sera instanciado

class ShowDialoglevel1RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/quiztime_gif.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 1",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 65,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Comencemos con un quiz básico para revisar conocimientos 😎",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 17,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level1();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

Future<void> _soundGoLevel() async {
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  int soundId = await rootBundle
      .load("assets/soundFX/playlevel.wav")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });
  int streamId = await pool.play(soundId);
}

class ShowDialogLevel2RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/banners/gamicards.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 2",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "En ente nivel tendrás que leer muy bien cada enunciado dentro de las tarjetas para hacer match entre ellas. \n\nTienes 20 intentos.",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level2();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel3RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/quiztime_gif.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 3",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Segundo Gamiquiz. \n\nTendrás que resolver 5 preguntas tipo ICFES.\n\nRecuerda usar papel y lapiz si lo necesitas.",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level3();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel4RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/banners/gamiahorcado.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 4",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "En este nivel, deberás completar la palabra correcta de un enunciado. \n\n¡Solo tienes 10 intetos, trata de no equivocarte!",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level4();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel5RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/quiztime_gif.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 5",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Tercer Gamiquiz. \n\nTendrás que resolver 5 preguntas tipo ICFES.\n\nRecuerda usar papel y lapiz si lo necesitas.",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level5();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel6RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/banners/gamidrop.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 6",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "En ente nivel tendrás que arrastras y soltar el significado de cada concepto clave.",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level6();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel7RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/quiztime_gif.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 7",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Cuarto Gamiquiz. \n\nTendrás que resolver 5 preguntas tipo ICFES.\n\nRecuerda usar papel y lapiz si lo necesitas.",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level7();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel8RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/banners/gamicards.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 8",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "En ente nivel tendrás que leer muy bien cada enunciado dentro de las tarjetas para hacer match entre ellas.\n\n¡Sólo tienes 10 intentos!",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level8();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel9RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/quiztime_gif.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 9",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Quinto Gamiquiz. \n\nTendrás que resolver 5 preguntas tipo ICFES.\n\nRecuerda usar papel y lapiz si lo necesitas.",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level9();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel10RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 142,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/banners/gamiahorcado.gif'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 10",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "En este nivel, deberás completar la palabra correcta de un enunciado. \n\n¡Solo tienes 5 intentos, trata no equivocarte!",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/btn_ir_level.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                _soundGoLevel();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.elasticIn);

                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimattion) {
                          return const level10();
                        }));
              },
            ),
          ),
        ),

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}

class ShowDialogLevel11RC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 230,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/dialogo_level.png'),
                    fit: BoxFit.fill)),
          ),
        ),

        //Gif que muestra un demo del nivel antes de entrar
        Positioned(
          left: 8,
          bottom: 35,
          child: Container(
            width: 110,
            height: 140,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/originals/fa/8d/27/fa8d27ef9a9aa9027b1878603d7e1b39.gif"),
              fit: BoxFit.fill,
            )),
          ),
        ),

        Positioned(
          top: 18,
          child: Container(
            child: const Text(
              //titulo del nivel
              "NIVEL 11",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 30.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 55,
          child: Container(
            width: 148,
            height: 300,
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "En ente nivel tendrás que superar 10 oraciones en menos de 60 segundos!!. \n\nDebes conocer los siguientes temas para lograr con éxito este nivel:  Paradigmas, patrones, algoritmos",
                      style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 16,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        //Botón verde para pasar a la pantalla de juego correspondiente

        //Botón rojo para cancelar la vista de dialogo actual
        Positioned(
          top: -1,
          right: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/button_dismiss.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ]);
}
