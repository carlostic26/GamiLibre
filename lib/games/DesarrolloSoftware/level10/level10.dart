import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/dialogs/dialog_helper.dart';

import 'package:prueba/games/DesarrolloSoftware/level10/utils/game10.dart';
import 'package:prueba/games/DesarrolloSoftware/level10/widget/level10_figure_image.dart';
import 'package:prueba/games/DesarrolloSoftware/level10/widget/letter.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/desarrollo_software.dart';
import 'package:soundpool/soundpool.dart';

/*NIVEL TIPO AHORCADO
  Este nivel consiste en hacer leer un enunciado y escribir cada letra de forma correcta
  El jugador deberá adivinar el concepto completo.

  El sistema validará la respuesta seleccionada pintando en pantalla cada parte del personaje.

*/

class level10 extends StatefulWidget {
  const level10({super.key});

  @override
  State<level10> createState() => _level10State();
}

class _level10State extends State<level10> {
  //choosing the game word
  String word = "PROTOTIPOS".toUpperCase();

  //medida de dispersión que representa la variabilidad de una serie de datos respecto a su media.
  // VARIANZA

  //pérdida del valor de los activos o pasivos con el paso del tiempo.
  //AMORTIZACIÓN

  //Se define como el precio del dinero en el tiempo
  //INTERÉS

  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "Ñ",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  bool gameover = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gameover = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 233, 230),
      body: SizedBox(
        //dimension de ancho y alto de pantalla candy crush
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //flecha atras
            Positioned(
                top: 20,
                left: -10,
                child: ShakeWidgetX(
                  child: IconButton(
                    icon: Image.asset('assets/flecha_left.png'),
                    iconSize: 50,
                    onPressed: () {
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
                                    curve: Curves.elasticOut);

                                return ScaleTransition(
                                  alignment: Alignment.center,
                                  scale: animation,
                                  child: child,
                                );
                              },
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimattion) {
                                return const desarrollo();
                              }));

                      _soundBack();
                    },
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Positioned(
                  top: 25,
                  left: -10,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 2),
                    child: Text(
                      'Cuando un cliente define un conjunto de objetivos generales para el desarrollo de software, pero no logra identificar los requisitos de entrada, procesamiento o salida detalladamente, el mejor proceso de desarrollo de software para este caso es el modelo de',
                      style: TextStyle(fontSize: 18, fontFamily: 'ZCOOL'),
                    ),
                  ),
                ),

                Center(
                  child: Stack(
                    children: [
                      figureImage(
                          Game10.tries >= 0, "assets/games/level3/hang.png"),
                      figureImage(
                          Game10.tries >= 1, "assets/games/level3/head.png"),
                      figureImage(
                          Game10.tries >= 2, "assets/games/level3/body.png"),
                      figureImage(
                          Game10.tries >= 3, "assets/games/level3/ra.png"),
                      figureImage(
                          Game10.tries >= 4, "assets/games/level3/la.png"),
                      figureImage(
                          Game10.tries >= 5, "assets/games/level3/rl.png"),
                      figureImage(
                          Game10.tries >= 6, "assets/games/level3/ll.png"),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: word
                      .split('')
                      .map((e) => letter(e.toUpperCase(),
                          !Game10.selectedChar.contains(e.toUpperCase())))
                      .toList(),
                ),

                //building the Game keyboard
                SizedBox(
                  width: double.infinity,
                  height: 250.0,
                  child: GridView.count(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    padding: EdgeInsets.all(8.0),
                    children: alphabets.map((e) {
                      return RawMaterialButton(
                          onPressed: Game10.selectedChar.contains(e)
                              ? null // we first check that we didn't selected the button before
                              : () {
                                  setState(() {
                                    Game10.selectedChar.add(e);
                                    print(Game10.selectedChar);
                                    if (!word
                                        .split('')
                                        .contains(e.toUpperCase())) {
                                      Game10.tries++;
                                    }

                                    //si la palabra escrita está en las cajas entonces aumenta numero de exitos
                                    if (word
                                        .split('')
                                        .contains(e.toUpperCase())) {
                                      Game10.succes++;
                                    }

                                    //GAME OVER

                                    //si se tienen mas de 6 intentos fallidos
                                    if (Game10.tries >= 2) {
                                      //Opcional, enviar como parametro respuesta correcta y mostrar en ese dialogo
                                      DialogHelper.showDialogGameOver(
                                          context,
                                          0,
                                          'ds'); //gana 0 puntos si perdió el nivel || SCORE

                                      // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
                                      var handler = DatabaseHandler();
                                      handler.updateScore(scoregamilibre(
                                          id: 'DS10',
                                          modulo: 'DS',
                                          nivel: '10',
                                          score: 0.toString()));
                                    }

                                    // y si se logra el llenado de las letras minimas completas entonces
                                    if (Game10.succes >= 9) {
                                      //Opcional, enviar como parametro respuesta correcta y mostrar en ese dialogo
                                      DialogHelper.showDialogGameOver(
                                          context,
                                          Game10.succes,
                                          'ds'); //gana 5 puntos si alcanzó a completar || SCORE

                                      // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
                                      var handler = DatabaseHandler();
                                      handler.updateScore(scoregamilibre(
                                          id: 'DS10',
                                          modulo: 'DS',
                                          nivel: '10',
                                          score: Game10.succes.toString()));
                                    }
                                  });
                                },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            e,
                            style: const TextStyle(
                              //COLOR TEXT BOARD
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          fillColor: Game10.selectedChar.contains(e)
                              ? const Color.fromARGB(
                                  255, 61, 13, 4) //color red dark
                              : const Color.fromARGB(
                                  255, 199, 55, 30)); //color red normal
                    }).toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
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
