import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:soundpool/soundpool.dart';

class level5 extends StatefulWidget {
  const level5({super.key});

  @override
  State<level5> createState() => _level5State();
}

/*NIVEL TIPO QUIZ 
  Este nivel consiste en desplegar diferentes tipos de preguntas
  El jugador deberá seleccionar una de las opciones.

  El sistema validará la respuesta seleccionada a traves de un aviso sobre la respuesta.

*/
class _level5State extends State<level5> {
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
                " #3",
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
                            return const razonamiento();
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
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          //TEXTO QUE CONTIENE LA PREGUNTA COMPLETA
          question.text,
          style: const TextStyle(
              color: Color.fromARGB(255, 61, 13, 4),
              fontFamily: 'ZCOOL',
              fontSize: 15.0),
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

          // Se carga la información de puntaje a la base de datos logrando actualizar todo el campo del registro de puntaje correspondiente al nivel
          var handler = DatabaseHandler();
          handler.updateScore(scoregamilibre(
              id: 'RC5', modulo: 'RC', nivel: '5', score: _score.toString()));
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
        height: 50, //altura de las tarjetas de cada opcion
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
          ("https://educacion30.b-cdn.net/wp-content/uploads/2022/04/cursos-de-algebra.jpg"),
      text: "1. Dado que 2^x * 2^y = 32, entonces x + y es igual a: ",
      options: [
        const Option(text: 'A. 8', isCorrect: false),
        const Option(text: 'B. 7', isCorrect: false),
        const Option(text: 'C. 5', isCorrect: true),
        const Option(text: 'D. 4', isCorrect: false)
      ]),

  //Pregunta 2
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/1.png"),
      text:
          "2. En el dibujo hay un trapecio rectángulo (AD || BC). Según estos datos y los datos del dibujo ¿cuál es el área del trapecio (en m^2)? ",
      options: [
        const Option(text: 'A. 150', isCorrect: false),
        const Option(text: 'B. 120', isCorrect: true),
        const Option(text: 'C. 108', isCorrect: false),
        const Option(text: 'D. 96', isCorrect: false)
      ]),

  //Pregunta 3
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/1.png"),
      text:
          "3. La distancia entre los puntos A y B es de 400 m. La distancia entre los puntos B y C es de 300 m. De aquí que la distancia entre los puntos A y C es necesariamente. ",
      options: [
        const Option(text: 'A. 100m', isCorrect: false),
        const Option(text: 'B. 500m', isCorrect: false),
        const Option(text: 'C. 700m', isCorrect: false),
        const Option(
            text: 'D. No se puede determinar a partir de los datos',
            isCorrect: true)
      ]),

  //Pregunta 4
  Question(
      img:
          ("https://c.pxhere.com/photos/68/7a/assorted_assortment_baked_bakery_cakes_chocolate_chocolate_cupcakes_close_up-1549455.jpg!d"),
      text:
          '4. En la Pastelería El Gran Sabor las empanadas tienen un costo de 1500 pesos y los pandebonos un costo de 💲1000 pesos. Si en total se vendieron 400 productos y se recaudaron 💲500.000, ¿cuántas empanadas y pandebonos fueron comprados en esta pastelería? ',
      options: [
        const Option(
            text: 'A. 300 pandebonos y 300 empanadas. ', isCorrect: false),
        const Option(
            text: 'B. 200 pandebonos y 200 empanadas.', isCorrect: false),
        const Option(
            text: 'C. 600 pandebonos y 400 empanadas.', isCorrect: true),
        const Option(
            text: 'D. 550 pandebonos y 450 empanadas.', isCorrect: false)
      ]),

  //Pregunta 5
  Question(
      img:
          ("https://c.pxhere.com/photos/1e/b3/school_class_school_children_bali_indonesia_pupils_students_learning-1237486.jpg!d"),
      text:
          "5. En un Colegio de Puerto Rico, la profesora quiere saber quién es el menor de sus estudiantes, por lo que le pregunta a uno de ellos al respecto. Juan le responde que él es mayor que Catalina y que José es menor que Daniela, quien es menor que Pedro, el cual es mayor que Catalina, quien es mayor que Daniela y que Pedro es menor que él. ¿Cuál es el orden de mayor a menor de los estudiantes?  ",
      options: [
        const Option(
            text: 'A. Catalina, Juan, Pedro, José, Daniela.', isCorrect: false),
        const Option(
            text: 'B. Pedro, Juan, Catalina, Daniela, José.', isCorrect: false),
        const Option(
            text: 'C. Juan, Catalina, Pedro, José, Daniela.', isCorrect: false),
        const Option(
            text: 'D. Juan, Pedro, Catalina, Daniela, José.', isCorrect: true)
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
