import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/dialogs/dialog_helper.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level8/level8_logic.dart';
import 'package:prueba/games/RazonamientoCuantitativo/level8/level8_scoreCards.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:soundpool/soundpool.dart';

class level8 extends StatefulWidget {
  const level8({Key? key}) : super(key: key);

  @override
  State<level8> createState() => _level8State();
}

/*NIVEL TIPO GAMICARD
  Este nivel consiste en hacer coincidir dos tarjetas iguales
  El jugador deberá seleccionar las tarjetas disponibles

  El sistema validará la respuesta seleccionada a traves de puntajes. Existe un límite de intetos.

*/
class _level8State extends State<level8> {
  final GameCards _gameCards = GameCards();
  double tries = 0;
  int valTries = 0;
  int score = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gameCards.initGame();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/fondo_ladrillos_oscuro.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
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
                      },
                    ),
                  )),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  const Center(
                    child: Text(
                      "MemoryCards",
                      style: TextStyle(
                        fontSize: 48.0,
                        fontFamily: 'ZCOOL',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      scoreBoard1("Intentos", "${tries.toInt()}"),
                      scoreBoard1("Score", "${score}")
                    ],
                  ),
                  SizedBox(
                    height: 500,
                    width: screen_width,
                    child: GridView.builder(
                        itemCount: _gameCards.gameImg!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                print(_gameCards.cards_list[index]);

                                setState(() {
                                  //casteando el valor de cada intento a solo 1 punto por cada 2 movimientos
                                  valTries++;
                                  tries = (valTries / 2);

                                  _gameCards.gameImg![index] =
                                      _gameCards.cards_list[index];
                                  _gameCards.matchCheck.add(
                                      {index: _gameCards.cards_list[index]});
                                });
                                if (_gameCards.matchCheck.length == 2) {
                                  if (_gameCards.matchCheck[0].values.first ==
                                      _gameCards.matchCheck[1].values.first) {
                                    print("true");
                                    score += 1;
                                    _gameCards.matchCheck.clear();

                                    //si el usuario completa los 6 matches se muestra dialogo de game over
                                    if (score >= 6) {
                                      //enviamos score al DialogHelper que conecta a la clase ShowDialogGameOver1
                                      DialogHelper.showDialogGameOver(
                                          context, score, 'rc');

                                      // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
                                      var handler = DatabaseHandler();
                                      handler.updateScore(scoregamilibre(
                                          id: 'RC8',
                                          modulo: 'RC',
                                          nivel: '8',
                                          score: score.toString()));
                                    }
                                  } else {
                                    //si el usuario hace mas de 20 intentos, gameover
                                    if (tries >= 20) {
                                      //enviamos score al DialogHelper que conecta a la clase ShowDialogGameOver1
                                      DialogHelper.showDialogGameOver(
                                          context, score, 'rc');
                                      // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
                                      var handler = DatabaseHandler();
                                      handler.updateScore(scoregamilibre(
                                          id: 'RC8',
                                          modulo: 'RC',
                                          nivel: '8',
                                          score: score.toString()));
                                    }
                                    print(false);
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      print(_gameCards.gameImg);
                                      setState(() {
                                        _gameCards.gameImg![_gameCards
                                            .matchCheck[0]
                                            .keys
                                            .first] = _gameCards.hiddenCardpath;
                                        _gameCards.gameImg![_gameCards
                                            .matchCheck[1]
                                            .keys
                                            .first] = _gameCards.hiddenCardpath;
                                        _gameCards.matchCheck.clear();
                                      });
                                    });
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFB46A),
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            _gameCards.gameImg![index]),
                                        fit: BoxFit.cover)),
                              ));
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
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
