import 'package:flutter/material.dart';
import 'package:note/provider/note_provider.dart';
import 'package:note/screens/modify_note.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context, listen: false).notes;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ModifyNote()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        // Here we take the value from the HomeScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.separated(
          itemBuilder: (_, i) {
            return ListTile(
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (_) => ModifyNote(
                          note: notes[i],
                        ));
                Navigator.push(context, route);
              },
              leading: CircleAvatar(
                child: Text("${i + 1}"),
              ),
              title: Text(notes[i].title),
            );
          },
          separatorBuilder: (_, __) {
            return Divider();
          },
          // itemCount: _notes.length),
          itemCount: notes.length),
    );
  }
}
