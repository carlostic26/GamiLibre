import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/desarrollo_software.dart';
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
      backgroundColor: Colors.red,
      body: Stack(alignment: Alignment.center, children: <Widget>[
        //banner superior
        Positioned(
          top: -195,
          left: 100,
          child: Container(
            padding: const EdgeInsets.all(1.0),
            width: 150,
            height: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/games/general/bannerGamerQuiz.png"),
              ),
            ),
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
    // TODO: implement initState
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
            'Pregunta $_questionNumber/${questions.length}',
            style: const TextStyle(
                color: Colors.white, fontFamily: 'ZCOOL', fontSize: 15.0),
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
          question.text,
          style: const TextStyle(
              color: Colors.white, fontFamily: 'ZCOOL', fontSize: 16.0),
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
              id: 'DS5', modulo: 'DS', nivel: '5', score: _score.toString()));
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
        height: 80, //altura de las tarjetas de cada opcion
        padding: const EdgeInsets.fromLTRB(3, 0, 1, 0),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
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
                      color: Colors.black, fontFamily: 'ZCOOL', fontSize: 17.0),
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
            : const Icon(Icons.cancel, color: Colors.red);
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
      img: ("http://gamilibre.com/imagenes/t1.png"),
      text:
          "1. Dentro del paradigma de orientación a objetos Un método puede ser redefinido en una subclase si es marcado en la superclase como ",
      options: [
        const Option(text: 'A. abreviado. ', isCorrect: false),
        const Option(text: 'B. sobrecargado. ', isCorrect: false),
        const Option(text: 'C. estático.  ', isCorrect: false),
        const Option(text: 'D. abstracto', isCorrect: true)
      ]),

  //Pregunta 2
  Question(
      img: ("http://gamilibre.com/imagenes/t2.png"),
      text:
          "2. Para recorrer una colección sin depender de su implementación, se puede utilizar un patrón de diseño de tipo ",
      options: [
        const Option(
            text:
                'A. prototipo, porque conviene realizar ensayos de recorridos antes de decidir una implementación definitiva. ',
            isCorrect: false),
        const Option(
            text:
                'B. interfaz, porque de esta manera se establece un comportamiento abstracto que puede implementarse posteriormente.  ',
            isCorrect: false),
        const Option(
            text:
                'C. iterador, porque este define operaciones de avance, retroceso y detección de terminación en una colección abstracta.  ',
            isCorrect: true),
        const Option(
            text:
                'D. fachada, porque este abstrae la selección de los servicios de un sistema sin importar su implementación',
            isCorrect: false)
      ]),

  //Pregunta 3
  Question(
      img: ("http://gamilibre.com/imagenes/e6.jpeg"),
      text:
          "3. Cuando un cliente define un conjunto de objetivos generales para el desarrollo de software, pero no logra identificar los requisitos de entrada, procesamiento o salida detalladamente, el mejor proceso de desarrollo de software para este caso es el modelo de",
      options: [
        const Option(text: ' A. proceso unificado. ', isCorrect: false),
        const Option(text: 'B. prototipos.', isCorrect: true),
        const Option(text: 'C. cascada. ', isCorrect: false),
        const Option(
            text: 'D. desarrollo basado en componentes.', isCorrect: false)
      ]),

  //Pregunta 4
  Question(
      img: ("http://gamilibre.com/imagenes/p4.jpg"),
      text:
          '4. En el modelo de la cascada, a veces llamado ciclo de vida clásico  seleccione la afirmación correcta ',
      options: [
        const Option(
            text: 'A. Capa de aplicación, Capa de presentación: ',
            isCorrect: false),
        const Option(
            text:
                'B. Se caracterizan por la manera en la que permiten desarrollar versiones cada vez más completas del software.',
            isCorrect: false),
        const Option(
            text:
                'C. combina elementos de los flujos de proceso lineal y paralelo',
            isCorrect: false),
        const Option(
            text:
                'D. comienza con la especificación de los requerimientos por parte del cliente y avanza a través de planeación, modelado, construcción y despliegue, para concluir con el apoyo del software terminado',
            isCorrect: true)
      ]),

  //Pregunta 5
  Question(
      img: ("http://gamilibre.com/imagenes/t4.jpg"),
      text:
          "5. En el modelo de proceso incremental,   seleccione la afirmación correcta",
      options: [
        const Option(
            text:
                'A. Se caracterizan por la manera en la que permiten desarrollar versiones cada vez más completas del software',
            isCorrect: false),
        const Option(
            text:
                ' B. aplica secuencias lineales en forma escalonada a medida que avanza el calendario de actividades',
            isCorrect: true),
        const Option(
            text:
                ' C. los métodos de la clase pueden haber sido redefinidos.  ',
            isCorrect: false),
        const Option(text: 'D. ninguna de las anteriores', isCorrect: false)
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
