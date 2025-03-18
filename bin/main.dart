import 'dart:io';
import 'package:pp_rpg_game/character.dart';
import 'package:pp_rpg_game/monster.dart';
import 'package:pp_rpg_game/game.dart';

void main() async {
  ///캐릭터, 몬스터리스트 default값 생성
  List<Monster> monList = [];
  Game game = Game();

  game.startGame();

  while (game.isStart == true) {
    print('게임을 시작합니다!');
    print('게임을 종료합니다!');
    game.isStart = false;
  }
}
