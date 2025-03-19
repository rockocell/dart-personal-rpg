import 'package:pp_rpg_game/character.dart';

class Monster {
  String name;
  int hp;
  int maxAtk;
  int atk = 0;
  int def = 0;

  Monster(this.name, this.hp, this.maxAtk);

  void attackChar(Character character) {
    int damage = atk - character.def;
    print('$name의 턴');
    character.hp = character.hp - damage;
    print('$name(이)가 ${character.name}에게 $damage의 데미지를 입혔습니다!');
  }

  void showStatus() {
    print('$name - 체력 : $hp, 공격력 : $atk');
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
