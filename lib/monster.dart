import 'package:pp_rpg_game/character.dart';

class Monster {
  String name;
  int hp;
  int maxAtk;
  int atk = 0;
  int def = 0;

  Monster(this.name, this.hp, this.maxAtk);

  void attackChar(Character character) async {
    int damage = atk - character.def;
    print('$name의 턴');
    print('$name이 ${character.name}을 공격했습니다!');
    character.hp = character.hp - damage;
    print(
      '${character.name}(이)가 $damage의 피해를 입었습니다! ${character.name} hp: ${character.hp}',
    );
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
