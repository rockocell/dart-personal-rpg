import 'dart:io';
import 'dart:convert';
import 'package:pp_rpg_game/game.dart';

void main() async {
  Game game = Game();

  game.startGame();

  while (game.isStart == true) {
    ///플레이어, 몬스터 리스트 생성
    await game.makePlayerChar();
    await game.makeMonList();

    ///캐릭터 이름 입력
    ///올바른 형식으로 입력될 때까지 반복
    while (true) {
      print('캐릭터의 이름을 입력하세요: ');
      var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

      ///정규표현식으로 사용자 이름이 적절한지 확인
      if (input != null) {
        RegExp pattern = RegExp(r'^[가-힣a-zA-Z\s]+$');
        bool isValid = pattern.hasMatch(input);
        if (isValid == true) {
          game.player.name = input;
          break;
        } else {
          print('캐릭터 이름 형식이 올바르지 않습니다.');
          print('영어 소문자, 영어 대문자, 한글, 공백만 입력 가능합니다.');
          continue;
        }
      }
    }
    print('게임을 시작합니다!');
    print(
      '${game.player.name} - 체력: ${game.player.hp}, 공격력: ${game.player.atk}, 방어력: ${game.player.def}',
    );
    game.getRandomMonster();
    game.player.attackMonster(game.currentMon);
    print('게임을 종료합니다!');
    game.isStart = false;
  }
}
