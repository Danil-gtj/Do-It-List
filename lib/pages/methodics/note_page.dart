import 'package:doit_list/StyleClasses/main_style.dart';
import 'package:doit_list/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _isFirebaseInitialized = false;

  var titleController = TextEditingController();
  var descController = TextEditingController();

  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _isFirebaseInitialized = true;

    getNotes();
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: MainColors.backgroundColor,
          appBar: AppBar(title: Text("Menu", style: TextStyle(color: MainColors.titleTextColor, fontSize: 54)), centerTitle: true, backgroundColor: MainColors.buttonBackgroundColor_beta,),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColors.buttonBackgroundColor_beta,
                ),
                child: Text("ON MAIN PAGE", style: TextStyle(color: MainColors.titleTextColor),),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text("MAIN MENU", style: TextStyle(color: MainColors.textColor),),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isFirebaseInitialized) {
      return Scaffold(
        backgroundColor: MainColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Initialize Firebase...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MainColors.backgroundColor,
      appBar: AppBar(
        title: Text("NOTES", style: TextStyle(color: MainColors.titleTextColor)),
        backgroundColor: MainColors.appBarColor_alpha,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _menuOpen,
            icon: const Icon(Icons.menu_outlined),
            color: MainColors.appBarColor_beta,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('ERROR: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("NO NOTES", style: TextStyle(color: MainColors.textColor),));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return Dismissible(
                key: Key(document.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: MainColors.buttonBackgroundColor_alpha,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: MainColors.buttonBackgroundColor_beta),
                ),
                onDismissed: (direction) async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .doc(document.id)
                        .delete();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: Card(
                  color: MainColors.buttonBackgroundColor_alpha,
                  child: ListTile(
                    title: Text(data['title'],  style: TextStyle(color: MainColors.titleTextColor, fontSize: 24)),
                    subtitle: Text(data['desc'] ?? '', style: TextStyle(color: MainColors.textColor, fontSize: 18)),
                    trailing: IconButton(
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('notes')
                              .doc(document.id)
                              .delete();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      icon: Icon(Icons.delete, color: MainColors.buttonBackgroundColor_beta),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MainColors.buttonBackgroundColor_alpha,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("ADD NOTES", style: TextStyle(color: MainColors.textColor),),
                backgroundColor: MainColors.buttonBackgroundColor_beta,
                content: Column( children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Enter Title",
                    filled: true,
                    fillColor: MainColors.inputFieldFillColor,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  cursorColor: MainColors.inputFieldCursorColor,
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Enter Descritption",
                    filled: true,
                    fillColor: MainColors.inputFieldFillColor,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  cursorColor: MainColors.inputFieldCursorColor,
                ),
                ]),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColors.buttonBackgroundColor_alpha,
                    ),
                    onPressed: () async {
                      String title = titleController.text.trim();
                      String desc = descController.text.trim();
                      
                      await addNote(Note(title, desc), context);
                      Navigator.pop(context);
                    },
                    child: Text("ADD", style: TextStyle(color: MainColors.textColor),),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: MainColors.buttonBackgroundColor_beta),
      ),
    );
  }

  addNote(Note note, BuildContext context) async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("notes").doc(DateTime.now().toString()).set(
      Note.toMap(note)
    ).then((value)=> {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added successfully")))
    });

    setState(() {

    });
  }

  getNotes() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("notes").get();

    for(DocumentSnapshot doc in snapshot.docs){
      var noteData = doc.data() as Map<String, dynamic>;

      notes.add(Note.fromMap(noteData));

    }

    setState(() {

    });
  }
}