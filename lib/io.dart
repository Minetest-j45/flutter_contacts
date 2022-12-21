import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Contacts {
  Future<List<Contact>> read() async {
    var string = await Storage().readText();
    if (string.isEmpty) {
      string = '{"contacts":[]}';
    }
    //final json = jsonDecode('{"contacts": [ {"name": "Bob", "key": "123"}, {"name": "John", "key": "abc"}]}');
    final json = jsonDecode(string);

    List<Contact> contacts = [];
    for (var cont in json['contacts']) {
      contacts.add(Contact(name: cont['name'], key: cont['key']));
    }

    return contacts;
  }

  void write(contacts) {  
    final json = jsonEncode({
      'contacts': contacts.map((contact) => {
        'name': contact.name,
        'key': contact.key,
      }).toList(),
    });

    print(json);
    writeJson(json);
  }

  void writeJson(json) async {
    await Storage().writeText(json);
  }

  void addConctact(Contact contact) async {
    var contacts = await read();
    contacts.add(contact);
    write(contacts);
  }
}

class Contact {
  String name;
  String key;

  Contact({required this.name, required this.key});
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contacts.json');
  }

  Future<File> writeText(String text) async {
    final file = await _localFile;

    return file.writeAsString(text);
  }

  Future<String> readText() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }
}