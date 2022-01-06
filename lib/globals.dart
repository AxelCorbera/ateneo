import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:ateneo/scripts/objects/user.dart';

User user = User('', '', '', '', '', '', '', '','',[],[]);

bool login = false;

File file = File('');

bool logueando = false;

auth.User? userAuth;