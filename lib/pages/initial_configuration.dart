import 'package:ateneo/constants/theme_data.dart';
import 'package:ateneo/provider/google_sing_in.dart';
import 'package:ateneo/scripts/images_games.dart';
import 'package:ateneo/scripts/lista_rangos.dart';
import 'package:ateneo/scripts/objects/games.dart';
import 'package:ateneo/scripts/objects/games/dota2.dart';
import 'package:ateneo/scripts/objects/user.dart' as us;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ateneo/globals.dart' as globals;
import 'package:provider/provider.dart';

class Initial_Configuration extends StatefulWidget {
  _Initial_ConfigurationState createState() => _Initial_ConfigurationState();
}

class _Initial_ConfigurationState extends State<Initial_Configuration> {
  GlobalKey<FormState> _keyForm = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  bool player = false;
  bool team = false;
  bool coach = false;
  Games games = Games([], null);
  List<String> juegos = [];
  String juego = '';
  List<String> rangos = [];
  String rango = '';
  List<String> roles = [];
  String rol = '';
  @override
  Widget build(BuildContext context) {
    print(games.names.length);
    return Scaffold(
      key: _keyScaf,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Gradientes.fondo)),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/4,
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: (){
                globals.login = false;
                globals.user = us.User('', '', '', '', '', '', '', '','',[],[]);
                FirebaseAuth.instance.signOut();
                final provider = Provider.of<GoogleSignInProvider>(context,
                    listen: false);
                provider.logout().then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false));

                },
                icon: Icon(Icons.arrow_back,
                size: 30,
                color: Colors.white,),
              ),
            ),
            Form(
              key: _keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tipo de cuenta',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        player = true;
                                        team = false;
                                        coach = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.person,
                                      color: player ? Colores.cian : Colors.grey,
                                      size: 60,
                                    )),
                              ),
                              Text(
                                'PLAYER',
                                style: TextStyle(
                                    color: player ? Colores.cian : Colors.grey,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        player = false;
                                        team = true;
                                        coach = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.shield,
                                      color: team ? Colores.cian : Colors.grey,
                                      size: 50,
                                    )),
                              ),
                              Text(
                                'TEAM',
                                style: TextStyle(
                                    color: team ? Colores.cian : Colors.grey,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        player = false;
                                        team = false;
                                        coach = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.work_outlined,
                                      color: coach ? Colores.cian : Colors.grey,
                                      size: 50,
                                    )),
                              ),
                              Text(
                                'COACH',
                                style: TextStyle(
                                    color: coach ? Colores.cian : Colors.grey,
                                    fontSize: 20),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  if (player == true || team == true || coach == true)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Elije tus juegos',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            _nuevoJuego(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: Gradientes.uno),
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 88.0, minHeight: 45.0),
                              // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Agregar juego',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (games.names.isNotEmpty)
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width/1.2,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0,15,0,15),
                              child: Text(
                                'Juegos seleccionados',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        if (games.names.isNotEmpty)
                          MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: games.names.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width/1.2,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex:3,
                                          child: Image.asset(
                                            logo_juego(games.names[index]),
                                            height: 40,
                                          ),
                                        ),
                                        Expanded(
                                            flex:5,
                                            child: Text(
                                          games.names[index],
                                          style: TextStyle(color: Colors.white),
                                        )),
                                        Expanded(
                                            flex:3,
                                            child: IconButton(
                                                onPressed: () {
                                                  eliminarJuego(games.names[index]);
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Colores.rosa,
                                                )))
                                      ],
                                    ),
                                  );
                                }),
                          )
                      ],
                    ),
                  if (player == true || team == true || coach == true) SizedBox(),
                  if (player == true || team == true || coach == true)
                    RaisedButton(
                      onPressed: games.names.isNotEmpty
                          ? () async {
                              if (player == true &&
                                  team == false &&
                                  coach == false) {
                                globals.user.user = 'player';
                              } else if (player == false &&
                                  team == true &&
                                  coach == false) {
                                globals.user.user = 'team';
                              } else {
                                globals.user.user = 'coach';
                              }
                              globals.user.games = gamesToJson(games);
                              Navigator.of(context)
                                  .pushNamed('/Initial_Configuration_Perfil');
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 40,
                        decoration: games.names.isNotEmpty
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: Gradientes.dos),
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                              )
                            : null,
                        child: Container(
                          constraints:
                              const BoxConstraints(minWidth: 88.0, minHeight: 30.0),
                          // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continuar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nuevoJuego(BuildContext context) {
    List<String> j = _juegos();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: Colores.negro,
                content: Form(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'GAME',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          dropdownColor: Colores.negro,
                          value: juego != '' ? juego : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            setState(() {
                              juego = value.toString();
                              cargarInfo(juego);
                            });
                            //Navigator.pop(context);
                            //_direccion(context, value.toString(), '', '', '');
                          },
                          hint: Text(
                            'Game',
                            style: TextStyle(color: Colors.white),
                          ),
                          isExpanded: true,
                          items: j.map((String val) {
                            return DropdownMenuItem(
                                value: val,
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      logo_juego(val),
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      val,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ));
                          }).toList(),
                        ),
                      ),
                      if (juego != '' && rangos.isNotEmpty)
                        Expanded(
                          child: DropdownButtonFormField(
                            dropdownColor: Colores.negro,
                            value: rango != '' ? rango : null,
                            onTap: () {},
                            onSaved: (value) {},
                            onChanged: (value) {
                              setState(() {
                                rango = value.toString();
                              });
                            },
                            hint: Text(
                              'Range',
                              style: TextStyle(color: Colors.white),
                            ),
                            isExpanded: true,
                            items: rangos.map((String val) {
                              return DropdownMenuItem(
                                  value: val,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        rango_juego(val),
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        val,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ));
                            }).toList(),
                          ),
                        ),
                      if (juego != '' && roles.isNotEmpty)
                        Expanded(
                          child: DropdownButtonFormField(
                            dropdownColor: Colores.negro,
                            value: rol != '' ? rol : null,
                            onTap: () {},
                            onSaved: (value) {},
                            onChanged: (value) {
                              setState(() {
                                rol = value.toString();
                              });
                            },
                            hint: Text(
                              'Rol',
                              style: TextStyle(color: Colors.white),
                            ),
                            isExpanded: true,
                            items: roles.map((String val) {
                              return DropdownMenuItem(
                                  value: val,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        val,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ));
                            }).toList(),
                          ),
                        ),
                      RaisedButton(
                        onPressed: juego == ''
                            ? null
                            : () async {
                                agregarJuego(juego);
                                juego = '';
                                rango = '';
                                rangos = [];
                                rol = '';
                                roles = [];
                                actualizar();
                                Navigator.pop(context);
                              },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 40,
                          decoration: juego == ''
                              ? null
                              : BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: Gradientes.dos),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0, minHeight: 40.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Aceptar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          juego = '';
                          rango = '';
                          rangos = [];
                          rol = '';
                          roles = [];
                          actualizar();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ));
          });
        });
  }

  List<String> _juegos() {
    List<String> l = ['DOTA 2'];
    games.names.forEach((element) {
      l.remove(element);
    });
    return l;
  }

  void cargarInfo(String juego) {
    switch (juego) {
      case 'DOTA 2':
        rangos = Dota2('', '', '', '').rangos;
        roles = Dota2('', '', '', '').posiciones;
    }
  }

  void agregarJuego(String juego) {
    switch (juego) {
      case 'DOTA 2':
        Dota2 dota2 = Dota2('', rango, rol, '');
        games.dota2 = dota2;
    }
    games.names.add(juego);
  }

  void eliminarJuego(String juego) {
    switch (juego) {
      case 'DOTA 2':
        games.dota2 = null;
    }
    games.names.remove(juego);
  }

  void actualizar() {
    setState(() {});
  }
}
