import 'package:flutter/material.dart';
import '../models/note.dart';
import '../controllers/note_controller.dart';
import 'note_edit.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final NoteController _noteController = NoteController();
  late Future<List<Note>> _notes;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notes = _noteController.readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notes', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Search by title',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _notes = _noteController.readAll();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _notes = _noteController.searchNotes(value);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Note>>(
              future: _notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Notes'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final note = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          title: Text(
                            note.title,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            note.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap: () async {
                            final updatedNote = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteEdit(note: note),
                              ),
                            );
                            if (updatedNote != null) {
                              setState(() {
                                _notes = _noteController.readAll();
                              });
                            }
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _noteController.delete(note.id!).then((_) {
                                setState(() {
                                  _notes = _noteController.readAll();
                                });
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEdit(
                  note: Note(
                title: '',
                content: '',
              )),
            ),
          );
          if (newNote != null) {
            setState(() {
              _notes = _noteController.readAll();
            });
          }
        },
      ),
    );
  }
}
