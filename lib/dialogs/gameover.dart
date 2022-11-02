import 'package:flutter/material.dart';
import 'package:prueba/view/scores_screen.dart';

//Este archivo dart contiene todas las clases tipo dialogo GAME OVER
class ShowDialogGameOver extends StatefulWidget {
  ShowDialogGameOver({required this.score, required this.puntoPartida});

  late int score;
  late String puntoPartida;

  @override
  State<ShowDialogGameOver> createState() => _ShowDialogGameOver();
}

class _ShowDialogGameOver extends State<ShowDialogGameOver> {
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
        //DIALOG RED
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

        //GIF LEFT DEMOSTRATION
        Positioned(
          left: 7,
          bottom: 35,
          child: Container(
            width: 110,
            height: 140,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: ExactAssetImage('assets/winner.gif'),
              fit: BoxFit.cover,
            )),
          ),
        ),

        Positioned(
          top: 22,
          child: Container(
            child: const Text(
              //titulo del nivel
              "🥳 Gaminivel Termidado 🕑",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 20.0),
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 70,
          child: Container(
            width: 150,
            height: 100,
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "Score en este nivel: ",
                          style: TextStyle(
                              fontFamily: 'ZCOOL',
                              fontSize: 18,
                              color: Colors.white)),
                    ],
                  ),
                ),

// se muestra el score en String
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n+" + widget.score.toString(),
                          style: const TextStyle(
                              fontFamily: 'ZCOOL',
                              fontSize: 50,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        //BUTTON MIS PUNTAJES
        Positioned(
          bottom: 10,
          child: Container(
            width: 120,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/buttons/btn_scores.png'),
                    fit: BoxFit.fill)),
            child: GestureDetector(
              onTapUp: (tap) {
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
                          return MyScore2(
                            puntoPartida: widget.puntoPartida,
                          );
                        }));
              },
            ),
          ),
        ),
      ]);
}
