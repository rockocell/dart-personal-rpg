import 'package:pp_rpg_game/character.dart';

class Monster {
  String name;
  int hp;
  int maxAtk;
  int atk = 0;
  int def = 0;

  Monster(this.name, this.hp, this.maxAtk);

  void attackChar(Character character) {
    CharStatus status = character.currentStatus;
    switch (status) {
      case CharStatus.idle:
        print('플레이어는 idle 상태입니다.');
        break;
      case CharStatus.defend:
        print('플레이어는 defend 상태입니다.');
        break;
      case CharStatus.dead:
        print('플레이어는 dead 상태입니다.');
        break;
    }
    // character.hp = character.hp - (atk - character.def);
    //   print(
    //     '${character.name}(이)가 ${atk - character.def}의 피해를 입었습니다! ${character.name} hp: ${character.hp}',
    //   );
  }
}
