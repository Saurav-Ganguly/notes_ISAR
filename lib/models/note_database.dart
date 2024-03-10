import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_isar/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  //list of notes at current time
  final List<Note> currentNotes = [];

  // C R E A T E
  Future<void> addNote(String text) async {
    //create a new note object
    final newNote = Note()..text = text;
    // --------------------------------------
    //this line is equaivalent to
    //final newNote = Note();
    //newNote.text = text;
    // ---------------------------------------

    //write into the db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //re-read from the db to update the changes
    fetchNotes();
  }

  // R E A D
  Future<void> fetchNotes() async {
    //gets all the notes from the db
    List<Note> fetchedNotes = await isar.notes.where().findAll();

    //add the fetched notes into the current notes list
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);

    //notify listners
    notifyListeners();
  }

  // U P D A T E
  Future<void> updateNote(int id, String newText) async {
    //find the note that you wanna update
    final existingNote = await isar.notes.get(id);
    //check if the note of the given id exists
    if (existingNote != null) {
      //update the text
      existingNote.text = newText;
      //put it back in db
      await isar.writeTxn(() => isar.notes.put(existingNote));
      //re-read everything
      await fetchNotes();
    }
  }

  // D E L E T E
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    //re-read everything
    await fetchNotes();
  }
}
