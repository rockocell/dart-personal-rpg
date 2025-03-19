import 'package:pp_rpg_game/monster.dart';

///캐릭터 상태를 enum으로 관리
enum CharStatus { idle, defend, dead }

class Character {
  String name;
  int hp;
  int atk;
  int def;

  ///캐릭터 기본 상태 = idle
  CharStatus currentStatus = CharStatus.idle;

  Character(this.name, this.hp, this.atk, this.def);

  void attackMon(Monster monster) {
    monster.hp = monster.hp - atk;
    print(
      '${monster.name}가 $atk의 피해를 입었습니다! ${monster.name} hp: ${monster.hp}',
    );
  }

  void defend() {
    print('$name은 ${'방어'}를 시전했다!');
  }
}
