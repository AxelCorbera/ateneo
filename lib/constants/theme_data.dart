import 'package:flutter/material.dart';

class Colores {
  static Color primaryTextColor = Colors.white;
  static Color dividerColor = Colors.white54;
  static Color pageBackgroundColor = Color(0xFF2D2F41);
  static Color menuBackgroundColor = Color(0xFF242634);

  static Color cian = Color(0xFF3BD6B8);
  static Color azul = Color(0xFF355CD9);
  static Color rosa = Color(0xFFFD8376);
  static Color violeta = Color(0xFF9800FA);
  static Color negro = Color(0xFF252429);
}

class Gradientes {
  final List<Color> colors;
  Gradientes(this.colors);

  static List<Color> fondo = [Color(0xFF252429), Color(0xFF18181C)];
  static List<Color> uno = [Color(0xFF3BD6B8), Color(0xFF355CD9)];
  static List<Color> dos = [Color(0xFFFD8376), Color(0xFF9800FA)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

class GradientTemplate {
  static List<Gradientes> gradientTemplate = [
    Gradientes(Gradientes.fondo),
    Gradientes(Gradientes.uno),
    Gradientes(Gradientes.dos),
    Gradientes(Gradientes.mango),
    Gradientes(Gradientes.fire),
  ];
}