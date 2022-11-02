import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/dialogs/dialog_helper.dart';
import 'package:prueba/model/user_model.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/desarrollo_software.dart';
import 'package:prueba/view/login_screen.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:prueba/services/local_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:soundpool/soundpool.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String urlImagen = '';

  late YoutubePlayerController controller;

  @override
  void initState() {
    // TODO: implement initState

    //si es la primera vez que el usuario entra
    if (LocalStorage.prefs.getBool('firstLog') == true) {
      if (LocalStorage.prefs.getString('url') != '') {
        print("Si contiene url----------------------------------------------");
        var url = LocalStorage.prefs.getString('url')?.length ??
            'http://gamilibre.com/imagenes/user.png';
        urlImagen = url.toString();

        //aqui se debe enviar a shared preferences que el booleano de firstlogin = false
        LocalStorage.prefs.setBool("firstLog", false);
      } else {
        print("NO CONTIENE URL -----------------------------------");
        urlImagen = "http://gamilibre.com/imagenes/user.png";
      }
    } else {
      //si el usuario ya entro por 2 o mas veces a la app
      if (LocalStorage.prefs.getString('url') != null) {
        print("Si contiene avatar----------------------------");
        var test = LocalStorage.prefs.getString('url');
        urlImagen = test.toString();
      } else {
        print("NO CONTIENE AVATAR ----------------------------");
        urlImagen = 'http://gamilibre.com/imagenes/user.png';
      }
    }

    _soundWelcome();

    const url = 'https://youtu.be/lprEuogWW64'; //https://youtu.be/DqYzwdC6kK8

    controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
        flags: const YoutubePlayerFlags(
          mute: false,
          loop: true,
          autoPlay: true,
        ));

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YoutubePlayerBuilder(
          player: YoutubePlayer(controller: controller),
          builder: (context, player) => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Inicio",
                    style: TextStyle(
                      fontFamily: 'ZCOOL',
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.red,
                ),
                body: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: <Widget>[
                    //CONTAINER DEL FONDO QUE CONTIENE IMAGEN DE FONDO LADRILLOS

                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/fondos/fondo_ladrillos_blur.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              //CONTAINER DEL FONDO QUE CONTIENE IMAGEN DE FONDO LADRILLOS
                              //youtube player
                              Positioned(
                                  top: 42,
                                  left: 10,
                                  child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          1, 1, 45, 1),
                                      width: MediaQuery.of(context).size.width,
                                      child: player)),

                              //tv marco
                              Positioned(
                                top: -120,
                                left: -13,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(1.0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 500,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/banners/tvHome.png"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: const [
                                  SizedBox(
                                    height: 300,
                                  ),
                                  Text(
                                    "¿Cómo funciona Gamilibre?",
                                    style: TextStyle(
                                        fontFamily: 'ZCOOL',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 700,
                                    width: 600,
                                    child: Text(
                                        "Gamilibre es una aplicación movil que promueve el concepto de la gamificación en la educacion. " +
                                            "\n\nPermite un entrenamiento lúdico y autodidacta respecto a los modulos de razonamiento cuantitativo y diseño de software" +
                                            " en estudiantes de ingenieria industrial e ingenieria en TIC de la Universidad Libre Seccional Cúcuta próximos a presentar las pruebas de estado ICFES Saber PRO." +
                                            "\n\nGamilibre cuenta con 10 niveles que incluyen los siguientes gamijuegos:\n\n" +
                                            "1.  Gamiquices\n2. GamiCards\n3. GamiAhorcado\n4. GamiChooser" +
                                            "\n\nEl objetivo de Gamilibre es brindar un ecosistema gamificado de constantes pruebas y aprendizajes simultáneos a traves de los diferentes niveles relacionados con conceptos e identidades que se deben tener en cuenta según la temática de cada módulo. \n\nEl usuario podrá ver el progreso de su aprendizaje a traves de los puntajes que se irán generando durante el paso de los niveles." +
                                            "\n\n\nDesarrollado por:\nCarlos Alberto Salas - Carlos Andrés Peñaranda",
                                        style: TextStyle(
                                            fontFamily: 'ZCOOL',
                                            fontSize: 16,
                                            color: Colors.white),
                                        textAlign: TextAlign.justify),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                drawer: _getDrawer(context),
              )),
    );
  }

  //NAVIGATION DRAWER
  Widget _getDrawer(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: const Color.fromARGB(255, 255, 233, 230),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  loggedInUser.fullName.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'ZCOOL',
                  ),
                ),
                accountEmail: Text(
                  loggedInUser.email.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'ZCOOL',
                  ),
                ),
                currentAccountPicture: Image.network(
                    urlImagen), //currentAccountPicture: Image.asset('assets/icon/ic_launcher.png'),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 104, 9, 9),
                    Colors.red,
                  ]),
                ),
              ),
              onTap: (() {
                DialogHelper.showDialogAvatar(context);
              }),
            ),
            ListTile(
              title: const Text("Cambiar Avatar",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'ZCOOL',
                    fontSize: 18,
                  )),
              leading: const Icon(
                Icons.manage_accounts,
                size: 40,
                color: Color.fromARGB(255, 149, 10, 0),
              ),
              onTap: () => {
                DialogHelper.showDialogAvatar(context),
              },
            ),
            ListTile(
              title: const Text("Razonamiento Cuantitativo",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'ZCOOL',
                    fontSize: 18,
                  )),
              leading: const Icon(
                Icons.numbers,
                size: 40,
                color: Color.fromARGB(255, 149, 10, 0),
              ),
              onTap: () => {
                _soundGoModule(),
                controller.pause(),
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.bounceInOut);

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
                        })),
                controller.pause(),
              },
            ),
            ListTile(
              title: const Text("Diseño de Software",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'ZCOOL',
                    fontSize: 18,
                  )),
              leading: const Icon(
                Icons.computer,
                size: 40,
                color: Color.fromARGB(255, 149, 10, 0),
              ),
              onTap: () => {
                _soundGoModule(),
                controller.pause(),
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation,
                          Widget child) {
                        animation = CurvedAnimation(
                            parent: animation, curve: Curves.slowMiddle);

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
                      }),
                ),
                controller.pause(),
              },
            ),
            ListTile(
              title: const Text("Mis Puntajes",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'ZCOOL',
                    fontSize: 18,
                  )),
              leading: const Icon(
                Icons.score,
                size: 40,
                color: Color.fromARGB(255, 149, 10, 0),
              ),
              onTap: () => {
                _soundGoScore(),
                setState(() {
                  controller.pause();
                }),
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation,
                          Widget child) {
                        animation = CurvedAnimation(
                            parent: animation, curve: Curves.slowMiddle);

                        return ScaleTransition(
                          alignment: Alignment.center,
                          scale: animation,
                          child: child,
                        );
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimattion) {
                        //se le manda la variable que ayuda a guiarse de que ántalla viene
                        return MyScore2(
                          puntoPartida: 'home',
                        );
                      }),
                ),
              },
            ),
            const SizedBox(
              height: 30,
              child: Divider(
                height: 3,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 1, 1, 1),
              child: Text("  Mi cuenta",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'ZCOOL',
                      fontSize: 20)),
            ),
            ListTile(
              title: const Text("Cerrar sesión",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'ZCOOL',
                    fontSize: 18,
                  )),
              leading: const Icon(
                Icons.logout,
                size: 40,
                color: Color.fromARGB(255, 149, 10, 0),
              ),
              onTap: () => {logout(context)},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> _soundWelcome() async {
    Soundpool pool = Soundpool(streamType: StreamType.music);
    int soundId = await rootBundle
        .load("assets/soundFX/welcome2.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });

//volumen
    int streamId = await pool.play(soundId);
    pool.setVolume(soundId: soundId, streamId: streamId, volume: 0.5);
  }

  Future<void> _soundGoModule() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle
        .load("assets/soundFX/transition1.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  Future<void> _soundGoScore() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle
        .load("assets/soundFX/transition2.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }
}
