import 'package:pp_rpg_game/monster.dart';

class Character {
  ///캐릭터의 기본값
  String name;
  int hp;
  int atk;
  int def;

  Character(this.name, this.hp, this.atk, this.def);

  void attackMonster(Monster monster) {
    monster.hp = monster.hp - atk;
    print('몬스터가 $atk의 피해를 입었습니다! 몬스터 hp: ${monster.hp}');
  }

  /*
  void defend() {

  }
  */
}
