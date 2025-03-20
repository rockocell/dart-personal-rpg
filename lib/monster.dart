import 'package:pp_rpg_game/character.dart';

class Monster {
  String name;
  int hp;
  int maxAtk;
  int atk = 0;
  int def = 0;
  int countForMonDef = 1;

  Monster(this.name, this.hp, this.maxAtk);

  void attackChar(Character character) {
    int damage = atk - character.def;
    print('$name의 턴');
    if (countForMonDef == 3) {
      def += 2;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $def');
      countForMonDef = 1;
    }
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
