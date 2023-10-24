// Importamos las bibliotecas necesarias para gestionar archivos y obtener la ubicación de los archivos en el dispositivo.
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Clase auxiliar para gestionar el almacenamiento local de las notas.
class StorageHelper {
  
  // Obtenemos la ruta local donde guardaremos el archivo de notas.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Obtenemos el archivo local que contendrá nuestras notas.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  // Leemos las notas del almacenamiento local.
  Future<List<String>> readNotes() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents.split('\n')..removeLast(); // Removemos la última línea si está vacía para evitar elementos vacíos en la lista.
    } catch (e) {
      // Si hay un error, retornamos una lista vacía.
      return [];
    }
  }

  // Escribimos las notas al almacenamiento local.
  Future<void> writeNotes(List<String> notes) async {
    final file = await _localFile;
    await file.writeAsString('${notes.join('\n')}\n');
  }
}
