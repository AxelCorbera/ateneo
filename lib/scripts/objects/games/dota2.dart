import 'dart:convert';

Dota2 dota2FromJson(String str) => Dota2.fromJson(json.decode(str));

String dota2ToJson(Dota2 data) => json.encode(data.toJson());

class Dota2{
  String usuario;
  String? rango;
  String? posicion;
  String? url;

  factory Dota2.fromJson(Map<String, dynamic> json) => Dota2(
    json["usuario"],
    json["rango"],
    json["posicion"],
    json["url"],
  );

  Map<String, dynamic> toJson() => {
    "usuario": usuario,
    "rango": rango,
    "posicion": posicion,
    "url": url,
  };

  Dota2(this.usuario,this.rango,this.posicion,this.url);

  final List<String> rangos =
  [
    'Herald 1',
    'Herald 2',
    'Herald 3',
    'Herald 4',
    'Herald 5',
    'Guardian 1',
    'Guardian 2',
    'Guardian 3',
    'Guardian 4',
    'Guardian 5',
    'Crusader 1',
    'Crusader 2',
    'Crusader 3',
    'Crusader 4',
    'Crusader 5',
    'Archon 1',
    'Archon 2',
    'Archon 3',
    'Archon 4',
    'Archon 5',
    'Legend 1',
    'Legend 2',
    'Legend 3',
    'Legend 4',
    'Legend 5',
    'Ancient 1',
    'Ancient 2',
    'Ancient 3',
    'Ancient 4',
    'Ancient 5',
    'Divine 1',
    'Divine 2',
    'Divine 3',
    'Divine 4',
    'Divine 5',
  ];

  final List<String> posiciones =
  [
    'Carry/Safelane',
    'Mid-laner',
    'Off-lane',
    'Roaming Support',
    'Hard Support',
  ];
}
