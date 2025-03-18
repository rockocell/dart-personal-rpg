import 'dart:io';
import 'dart:convert';
import 'package:pp_rpg_game/character.dart';
import 'package:pp_rpg_game/monster.dart';

class Game {
  ///character 클래스 넣기
  List<Monster> monsters = [];
  int victory = 0;
  bool isStart = false;

  Character player = Character('name', 1, 1, 1);
  List<Monster> monList = [];

  void startGame() {
    isStart = true;

    ///while문으로 종료조건 넣기
    ///종료조건 충족 시 isStart false 변경, break;
  }

  ///파일에서 플레이어 정보 가져오기
  Future<void> makePlayerChar() async {
    try {
      ///캐릭터 파일 불러오기
      var charFile = File('assets/characters.csv');

      ///파일 내부 정보를 리스트화
      List<String> charInfo = (await charFile.readAsString()).split(',');
      player = Character(
        'name',
        int.parse(charInfo[0]),
        int.parse(charInfo[1]),
        int.parse(charInfo[2]),
      );

      ///플레이어 기본정보 적용 완료
    } catch (e) {
      print('Error: $e');
    }
    print('${player.hp}, ${player.atk}, ${player.def}');
  }

  ///파일에서 몬스터 정보 가져와 리스트화
  Future<void> makeMonList() async {
    try {
      ///몬스터 파일 불러오기
      var monFile = File('assets/monsters.csv');

      ///파일 내부 정보 리스트화
      Stream<String> lines = monFile
          .openRead()
          .transform(utf8.decoder)
          .transform(LineSplitter());
      await for (var line in lines) {
        List<String> monInfo = line.split(',');
        Monster monster = Monster(
          monInfo[0],
          int.parse(monInfo[1]),
          int.parse(monInfo[2]),
        );
        monList.add(monster);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
