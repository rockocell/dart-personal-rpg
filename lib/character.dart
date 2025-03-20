import 'dart:io';
import 'dart:convert';
import 'package:pp_rpg_game/monster.dart';
import 'package:pp_rpg_game/game.dart';

class Character {
  String name;
  int hp;
  int atk;
  int def;

  //Game 객체 불러오기 -- 기본 : null
  Game? game;

  Character(this.name, this.hp, this.atk, this.def);

  bool isItemUsed = false;

  ///외부에서 생성된 Game 객체를 set 해주는 메서드
  void setGame(Game gameInstance) {
    game = gameInstance;
  }

  void getName() {
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
          name = input;
          break;
        } else {
          print('캐릭터 이름 형식이 올바르지 않습니다.');
          print('영어 소문자, 영어 대문자, 한글, 공백만 입력 가능합니다.');
          continue;
        }
      }
    }
  }

  void attackMon(Monster monster) {
    if (game == null) {
      print('오류: Game 인스턴스가 설정되지 않았습니다.');
      return;
    }

    ///현재 turnCount가 atkDoubleTurn과 동일하면 공격력 두 배 적용
    if (game!.turnCount == game!.atkDoubleTurn) {
      monster.hp = monster.hp - atk * 2;
      print('아이템 효과 : 두 배의 공격력이 적용됩니다! 현재 공격력 : ${atk * 2}');
      print('$name(이)가 ${monster.name}에게 ${atk * 2}의 피해를 입혔습니다!');
    } else {
      monster.hp = monster.hp - atk;
      print('$name(이)가 ${monster.name}에게 $atk의 피해를 입혔습니다!');
    }
  }

  void defend() async {
    print('$name(이)가 방어 태세를 취했습니다.');
  }

  void showStatus() {
    print('$name - 체력 : $hp, 공격력 : $atk, 방어력 : $def');
  }

  checkIsDead() {
    if (hp <= 0) {
      hp = 0;
      return true;
    } else {
      return false;
    }
  }
}
