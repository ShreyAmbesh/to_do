import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  bool hasFirebase = false;

  _MyHomePageState() {
    Firebase.initializeApp().then((value) {
      setState(() {
        hasFirebase = true;
      });
    });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
              child: hasFirebase
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('todo')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text("${index + 1}"),
                                    ),
                                    title: Text(
                                        snapshot.data?.docs[index]['data']),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          FirebaseFirestore.instance
                                              .collection('todo')
                                              .doc(
                                                  snapshot.data?.docs[index].id)
                                              .delete();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  : Center(child: CircularProgressIndicator())),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 30),
            child: Row(
              children: [
                Flexible(
                    child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16))),
                )),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                    onPressed: _controller.text == ''
                        ? null
                        : () async {
                            bool result = await addTodo(_controller.text);
                            if (result) {
                              print('SUCCESS');
                            } else {
                              print('FAILURE');
                            }
                            setState(() {
                              _controller.text = '';
                            });
                          },
                    child: Text('Add'))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> addTodo(String data) async {
    CollectionReference todo = FirebaseFirestore.instance.collection('todo');
    try {
      DocumentReference doc = await todo.add({"data": data});
      if (doc != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
