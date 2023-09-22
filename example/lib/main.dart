import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paulonia_document_service/paulonia_document_service.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getDoc() {
    final docRef = db.collection("test").doc("test_1");
    return PauloniaDocumentService.getDoc(docRef, false);
  }

  Future<QuerySnapshot?> getAll() {
    return PauloniaDocumentService.getAll(db.collection("test"), false);
  }

  Future<QuerySnapshot?> runQuery() {
    final query = db.collection("test").where("value", isEqualTo: "test_2");
    return PauloniaDocumentService.runQuery(query, false);
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<DocumentSnapshot?>(future: getDoc(), builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data == null) {
                  return const Text("null!!");
                }
                return Text(snap.data!.get("value"));
              }
              else if  (snap.hasError) {
                print(snap.error);
                return Text("Error");
              }
              return const Text("Loading");
            }),
            FutureBuilder<QuerySnapshot?>(future: getAll(), builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data == null) {
                  return const Text("null!!");
                }
                List<Widget> children = [];
                for (DocumentSnapshot doc in snap.data!.docs) {
                  children.add(Text(doc.get("value")));
                }
                return Column(
                  children: children,
                );
              }
              return const Text("Loading");
            }),
            FutureBuilder<QuerySnapshot?>(future: runQuery(), builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data == null) {
                  return const Text("null!!");
                }
                List<Widget> children = [];
                for (DocumentSnapshot doc in snap.data!.docs) {
                  children.add(Text(doc.get("value")));
                }
                return Column(
                  children: children,
                );
              }
              return const Text("Loading");
            }),
          ],
        ),
      ),
    );
  }
}
