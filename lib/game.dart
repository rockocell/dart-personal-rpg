import 'dart:io';
import 'package:pp_rpg_game/character.dart';
import 'package:pp_rpg_game/monster.dart';
import 'package:pp_rpg_game/game.dart';

class Game {
  ///character 클래스 넣기
  List<Monster> monsters = [];
  int victory = 0;
  bool isStart = false;

  void startGame() {
    isStart = true;
  }

  ///파일에서 플레이어 정보 가져오기
  void makePlayerChar() async {
    try {
      ///캐릭터 파일 불러오기
      var charFile = File('assets/characters.csv');

      ///파일 내부 정보를 읽고 리스트화
      List<String> charInfo = (await charFile.readAsString()).split(',');
      Character player = Character(
        'name',
        int.parse(charInfo[0]),
        int.parse(charInfo[1]),
        int.parse(charInfo[2]),
      );
      print('${player.hp}, ${player.atk}, ${player.def}');

      ///플레이어 기본정보 적용 완료
    } catch (e) {
      print('Error: $e');
    }
  }
}
