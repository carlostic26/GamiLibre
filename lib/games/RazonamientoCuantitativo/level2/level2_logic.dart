class GameCards {
  final String hiddenCardpath = 'assets/logo_cards.png';
  List<String>? gameImg;

  final List<String> cards_list = [
    //A continuación se presenta el acceso directo a la dirección de los diferentes tipos de imagenes relacionadas a las tarjetas
    //son valores duplicados ya que estos se guardan en parejas al momento de establecer la lista
    "assets/games/razonamientoCuantitativo/rc_sentence_1.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_3.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_6.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_4.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_4.png",

    "assets/games/razonamientoCuantitativo/rc_sentence_2.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_1.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_2.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_3.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_5.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_6.png",
    "assets/games/razonamientoCuantitativo/rc_sentence_5.png",
  ];

  // in this list we will store the two first clicked card and see if they match or not
  List<Map<int, String>> matchCheck = [];

  final int cardCount = 12;

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
