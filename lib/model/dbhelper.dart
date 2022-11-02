import 'package:prueba/model/score.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Este archivo dart contiene todas LA BASE DE DATOS  QUE COMPLEMENTA el modelo MVC
//Contiene codigo SQL que se ejecutara una unica vez almacenando los datos en la cache del dispositivo
//se recomienda iterar el numero del nombre de la base de datos de la linea 13

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'gamilibre007.db'),
      onCreate: (database, version) async {
        const String sql = ''
            'CREATE TABLE scoreTable ('
            ' id TEXT PRIMARY KEY,'
            ' modulo TEXT,'
            ' nivel TEXT,'
            ' score TEXT'
            ');';

        await database.execute(sql);
        const String addScoreGame = ''
            'INSERT INTO scoreTable(id, modulo, nivel, score) VALUES '
            //son 4 valores correspondiente al puntaje segun el modulo
            '("RC1", "RC", "1", "0"),'
            '("RC2", "RC", "2", "0"),'
            '("RC3", "RC", "3", "0"),'
            '("RC4", "RC", "4", "0"),'
            '("RC5", "RC", "5", "0"),'
            '("RC6", "RC", "6", "0"),'
            '("RC7", "RC", "7", "0"),'
            '("RC8", "RC", "8", "0"),'
            '("RC9", "RC", "9", "0"),'
            '("RC10", "RC", "10", "0"),'
            '("RC11", "RC", "11", "0"),'

            //son 4 valores correspondiente al puntaje segun el modulo
            '("DS1", "DS", "1", "0"),'
            '("DS2", "DS", "2", "0"),'
            '("DS3", "DS", "3", "0"),'
            '("DS4", "DS", "4", "0"),'
            '("DS5", "DS", "5", "0"),'
            '("DS6", "DS", "6", "0"),'
            '("DS7", "DS", "7", "0"),'
            '("DS8", "DS", "8", "0"),'
            '("009", "DS", "9", "0"),'
            '("DS10", "DS", "10", "0"),'
            '("DS11", "DS", "11", "0")';

        await database.execute(addScoreGame);

        /*Se recomienda eliminar la version anterior  de la base de datos mientras se testea el software
        deleteDatabase("gamilibre12.db");*/
      },
      version: 1,
    );
  }

  //La siguiente funcion realiza la insercion de las instancias a la tabla puntaje

  //la idea es que esta funcion va a insertar el puntaje completo por nivel dentro de cada modulo
  //se debe invocar cuando se finalice el juego gameover. Se manda desde alla hacia aca mediante un objeto tipogamilibre donde se ponen todos los datos
  Future<void> insertScoreLevel_1(scoregamilibre ScoreGamiLibre) async {
    final db = await initializeDB();

    //inserta en la tabla scoresTable la informaion que se recibe
    // ya lo que se recibe es el objeto que contiene la informacion completa
    await db.insert(
      'scoresTable',
      ScoreGamiLibre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // La siguiente funcion se selecciona un solo elemento
  Future<List<scoregamilibre>> Gamilibre() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery('SELECT * FROM score WHERE nivel like ?', ['%1%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

  //La siguiente funcion se selecciona el puntaje y el modulo de la palabra clave que recibe como argumento
  // se requiere: modulo, nivel

  Future<List<scoregamilibre>> SelectScoreForLevelModule(
      String modulo, String nivel) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
        'SELECT score FROM scoreTable WHERE modulo like ? AND nivel like ?',
        ['%' + modulo + '%' + nivel + '%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

  //La siguiente funcion actualiza los puntajes segun se requiera
  //ACTUALIZA TODA LA INFO ROW SEL SCORE SEGUN EL ID QUE LE PASEN. LOS ID'S YA HAN SIDO CREADOR ANTERIORMENTE
  Future<Future<int>> updateScore(scoregamilibre ScoreGamiLibre) async {
    final db = await initializeDB();

    return db.update("scoreTable", ScoreGamiLibre.toMap(),
        where: "id = ?", whereArgs: [ScoreGamiLibre.id]);
  }

//La siguiente funcion inserta todo un objeto dentro del campo de la tabla de puntajes
  Future<void> insertScoreLevel_2(scoregamilibre ScoreGamiLibre) async {
    final db = await initializeDB();

    var resultado = await db.rawInsert(
        "INSERT INTO scoreTable (modulo, nivel, score) "
        "VALUES (${ScoreGamiLibre.modulo}, ${ScoreGamiLibre.nivel}, ${ScoreGamiLibre.score})");
  }

//La siguiente funcion elimina ej puntaje segun el ID
  Future<void> deleteScore(int id) async {
    final db = await initializeDB();
    await db.delete(
      'scoreTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//La siguiente funcion hace la consulta de todos los puntajes segun el modulo seleccionado
  Future<List<scoregamilibre>> QueryAllScoresRC() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db
        .rawQuery('SELECT * FROM scoreTable WHERE modulo like ?', ['%RC%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

//La siguiente funcion hace la consulta de todos los puntajes segun el modulo seleccionado
  Future<List<scoregamilibre>> QueryAllScoresDS() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db
        .rawQuery('SELECT * FROM scoreTable WHERE modulo like ?', ['%DS%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }
}
