// es un archivo dart que contiene el modelo de puntaje

class scoregamilibre {
  final String id;
  final String modulo;
  final String nivel;
  final String score;

  scoregamilibre({
    required this.id,
    required this.modulo,
    required this.nivel,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nivel': nivel,
      'modulo': modulo,
      'score': score,
    };
  }

  scoregamilibre.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        nivel = res["nivel"],
        modulo = res["modulo"],
        score = res["score"];

  @override
  String toString() {
    return 'quiz{id: $id, nivel: $nivel, modulo: $modulo, score: $score}';
  }
}
