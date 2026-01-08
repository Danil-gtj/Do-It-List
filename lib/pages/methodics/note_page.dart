import 'package:doit_list/StyleClasses/main_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String _userToDo = "";
  bool _isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _isFirebaseInitialized = true;
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
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
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
                        .collection('items')
                        .doc(document.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Element was deleted')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete Error: $e')),
                    );
                    setState(() {});
                  }
                },
                child: Card(
                  color: MainColors.buttonBackgroundColor_alpha,
                  child: ListTile(
                    title: Text(data['item'] ?? '', style: TextStyle(color: MainColors.textColor, fontSize: 18),),
                    trailing: IconButton(
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('items')
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
                title: Text("ADD ELEMENT", style: TextStyle(color: MainColors.textColor),),
                backgroundColor: MainColors.buttonBackgroundColor_beta,
                content: TextField(
                  onChanged: (String value) {
                    _userToDo = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'ENTER TASK',
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
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColors.buttonBackgroundColor_alpha,
                    ),
                    onPressed: () {
                      if (_userToDo.trim().isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection("items")
                            .add({"item": _userToDo});
                        Navigator.of(context).pop();
                      }
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
}