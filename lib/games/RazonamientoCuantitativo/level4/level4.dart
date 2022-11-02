import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/dialogs/dialog_helper.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level4/utils/game4.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level4/widget/level4_figure_image.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level4/widget/letter.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:soundpool/soundpool.dart';

/*NIVEL TIPO AHORCADO
  Este nivel consiste en hacer leer un enunciado y escribir cada letra de forma correcta
  El jugador deberá adivinar el concepto completo.

  El sistema validará la respuesta seleccionada pintando en pantalla cada parte del personaje.

*/

class level4 extends StatefulWidget {
  const level4({super.key});

  @override
  State<level4> createState() => _level4State();
}

class _level4State extends State<level4> {
  //El siguiente string, contendrá la palabra clave a ingresar en el juego
  String word = "VARIANZA".toUpperCase();

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
        child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Stack(
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
                                  return const razonamiento();
                                }));

                        _soundBack();
                      },
                    ),
                  )),

              //banner superior
              Positioned(
                top: -195,
                left: 90,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1.0),
                      width: 180,
                      height: 500,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/games/general/bannerGamiAhorcado.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 70, 20, 2),
                      child: Text(
                        'Medida de dispersión que representa la variabilidad de una serie de datos respecto a su media.',
                        style: TextStyle(fontSize: 20, fontFamily: 'ZCOOL'),
                      ),
                    ),
                  ),

                  Center(
                    child: Stack(
                      children: [
                        figureImage(
                            Game4.tries >= 0, "assets/games/level3/hang.png"),
                        figureImage(
                            Game4.tries >= 1, "assets/games/level3/head.png"),
                        figureImage(
                            Game4.tries >= 2, "assets/games/level3/body.png"),
                        figureImage(
                            Game4.tries >= 3, "assets/games/level3/ra.png"),
                        figureImage(
                            Game4.tries >= 4, "assets/games/level3/la.png"),
                        figureImage(
                            Game4.tries >= 5, "assets/games/level3/rl.png"),
                        figureImage(
                            Game4.tries >= 6, "assets/games/level3/ll.png"),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: word
                        .split('')
                        .map((e) => letter(e.toUpperCase(),
                            !Game4.selectedChar.contains(e.toUpperCase())))
                        .toList(),
                  ),

                  //building the Game keyboard
                  SizedBox(
                    width: double.infinity,
                    height: double.maxFinite,
                    child: GridView.count(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      padding: EdgeInsets.all(8.0),
                      children: alphabets.map((e) {
                        return RawMaterialButton(
                            onPressed: Game4.selectedChar.contains(e)
                                ? null // we first check that we didn't selected the button before
                                : () {
                                    setState(() {
                                      Game4.selectedChar.add(e);
                                      print(Game4.selectedChar);
                                      if (!word
                                          .split('')
                                          .contains(e.toUpperCase())) {
                                        Game4.tries++;
                                      }

                                      //si la palabra escrita está en las cajas entonces aumenta numero de exitos
                                      if (word
                                          .split('')
                                          .contains(e.toUpperCase())) {
                                        Game4.succes++;
                                      }

                                      //GAME OVER

                                      //si se tienen mas de 6 intentos fallidos
                                      if (Game4.tries >= 6) {
                                        //Opcional, enviar como parametro respuesta correcta y mostrar en ese dialogo
                                        DialogHelper.showDialogGameOver(
                                            context,
                                            0,
                                            'rc'); //gana 0 puntos si perdió el nivel || SCORE

                                        //GAMEOVER pas infO score to bd updating all ROW
                                        var handler = DatabaseHandler();
                                        handler.updateScore(scoregamilibre(
                                            id: 'RC4',
                                            modulo: 'RC',
                                            nivel: '4',
                                            score: 0.toString()));
                                      }

                                      // y si se logra el llenado de las letras minimas completas entonces
                                      if (Game4.succes >= 6) {
                                        //Opcional, enviar como parametro respuesta correcta y mostrar en ese dialogo
                                        DialogHelper.showDialogGameOver(
                                            context, Game4.succes, 'rc');

                                        // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
                                        var handler = DatabaseHandler();
                                        handler.updateScore(scoregamilibre(
                                            id: 'RC4',
                                            modulo: 'RC',
                                            nivel: '4',
                                            score: Game4.succes
                                                .toString())); //gana 5 puntos si alcanzó a completar || SCORE
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
                            fillColor: Game4.selectedChar.contains(e)
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
        ]),
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
