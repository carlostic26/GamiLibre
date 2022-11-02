import 'package:flutter/material.dart';
import 'package:prueba/dialogs/avatars.dart';
import 'package:prueba/dialogs/dialogLevelsDS.dart';
import 'package:prueba/dialogs/dialogLevelsRC.dart';
import 'package:prueba/dialogs/gameover.dart';

// es la clase de dialogo que conecta con la clase del menu
//cada dialogo se trabaja independiente respectivamente de cada modulo y nivel
//se recomienda un dialogo unico para todos los contexto para recibir un parametro como un argumento
class DialogHelper {
  //Dialogos para Diseño

  static showDialogAvatar(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogAvatar());
  static showDialoglevel1DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialoglevel1DS());

  static showDialogLevel2DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel2DS());

  static showDialogLevel3DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel3DS());

  static showDialogLevel4DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel4DS());

  static showDialogLevel5DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel5DS());

  static showDialogLevel6DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel6DS());

  static showDialogLevel7DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel7DS());

  static showDialogLevel8DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel8DS());

  static showDialogLevel9DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel9DS());

  static showDialoglevel10DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialoglevel10DS());

  static showDialoglevel11DS(context) =>
      showDialog(context: context, builder: (builder) => ShowDialoglevel11DS());

  //Dialogos para Razonamiento

  static showDialoglevel1RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialoglevel1RC());

  static showDialogLevel2RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel2RC());

  static showDialogLevel3RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel3RC());

  static showDialogLevel4RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel4RC());

  static showDialogLevel5RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel5RC());

  static showDialogLevel6RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel6RC());

  static showDialogLevel7RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel7RC());

  static showDialogLevel8RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel8RC());

  static showDialogLevel9RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel9RC());

  static showDialoglevel10RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel10RC());

  static showDialoglevel11RC(context) =>
      showDialog(context: context, builder: (builder) => ShowDialogLevel11RC());

  //GameOver RC -- recibe un contexto y un puntaje
  static showDialogGameOver(context, score, puntoPartida) => showDialog(
      context: context,
      builder: (builder) => ShowDialogGameOver(
            score: score,
            puntoPartida: puntoPartida,
          ));
}
