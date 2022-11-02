import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/desarrollo_software.dart';
import 'package:soundpool/soundpool.dart';

import '../../../model/score.dart';

/*NIVEL TIPO QUIZ 
  Este nivel consiste en desplegar diferentes tipos de preguntas
  El jugador deberá seleccionar una de las opciones.

  El sistema validará la respuesta seleccionada a traves de un aviso sobre la respuesta.

*/

class level1 extends StatefulWidget {
  const level1({Key? key}) : super(key: key);

  @override
  State<level1> createState() => _level1State();
}

class _level1State extends State<level1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 233, 230), //61, 13, 4
      body: Stack(alignment: Alignment.center, children: <Widget>[
        //banner superior
        Positioned(
          top: -195,
          left: 90,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1.0),
                width: 150,
                height: 500,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/games/general/bannerGamerQuiz_dark.png"),
                  ),
                ),
              ),
              const Text(
                " #1",
                style: TextStyle(
                    color: Color.fromARGB(255, 61, 13, 4),
                    fontFamily: 'ZCOOL',
                    fontSize: 25.0),
              ),
            ],
          ),
        ),

        //flecha atras
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
                                parent: animation, curve: Curves.elasticOut);

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
                },
              ),
            )),

        const QuestionWidget(),
      ]),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

//clase que retorna la pregunta en pantalla
class _QuestionWidgetState extends State<QuestionWidget> {
  late PageController _controller;
  int _questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 70),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Text(
            //TEXTO QUE CONTIENE EL PONDERADO  DE PREGUNTAS
            'Pregunta $_questionNumber/${questions.length}',
            style: const TextStyle(
                color: Colors.black, fontFamily: 'ZCOOL', fontSize: 15.0),
          ),
          //Se imprime el pageView que contiene pregunta y opciones
          Expanded(
              child: PageView.builder(
            itemCount: questions.length,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final _question = questions[index];
              return buildQuestion(_question);
            },
          )),
          _isLocked ? buildElevatedButton() : const SizedBox.shrink(),
          const SizedBox(height: 20),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //altura del cuerpo que contiene pregunta y respuestas
        const SizedBox(height: 30),

        Text(
          //TEXTO QUE CONTIENE LA PREGUNTA COMPLETA
          question.text,
          style: const TextStyle(
              color: Color.fromARGB(255, 61, 13, 4),
              fontFamily: 'ZCOOL',
              fontSize: 27.0),
        ),
        const SizedBox(height: 15),
        Expanded(
            child: OptionsWidget(
          question: question,
          onClickedOption: (option) {
            if (question.isLocked) {
              return;
            } else {
              setState(() {
                question.isLocked = true;
                question.selectedOption = option;
              });
              _isLocked = question.isLocked;
              if (question.selectedOption!.isCorrect) {
                _score++;
              }
            }
          },
        ))
      ],
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        if (_questionNumber < questions.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _questionNumber++;
            _isLocked = false;
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(score: _score),
            ),
          );
        }

        // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
        var handler = DatabaseHandler();
        handler.updateScore(scoregamilibre(
            id: 'DS1', modulo: 'DS', nivel: '1', score: _score.toString()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 61, 13, 4), // Background color
        minimumSize: Size(100, 40),
      ),
      child: Text(
        _questionNumber < questions.length ? 'Siguiente' : 'Revisar resultado',
        style:
            TextStyle(color: Colors.white, fontFamily: 'ZCOOL', fontSize: 25.0),
      ),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    Key? key,
    required this.question,
    required this.onClickedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: question.options
              .map((option) => buildOption(context, option))
              .toList(),
        ),
      );

  //devuelve graficamente las opciones de respuestas en pantalla
  @override
  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        height: 80, //altura de las tarjetas de cada opcion
        padding: const EdgeInsets.fromLTRB(3, 1, 1, 1),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          //color of cards options
          color: const Color.fromARGB(255, 189, 40, 13), //189, 40, 13
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  option.text,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'ZCOOL', fontSize: 16.0),
                ),
              ),
              getIconForOption(option, question)
            ],
          ),
        ),
      ),
    );
  }

//Método que devuelve un color como forma de validación de respuesta por el usuario
  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;

    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }

    return Colors.grey.shade300;
  }

  Widget getIconForOption(Option option, Question question) {
    final isSelect = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelect) {
        return option.isCorrect
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.yellow);
      } else if (option.isCorrect) {
        return const Icon(Icons.check_circle, color: Colors.green);
      }
    }
    return const SizedBox.shrink();
  }
}

class Question {
  late final String text;
  late final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.text,
    required this.options,
    this.isLocked = false,
    this.selectedOption,
  });
}

class Option {
  final String text;
  final bool isCorrect;

  const Option({
    required this.text,
    required this.isCorrect,
  });
}

final questions = [
  //para preguntas con imagen se puede usar la clase Question
  // para preguntas sin imagen, se puede usar otra clase comno QuestionNoIMG

  //Pregunta 1
  Question(text: "1. ¿Qué es el Diseño de Software? ", options: [
    const Option(
        text: 'A. Es el diseño que se le dan a los programas informáticos',
        isCorrect: false),
    const Option(
        text:
            'B. Es el conjunto de actividades TIC dedicadas al proceso de creación, despliegue y compatibilidad de software.',
        isCorrect: false),
    const Option(
        text:
            'C. Es la planificación de una solución de software, necesario para para disminuir el riesgo de desarrollos erróneos.',
        isCorrect: true),
    const Option(
        text:
            'D. Son el conjunto de actividades de software dedicadas al proceso de creación, diseño, despliegue y compatibilidad electrónica',
        isCorrect: false)
  ]),

  //Pregunta 2
  Question(
      text:
          "2. Cuantas preguntas contiene la prueba de Desarrollo de Software del ICFES Saber PRO? ",
      options: [
        const Option(text: 'A. 25', isCorrect: false),
        const Option(text: 'B. 30', isCorrect: true),
        const Option(text: 'C. 35', isCorrect: false),
        const Option(text: 'D. 40', isCorrect: false)
      ]),

  //Pregunta 3
  Question(
      text:
          "3. Cuál es la estructura de evaluación del modulo(Tomado de la guia de orientacion de modulo de razonamiento cuantitativo saber pro 2016)",
      options: [
        const Option(
            text: 'A. Competencia, afirmación , evidencia ', isCorrect: true),
        const Option(
            text:
                'B. Análisis y comprensión, formulación y representación, interpretación y argumentación',
            isCorrect: false),
        const Option(
            text:
                'C. Investigación y ejecución, interpretación y formulación, argumentación',
            isCorrect: false),
        const Option(text: 'D. Todas las anteriores', isCorrect: false)
      ]),

  //Pregunta 4
  Question(
      text:
          '4. Los módulos específicos, como Diseño de Software, están dirigidos a ',
      options: [
        const Option(
            text:
                'A. Estudiantes que hayan aprobado por lo menos el 75 % de los créditos académicos del programa profesional universitario que cursan',
            isCorrect: false),
        const Option(
            text:
                'B. Quienes presentan el examen por primera vez y que sean inscritos directamente por su IES.',
            isCorrect: false),
        const Option(
            text: 'C. Cualquier persona que desee obtenerlos',
            isCorrect: false),
        const Option(text: 'D. A y B son ciertas', isCorrect: true)
      ]),

  //Pregunta 5
  Question(
      text: "5. El módulo Diseño de Software se oferta a los programas de ",
      options: [
        const Option(
            text: 'A. Ingeniería de sistemas, telemática y afines.',
            isCorrect: true),
        const Option(text: 'B. Ingeniería mecánica y afines', isCorrect: false),
        const Option(text: 'C. Ingeniería de alimentos', isCorrect: false),
        const Option(text: 'D. Derecho y arquitectura', isCorrect: false)
      ]),
];

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.score}) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //CONTAINER DEL FONDO QUE CONTIENE IMAGEN DE FONDO LADRILLOS
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondo_ladrillos_oscuro.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(alignment: Alignment.center, children: <Widget>[
            Center(
              child: Text(
                'Obtuviste $score/${questions.length}\n\nScore + $score',
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'ZCOOL', fontSize: 35.0),
              ),
            ),

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
                                return MyScore2(
                                  puntoPartida: 'ds',
                                );
                              }));
                      _soundBack();
                    },
                  ),
                )),
          ]),
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
