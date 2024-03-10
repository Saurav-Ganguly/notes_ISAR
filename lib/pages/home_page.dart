import 'package:flutter/material.dart';
import 'package:notes_isar/models/note.dart';
import 'package:notes_isar/models/note_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final noteTextController = TextEditingController();

  // C R E A T E
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: noteTextController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              var noteText = noteTextController.text;
              if (noteText.isNotEmpty) {
                context.read<NoteDatabase>().addNote(noteText);
                noteTextController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }

  // R E A D
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // U P D A T E
  void editNote(int id, String noteText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: noteTextController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              var noteText = noteTextController.text;
              if (noteText.isNotEmpty) {
                context.read<NoteDatabase>().updateNote(id, noteText);
                noteTextController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Edit Note'),
          ),
        ],
      ),
    );
  }

  // D E L E T E
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  // initialize the app
  @override
  void initState() {
    readNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // notes database
    final notesDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = notesDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(currentNotes[index].text),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => editNote(
                  currentNotes[index].id,
                  currentNotes[index].text,
                ),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure you wanna delete?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            deleteNote(currentNotes[index].id);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
