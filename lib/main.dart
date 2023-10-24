// Importa los paquetes y archivos necesarios para la aplicación.
import 'package:flutter/material.dart';
import 'views/main_screen.dart';
import 'themes/themes.dart';

// El punto de entrada principal de cualquier aplicación Flutter.
void main() => runApp(const MyApp());

// Definición de la clase `MyApp`, que extiende `StatefulWidget`, 
class MyApp extends StatefulWidget {
  // Constructor constante para la clase `MyApp`.
  const MyApp({super.key});

  // Crea el estado asociado con este widget.
  @override
  _MyAppState createState() => _MyAppState();
}

// Definición del estado `_MyAppState` asociado con el widget `MyApp`.
class _MyAppState extends State<MyApp> {
  // Define un `ValueNotifier<bool>`, que será utilizado para cambiar entre temas claro y oscuro.
  // Si es `true`, el tema oscuro estará activo; de lo contrario, el tema claro estará activo.
  final themeNotifier = ValueNotifier<bool>(false);

  // El método `build` define la parte visual de nuestro widget.
  @override
  Widget build(BuildContext context) {
    // `ValueListenableBuilder` escucha cambios en `themeNotifier`.
    // Cuando el valor de `themeNotifier` cambia, reconstruye su widget hijo.
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, child) {
        // `MaterialApp` es la raíz de nuestra aplicación.
        // Configura el tema basado en el valor de `isDark`.
        return MaterialApp(
          title: 'Bloc de Notas',
          // Aplica el tema oscuro o claro según el valor de `isDark`.
          // Esto se refiere al punto "Themes & Styles" que se había definido.
          theme: isDark ? AppThemes.dark : AppThemes.light,
          // `MainScreen` es la primera pantalla que se muestra cuando se lanza la aplicación.
          // Pasamos el `themeNotifier` a `MainScreen` para poder cambiar el tema desde allí.
          home: MainScreen(themeNotifier: themeNotifier),
        );
      },
    );
  }

  // Cuando este estado se destruye, debemos eliminar el `ValueNotifier` para evitar fugas de memoria.
  @override
  void dispose() {
    themeNotifier.dispose();
    super.dispose();
  }
}
