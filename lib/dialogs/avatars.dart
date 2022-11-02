import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba/games/DesarrolloSoftware/level1/level1.dart';
import 'package:prueba/services/local_storage.dart';
import 'package:soundpool/soundpool.dart';

// la clase que cargara en cache los avatares selecciondos por el usuario
class ShowDialogAvatar extends StatelessWidget {
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
        //Dialogo que explica el nivel antes de entrar
        Positioned(
          child: Container(
            width: 300,
            height: 120,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  'http://gamilibre.com/imagenes/bannerAvatar.png'),
            )),
          ),
        ),

        //AVATAR 1
        Positioned(
          left: 15,
          bottom: 30,
          child: GestureDetector(
            child: Container(
              width: 50,
              height: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    'http://gamilibre.com/imagenesavatar/avatar_men_1.png'),
                fit: BoxFit.cover,
              )),
            ),
            onTap: () => {
              Navigator.pop(context),
              LocalStorage.prefs.setString("url",
                  'http://gamilibre.com/imagenesavatar/aavatar_men_1.png'),
              Fluttertoast.showToast(
                msg: "Avatar agregado", // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.BOTTOM, // location
              ),
            },
          ),
        ),

        //AVATAR 2
        Positioned(
          left: 82,
          bottom: 30,
          child: GestureDetector(
            child: Container(
              width: 50,
              height: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    'http://gamilibre.com/imagenesrazonamiento/avatar_women_1.png'),
                fit: BoxFit.cover,
              )),
            ),
            onTap: () => {
              Navigator.pop(context),
              LocalStorage.prefs.setString("url",
                  'http://gamilibre.com/imagenesavatar/aavatar_women_1.png'),
              Fluttertoast.showToast(
                msg: "Avatar agregado", // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.BOTTOM, // location
              ),
            },
          ),
        ),

        //AVATAR 3
        Positioned(
          right: 79,
          bottom: 30,
          child: GestureDetector(
            child: Container(
              width: 50,
              height: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    'http://gamilibre.com/imagenesrazonamiento/avatar_men_2.png'),
                fit: BoxFit.cover,
              )),
            ),
            onTap: () => {
              Navigator.pop(context),
              LocalStorage.prefs.setString("url",
                  'http://gamilibre.com/imagenesavatar/aavatar_men_2.png'),
              Fluttertoast.showToast(
                msg: "Avatar agregado", // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.BOTTOM, // location
              ),
            },
          ),
        ),

        //AVATAR 4
        Positioned(
          right: 15,
          bottom: 30,
          child: GestureDetector(
            child: Container(
              width: 50,
              height: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    'http://gamilibre.com/imagenesrazonamiento/avatar_women_2.png'),
                fit: BoxFit.cover,
              )),
            ),
            onTap: () => {
              Navigator.pop(context),
              LocalStorage.prefs.setString("url",
                  'http://gamilibre.com/imagenesavatar/aavatar_women_2.png'),
              Fluttertoast.showToast(
                msg: "Avatar agregado", // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.BOTTOM, // location
              ),
            },
          ),
        ),
        Positioned(
          top: 5,
          child: Container(
            child: const Text(
              //titulo del nivel
              "Selecciona tu avatar",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'ZCOOL', fontSize: 12.0),
            ),
          ),
        ),
      ]);
}

Future<void> _soundGoLevel() async {
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  int soundId = await rootBundle
      .load("assets/soundFX/playlevel.wav")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });
  int streamId = await pool.play(soundId);
}
