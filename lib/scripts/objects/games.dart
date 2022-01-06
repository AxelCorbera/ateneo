import 'games/dota2.dart';
import 'dart:convert';

Games gamesFromJson(String str) => Games.fromJson(json.decode(str));

String gamesToJson(Games data) => json.encode(data.toJson());

class Games{
  List<String> names;
  Dota2? dota2;
  Games(this.names, this.dota2);

  factory Games.fromJson(Map<String, dynamic> json) => Games(
    List<String>.from(json["names"].map((x) => x)),
    dota2FromJson(json["dota2"]),
  );

  Map<String, dynamic> toJson() => {
    "names": List<String>.from(names.map((x) => x)),
    "dota2": dota2ToJson(dota2!)
  };
}