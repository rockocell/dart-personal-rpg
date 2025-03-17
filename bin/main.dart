import 'dart:io';
import 'dart:convert';

void main() async {
  var file = File('assets/monsters.csv');

  Stream<String> lines = file.openRead().transform(utf8.decoder);
  try {
    await for (var line in lines) {
      print('$line: ${line.length} characters');
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
}
