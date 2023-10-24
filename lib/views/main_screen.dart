// Importa los paquetes y archivos necesarios para esta pantalla.
import 'package:flutter/material.dart';
import '../bloc/note_bloc.dart';
import '../utils/storage_helper.dart';
import 'edit_screen.dart';

// Definición de la clase `MainScreen`, que es un `StatefulWidget`. Pantalla principal
class MainScreen extends StatefulWidget {
  // `ValueNotifier` que escucha cambios en el tema (claro/oscuro).
  final ValueNotifier<bool> themeNotifier;

  // Constructor de `MainScreen` que recibe un `themeNotifier`.
  const MainScreen({Key? key, required this.themeNotifier}) : super(key: key);

  // Crea el estado asociado con este widget.
  @override
  _MainScreenState createState() => _MainScreenState();
}

// Definición del estado `_MainScreenState` asociado con el widget `MainScreen`.
class _MainScreenState extends State<MainScreen> {
  // Instancia del BLoC para manejar el estado de las notas. Este BLoC se encarga del "Manejo de estados".
  final _bloc = NoteBloc();
  // Instancia de `StorageHelper` para interactuar con el almacenamiento local. Se refiere al punto "Storage".
  final _storageHelper = StorageHelper();

  // Se invoca cuando se crea este estado.
  @override
  void initState() {
    super.initState();
    // Carga las notas previamente almacenadas.
    _loadNotes();
  }

  // Método para cargar notas del almacenamiento local y agregarlas al BLoC.
  _loadNotes() async {
    List<String> storedNotes = await _storageHelper.readNotes();
    for (var note in storedNotes) {
      _bloc.noteEvent.add(AddNote(note));
    }
  }

  // Método auxiliar para truncar el texto de las notas si son muy largas.
  String _truncateText(String text, [int length = 95]) {
    return (text.length > length) ? '${text.substring(0, length)}…' : text;
  }

  // Define la parte visual del widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc de Notas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            // Al presionar este botón, se cambia el valor del `themeNotifier`, alternando entre tema claro y oscuro.
            onPressed: () {
              widget.themeNotifier.value = !widget.themeNotifier.value;
            },
          )
        ],
      ),
      // Usamos un StreamBuilder para escuchar cambios en el BLoC y reconstruir la lista de notas.
      body: StreamBuilder<NoteState>(
        stream: _bloc.noteState,
        initialData: NoteState([]),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.notes.length,
            itemBuilder: (context, index) {
              String note = snapshot.data!.notes[index];
              return Dismissible(
                key: ValueKey(note),
                onDismissed: (direction) {
                  // Al deslizar una nota, la eliminamos usando el BLoC.
                  _bloc.noteEvent.add(DeleteNote(note));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nota eliminada')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(_truncateText(note)),
                  onTap: () {
                    // Al tocar una nota, navegamos a la "Pantalla de edición".
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(note: note, bloc: _bloc),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // Botón flotante que nos lleva a la "Pantalla de edición" para agregar una nueva nota.
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditScreen(bloc: _bloc)),
          );
        },
      ),
    );
  }

  // Antes de que el estado sea destruido, eliminamos la instancia del BLoC para evitar fugas de memoria.
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
