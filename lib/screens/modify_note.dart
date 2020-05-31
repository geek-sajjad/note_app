import 'package:flutter/material.dart';
import 'package:note/models/note.dart';
import 'package:note/provider/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ModifyNote extends StatefulWidget {
  // final int id;
  final Note note;
  const ModifyNote({Key key, this.note}) : super(key: key);

  @override
  _ModifyNoteState createState() => _ModifyNoteState();
}

class _ModifyNoteState extends State<ModifyNote> {
  bool get isNoteAvailble => widget.note != null;
  final _bodyEditingController = TextEditingController();
  final _titleEditingController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _bodyFocusNode = FocusNode();
  @override
  void initState() {
    if (isNoteAvailble) {
      // var note =
      //     Provider.of<NoteProvider>(context, listen: false).findNote(widget.id);
      _bodyEditingController.text = widget.note.body;
      _titleEditingController.text = widget.note.title;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _bodyEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: _onBackButtonPrresed,
          ),
          actions: <Widget>[
            if (isNoteAvailble)
              IconButton(
                onPressed: _deleteNote,
                icon: Icon(Icons.delete),
              )
            // isIdAvailble == true
            //     ? IconButton(
            //         onPressed: null,
            //         icon: Icon(Icons.delete),
            //       )
            //     : Container(),
          ],
          title: Text(isNoteAvailble ? "Edit note" : "Create new Note"),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    focusNode: _titleFocusNode,
                    controller: _titleEditingController,
                    decoration: InputDecoration(
                        labelText: "Title", border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    focusNode: _bodyFocusNode,
                    minLines: 5,
                    maxLines: 15,
                    controller: _bodyEditingController,
                    decoration: InputDecoration(
                        labelText: "Text", border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (!_validate()) return;

                          saveOrAddNote();
                        },
                        child: Text(
                          isNoteAvailble ? "Save" : "Add",
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  _addNote() {
    String title = _titleEditingController.text.toString();
    String body = _bodyEditingController.text.toString();

    Provider.of<NoteProvider>(context, listen: false)
        .addNote(body: body, title: title);
  }

  _updateNote() {
    assert(isNoteAvailble == true);
    String title = _titleEditingController.text.toString();
    String body = _bodyEditingController.text.toString();

    Provider.of<NoteProvider>(context, listen: false)
        .editNote(id: widget.note.id, body: body, title: title);
  }

  saveOrAddNote() {
    if (isNoteAvailble) {
      _updateNote();
    } else {
      _addNote();
    }
    Navigator.pop(context);
  }

  bool _validate() {
    if (_titleEditingController.text.isEmpty) {
      _titleFocusNode.requestFocus();
    } else if (_bodyEditingController.text.isEmpty) {
      _bodyFocusNode.requestFocus();
    } else {
      return true;
    }
    return false;
  }

  _onBackButtonPrresed() async {
    if (_bodyEditingController.text.isEmpty &&
        _titleEditingController.text.isEmpty) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
          ],
          title: Text("Are you sure do you wanna exit without save?"),
        ),
      ).then((v) {
        if (v != null && v) Navigator.pop(context);
      });
    }
  }

  void _deleteNote() {
    assert(widget.note != null);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("do you wanna delete ?"),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes"),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"),
                ),
              ],
            )).then((v) {
      if (v != null && v) {
        Provider.of<NoteProvider>(context, listen: false).deleteNote(widget.note.id);
        Navigator.pop(context);
      }
    });
  }
}
