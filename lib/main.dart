import 'package:flutter/material.dart';

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

  List<String> ourToDo = [];

  _MyHomePageState() {
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do'),
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: ourToDo.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text("${index + 1}"),
                        ),
                        title: Text(ourToDo[index]),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              ourToDo.removeAt(index);
                            });
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  })),
          Padding(
            padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 30),
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
                        : () {
                            setState(() {
                              ourToDo.add(_controller.text);
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
}
