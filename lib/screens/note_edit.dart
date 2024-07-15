import 'package:flutter/material.dart';
import '../models/note.dart';
import '../controllers/note_controller.dart';

class NoteEdit extends StatefulWidget {
  final Note note;

  const NoteEdit({super.key, required this.note});

  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  final NoteController _noteController = NoteController();
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.note.title;
    _content = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  initialValue: _content,
                  decoration: const InputDecoration(labelText: 'Content'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _content = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final note = Note(
                      id: widget.note.id,
                      title: _title,
                      content: _content,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    if (note.id == null) {
                      _noteController.create(note).then((_) {
                        Navigator.pop(context, note);
                      });
                    } else {
                      _noteController.update(note).then((_) {
                        Navigator.pop(context, note);
                      });
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
