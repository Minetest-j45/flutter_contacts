import 'package:flutter/material.dart';
import 'io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Contacts List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Contacts List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          const Text('Contacts:'),
            FutureBuilder(
                future: _contactList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return const CircularProgressIndicator();
                },
            ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Contacts().addConctact(Contact(name: 'Bob', key: '123'));
                setState(() {});
              }
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _contactList() async {
    /*const testJson = """
  {
    "contacts": [
      {
        "name": "John Doe",
        "key": "1234567890"
      },
      {
        "name": "Jane Doe",
        "key": "0987654321"
      }
    ]
  }
  """;

  Contacts().write(testJson);*/

    List<Contact> conts = await Contacts().read();
    return ListView.builder(
      itemCount: conts.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(conts[index].name),
          subtitle: Text(conts[index].key),
        );
      },
    );
  }
}