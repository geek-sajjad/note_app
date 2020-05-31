import 'package:flutter/material.dart';
import 'package:note/models/note.dart';
import 'package:note/provider/note_provider.dart';
import 'package:note/screens/home_screen.dart';

import 'package:note/services/database_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() { 
    super.initState();

    _splashLoadData();
  }
  Future<void> _splashLoadData() async {
    debugPrint("loading notes");
    await Provider.of<NoteProvider>(context, listen: false).loadNotes();
    // debugPrint("printing notes");
    // Provider.of<NoteProvider>(context, listen: false).notes.forEach((n) => print(n.id));
    // await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => HomeScreen(
                  title: 'home screen',
                )));
  }
  add() async{
    DatabaseHelper db = DatabaseHelper.instance;
    Note note = Note(
      body: "body text ",
      // id: '2',
      title: 'title '
    );
    
    
    // print(await db.insert(note));
    
    
    // print(await db.clear());


    print(await db.getNotes());

    // print(await db.getNote(id: 1));


    // print(await db.updateNote(title: "Updated title", body : "Updated body" , id: 1));

    // print(await db.deleteNote(1));
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text("Splash Screen ...", style: TextStyle(fontSize: 24))),
    );
    // return Scaffold(
    //   body: Center(child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //     RaisedButton(onPressed: add , child:Text("add")),
    //   ],),),
    // );
  }
}
