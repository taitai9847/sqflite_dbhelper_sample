import 'package:flutter/material.dart';
import 'package:sqflite_sample/models/sample.dart';

import 'db/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;


  Future createSample() async {
    final sample = Sample(title: "test1");
    await dbHelper.create(sample);
    print('create sample!');
  }

  Future readSample() async {
    //追加した"test1"のindexは1なので、readの引数には1を指定してあげる
    final Sample sample = await dbHelper.read(1);
    print(sample.title);
    print('read sample!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: createSample, child: Text("create")),
            ElevatedButton(onPressed: readSample, child: Text("read")),
          ],
        ),
      ),
    );
  }
}
