import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:soundpool/soundpool.dart';

class level7 extends StatefulWidget {
  const level7({Key? key}) : super(key: key);

  @override
  State<level7> createState() => _level7State();
}

/*NIVEL TIPO QUIZ 
  Este nivel consiste en desplegar diferentes tipos de preguntas
  El jugador deberá seleccionar una de las opciones.

  El sistema validará la respuesta seleccionada a traves de un aviso sobre la respuesta.

*/
class _level7State extends State<level7> {
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
                " #4",
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
                            return const razonamiento();
                          }));

                  _soundBack();
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

        const SizedBox(height: 20),
        // espacio para imagen scroll vire
        SizedBox(
          height: 120,
          width: 330,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Image.network(
                question.img,
                //fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          width: 330,
          child: SingleChildScrollView(
            child: Text(
              //TEXTO QUE CONTIENE LA PREGUNTA COMPLETA
              question.text,
              style: const TextStyle(
                  color: Color.fromARGB(255, 61, 13, 4),
                  fontFamily: 'ZCOOL',
                  fontSize: 18.0),
            ),
          ),
        ),
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

          // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
          var handler = DatabaseHandler();
          handler.updateScore(scoregamilibre(
              id: 'RC7', modulo: 'RC', nivel: '7', score: _score.toString()));
        }
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
        height: 65, //altura de las tarjetas de cada opcion
        padding: const EdgeInsets.fromLTRB(2, 1, 1, 1),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          //color of cards options
          color: const Color.fromARGB(255, 189, 40, 13), //189, 40, 13
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  option.text,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'ZCOOL', fontSize: 17.0),
                ),
              ),
              getIconForOption(option, question)
            ],
          ),
        ),
      ),
    );
  }

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
  late String img = "";
  late final String text;
  late final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.img,
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
  Question(
      img:
          ("https://c.pxhere.com/photos/bd/b5/kids_jumping_jump_shot_students_fun_joy_jump_happiness-1164289.jpg!d"),
      text:
          "En cierto país, una persona es considerada joven si su edad es menor o igual a 30 años. De acuerdo con el diagrama, ¿es correcto afirmar que la mayoría de la población de ese país es joven?",
      options: [
        const Option(
            text:
                'Sí, porque las personas de 30 años pertenecen a la porción más grande. ',
            isCorrect: false),
        const Option(
            text:
                'No, porque se desconoce la proporción de personas entre 31 y 35 años. ',
            isCorrect: true),
        const Option(
            text:
                'Sí, porque las personas jóvenes corresponden al 65% de la población. ',
            isCorrect: false),
        const Option(
            text:
                'No, porque todas las porciones del diagrama son menores al 50%.',
            isCorrect: false)
      ]),

  //Pregunta 2
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/3.png"),
      text:
          "Un sistema de transporte urbano en una ciudad de Colombia utiliza dos tipos de buses. El sistema de trasporte cuenta con un total de 75 buses tipo I y 60 tipo II. La expresión que permite determinar la capacidad máxima de pasajeros que pueden transportar la totalidad de buses es ",
      options: [
        const Option(text: '150', isCorrect: false),
        const Option(text: '120', isCorrect: false),
        const Option(text: '108', isCorrect: false),
        const Option(text: '96', isCorrect: true)
      ]),

  //Pregunta 3
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/4.png"),
      text:
          "El subsidio familiar de vivienda (SFV) es un aporte que entrega el Estado y que constituye un complemento del ahorro, para facilitarle la adquisición, construcción o mejoramiento de una solución de vivienda de interés social al ciudadano. \nEn la imagen superior, se presenta la tabla de ingresos en salarios mínimos mensuales legales vigentes (SMMLV) y el subsidio al que tiene derecho, para cierto año. Con el SFV más los ahorros con los que cuente el grupo familiar y el crédito que obtenga de una entidad financiera, se puede comprar la vivienda. \nPor tanto, para estimar el valor del crédito que debe solicitarse al banco se debe calcular así: ",
      options: [
        const Option(
            text:
                'Valor del crédito = ingresos + ahorros + subsidio + valor de la Vivienda. ',
            isCorrect: false),
        const Option(
            text:
                'Valor del crédito = valor de la vivienda – ahorros – subsidio. ',
            isCorrect: true),
        const Option(
            text:
                'Valor del crédito = ingresos + ahorros – subsidio + valor de la Vivienda. ',
            isCorrect: false),
        const Option(
            text:
                'Valor del crédito = valor de la vivienda + subsidio – ahorros',
            isCorrect: false)
      ]),

  //Pregunta 4
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/5.png"),
      text:
          'Una persona que observa la información de la tabla anterior, elabora la gráfica presentada. \nLa gráfica tiene una inconsistencia porque',
      options: [
        const Option(
            text:
                'los ingresos y el subsidio correspondientes se dan en miles de pesos, y no en SMMLV',
            isCorrect: false),
        const Option(
            text:
                'la correspondencia entre ingresos y subsidios es inversa, pero no disminuye de manera constante y continua.',
            isCorrect: true),
        const Option(
            text:
                'faltan algunos valores de los subsidios presentados en la tabla.',
            isCorrect: false),
        const Option(
            text:
                'los valores del subsidio deben ser ascendentes, pues a menores ingresos, mayor es el subsidio.',
            isCorrect: false)
      ]),

  //Pregunta 5
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/4.png"),
      text:
          "Una familia con ingresos entre 0 y 1 SMMLV recibe un subsidio equivalente a ",
      options: [
        const Option(
            text:
                '1,4 veces el subsidio de una familia de ingresos entre 2 y 2,25 SMMLV.',
            isCorrect: false),
        const Option(
            text:
                '1,8 veces el subsidio de una familia de ingresos entre 2,5 y 2,75 SMMLV.',
            isCorrect: false),
        const Option(
            text:
                '3,5 veces el subsidio de una familia de ingresos entre 3 y 3,5 SMMLV.',
            isCorrect: false),
        const Option(
            text:
                '5,5 veces el subsidio de una familia de ingresos entre 3,5 y 4 SMMLV.',
            isCorrect: true)
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
                                  puntoPartida: 'rc',
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
