// Importamos la biblioteca de Flutter para trabajar con los temas.
import 'package:flutter/material.dart';

// Clase que contiene definiciones de temas para la aplicación.
class AppThemes {
  
  // Definimos un tema claro para la aplicación.
  static final ThemeData light = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    
  );

  // Definimos un tema oscuro para la aplicación.
  static final ThemeData dark = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    
  );
}

