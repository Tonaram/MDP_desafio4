// Importaciones necesarias para gestionar el flujo de datos asíncrono y el almacenamiento local.
import 'dart:async';
import '../utils/storage_helper.dart';

// --- Definición de eventos ---

// Definimos un evento base llamado `NoteEvent`.
abstract class NoteEvent {}

// Evento para añadir una nota.
class AddNote extends NoteEvent {
  final String note;
  AddNote(this.note);
}

// Evento para actualizar una nota.
class UpdateNote extends NoteEvent {
  final String oldNote;
  final String newNote;
  UpdateNote(this.oldNote, this.newNote);
}

// Evento para eliminar una nota.
class DeleteNote extends NoteEvent {
  final String note;
  DeleteNote(this.note);
}

// --- Definición de estados ---

// Define el estado de las notas, que es simplemente una lista de notas.
class NoteState {
  final List<String> notes;
  NoteState(this.notes);
}

// Definimos el BLoC para gestionar el estado de las notas.
class NoteBloc {
  // Controladores para gestionar el flujo de estados y eventos.
  final _noteStateController = StreamController<NoteState>.broadcast();
  final _noteEventController = StreamController<NoteEvent>();
  // Instancia del ayudante de almacenamiento. Está relacionado con el punto "Storage" de los requerimientos.
  final _storageHelper = StorageHelper();

  // Stream para exponer el estado actual de las notas.
  Stream<NoteState> get noteState => _noteStateController.stream;

  // Sink para introducir eventos en el BLoC.
  Sink<NoteEvent> get noteEvent => _noteEventController.sink;

  // Lista inicial de notas.
  final List<String> _notes = [];

  NoteBloc() {
    // Escuchamos los eventos y los mapeamos a cambios de estado.
    _noteEventController.stream.listen(_mapEventToState);
    // Cada vez que hay un cambio en el estado, lo guardamos en el almacenamiento local.
    noteState.listen(_onNewState);  
  }

  // Función que toma un evento y actualiza el estado en consecuencia.
  void _mapEventToState(NoteEvent event) {
    if (event is AddNote) {
      _notes.add(event.note);
    } else if (event is UpdateNote) {
      int index = _notes.indexOf(event.oldNote);
      if (index != -1) {
        _notes[index] = event.newNote;
      }
    } else if (event is DeleteNote) {
      _notes.remove(event.note);
    }

    // Emitimos el nuevo estado.
    _noteStateController.sink.add(NoteState(_notes));
  }

  // Guardamos el estado en el almacenamiento cada vez que cambie.
  void _onNewState(NoteState state) async {
    await _storageHelper.writeNotes(state.notes);
  }

  // Cerramos los controladores cuando ya no se necesiten para evitar fugas de memoria.
  void dispose() {
    _noteStateController.close();
    _noteEventController.close();
  }
}
