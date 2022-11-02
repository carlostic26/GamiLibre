class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? carrera;
  String? sumScoreRC;
  String? sumScoreDS;

  UserModel(
      {this.uid,
      this.email,
      this.fullName,
      this.carrera,
      this.sumScoreRC,
      this.sumScoreDS});

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      carrera: map['carrera'],
      sumScoreRC: map['sumScoreRC'],
      sumScoreDS: map['sumScoreDS'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'carrera': carrera,
      'sumScoreRC': sumScoreRC,
      'sumScoreDS': sumScoreDS,
    };
  }
}
