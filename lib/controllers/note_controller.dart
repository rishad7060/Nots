import 'package:notes/helpers/note_database.dart';
import 'package:notes/models/note.dart';

class NoteController {
  Future<Note> create(Note note) async {
    return await NoteDatabase.instance.create(note);
  }

  Future<Note?> read(int id) async {
    return await NoteDatabase.instance.read(id);
  }

  Future<List<Note>> readAll() async {
    return await NoteDatabase.instance.readAll();
  }

  Future<int> update(Note note) async {
    return await NoteDatabase.instance.update(note);
  }

  Future<int> delete(int id) async {
    return await NoteDatabase.instance.delete(id);
  }

  Future<List<Note>> searchNotes(String query) async {
    final notes = await readAll();
    return notes
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
