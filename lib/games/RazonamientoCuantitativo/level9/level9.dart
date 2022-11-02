import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:soundpool/soundpool.dart';

class level9 extends StatefulWidget {
  const level9({super.key});

  @override
  State<level9> createState() => _level9State();
}

/*NIVEL TIPO QUIZ 
  Este nivel consiste en desplegar diferentes tipos de preguntas
  El jugador deberá seleccionar una de las opciones.

  El sistema validará la respuesta seleccionada a traves de un aviso sobre la respuesta.

*/
class _level9State extends State<level9> {
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
                " #5",
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
          height: 135,
          width: 330,
          child: SingleChildScrollView(
            child: Text(
              //TEXTO QUE CONTIENE LA PREGUNTA COMPLETA
              question.text,
              style: const TextStyle(
                  color: Color.fromARGB(255, 61, 13, 4),
                  fontFamily: 'ZCOOL',
                  fontSize: 16.0),
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
              id: 'RC9', modulo: 'RC', nivel: '9', score: _score.toString()));
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
        height: 73, //altura de las tarjetas de cada opcion
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
                      color: Colors.white, fontFamily: 'ZCOOL', fontSize: 14.0),
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
          ("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Men%27s_5000m_-_T11_London_2012.jpg/1280px-Men%27s_5000m_-_T11_London_2012.jpg"),
      text:
          "Una prueba atlética tiene un récord mundial de 10,49 segundos y un récord olímpico de 10,50 segundos. ¿Es posible que un atleta registre un tiempo, en el mismo tipo de prueba, que rompa el récord olímpico pero no el mundial?",
      options: [
        const Option(
            text:
                'Sí, porque puede registrar un tiempo menor que 10,4 y marcaría un nuevo récord.',
            isCorrect: true),
        const Option(
            text:
                'Sí, porque puede registrar, por ejemplo, un tiempo de 10,497 segundos, que está entre los dos tiempos récord. ',
            isCorrect: false),
        const Option(
            text:
                'No, porque no existe un registro posible entre los dos tiempos récord.',
            isCorrect: false),
        const Option(
            text:
                'No, porque cualquier registro menor que el récord olímpico va a ser menor que el récord mundial.',
            isCorrect: false)
      ]),

  //Pregunta 2
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/6.png"),
      text:
          "En una institución educativa hay dos cursos en grado undécimo. El número de hombres y mujeres de cada curso se relaciona en la tabla presentada. La probabilidad de escoger un estudiante de grado undécimo, de esta institución, que sea mujer es de 3/5. Este valor corresponde a la razón entre el número total de mujeres y  ",
      options: [
        const Option(
            text: 'el número total de estudiantes de grado undécimo. ',
            isCorrect: true),
        const Option(
            text: 'el número total de hombres de grado undécimo. ',
            isCorrect: false),
        const Option(
            text: 'el número total de mujeres del curso 11 B.',
            isCorrect: false),
        const Option(
            text: 'el número total de hombres del curso 11 A.',
            isCorrect: false)
      ]),

  //Pregunta 3
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/7_1.png"),
      text:
          "RESPONDA LAS PREGUNTAS 3 Y 4 DE ACUERDO CON LA SIGUIENTE INFORMACIÓN.\nPara adquirir un crédito por 💲6.000.000, Ángela solicita en una entidad financiera información sobre las modalidades de pago para crédito. Un asesor le da la siguiente información.  Después de analizar la información, Ángela afirma: “Con la modalidad I, el valor de la cuota disminuirá 💲50.000 en cada mes”\nLa afirmación es correcta porque ",
      options: [
        const Option(
            text:
                'el interés total del crédito serían 💲300.000 y cada mes disminuiría 💲50.000. ',
            isCorrect: false),
        const Option(
            text:
                'cada mes se abonarían al crédito 💲1.000.000 y el interés disminuiría en 💲50.000. ',
            isCorrect: true),
        const Option(
            text:
                'cada mes aumentaría el abono al crédito en 💲50.000, de manera que el interés disminuirá. ',
            isCorrect: false),
        const Option(
            text:
                'el abono al crédito disminuiría 💲50.000 cada mes, al igual que el interés.',
            isCorrect: false)
      ]),

  //Pregunta 4
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/7_1.png"),
      text: 'El interés total de un crédito es la cantidad de dinero que se paga adicional al valor del mismo. ¿Cuál(es) de los siguientes procesos podría utilizar la entidad, para calcular el interés total del crédito de Ángela, si se pagara con la modalidad II? ' +
          'Proceso 1: calcular el 20% de 💲6.000.000.' +
          'Proceso 2: calcular el 20% de 💲6.000.000 y multiplicarlo por 12. ' +
          'Proceso 3: calcular el valor de la cuota, multiplicarlo por 12 y al resultado restarle 💲6.000.000.',
      options: [
        const Option(text: '1 solamente. ', isCorrect: false),
        const Option(text: '2 solamente. ', isCorrect: true),
        const Option(text: '1 y 3 solamente. ', isCorrect: false),
        const Option(text: '2 y 3 solamente.', isCorrect: false)
      ]),

  //Pregunta 5
  Question(
      img: ("http://gamilibre.com/imagenesrazonamiento/8.png"),
      text:
          "Para fijar un aviso publicitario se coloca sobre un muro una escalera a 12 metros del suelo. Las figuras, además, muestran la situación y algunas de las medidas involucradas. ¿Cuál es el coseno del ángulo que forman el suelo y la escalera?",
      options: [
        const Option(text: '13/5', isCorrect: false),
        const Option(text: '12 /5', isCorrect: false),
        const Option(text: '5/13', isCorrect: true),
        const Option(text: '12/13', isCorrect: false)
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
