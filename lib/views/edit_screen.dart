// Importamos los paquetes y archivos necesarios para la pantalla de edición.
import 'package:flutter/material.dart';
import '../bloc/note_bloc.dart';

// Definición de la clase `EditScreen`, que es un `StatefulWidget`. Esta pantalla permite crear o editar notas.
class EditScreen extends StatefulWidget {
  // Propiedad opcional para la nota. Si se pasa, significa que estamos editando una nota existente.
  final String? note;
  // Instancia del BLoC para manejar el estado de las notas. Este BLoC se encarga del "Manejo de estados".
  final NoteBloc bloc;

  // Constructor que recibe opcionalmente una nota y siempre el BLoC asociado.
  const EditScreen({super.key, this.note, required this.bloc});

  // Crea el estado asociado a este widget.
  @override
  _EditScreenState createState() => _EditScreenState();
}

// Definición del estado `_EditScreenState` asociado al widget `EditScreen`.
class _EditScreenState extends State<EditScreen> {
  // Controlador para el campo de texto donde el usuario escribe la nota.
  TextEditingController? _controller;

  // Se invoca cuando este estado es creado.
  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador con el texto de la nota si estamos editando una existente.
    _controller = TextEditingController(text: widget.note);
  }

  // Define la parte visual del widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Si estamos editando una nota, la actualizamos. Si no, añadimos una nueva.
              if (widget.note != null) {
                widget.bloc.noteEvent.add(UpdateNote(widget.note!, _controller!.text));
              } else {
                widget.bloc.noteEvent.add(AddNote(_controller!.text));
              }
              // Regresamos a la pantalla anterior después de guardar.
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Campo de texto donde se escribe o edita la nota.
        child: TextField(
          controller: _controller,
          maxLines: null, // Permite múltiples líneas.
          expands: true,  // El campo de texto se expandirá tanto como sea posible.
          decoration: const InputDecoration(
            hintText: 'Escribe tu nota...',
          ),
        ),
      ),
    );
  }

  // Antes de que el estado sea destruido, eliminamos el controlador para evitar fugas de memoria.
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
