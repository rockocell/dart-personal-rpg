import 'package:pp_rpg_game/character.dart';

class Monster {
  String name;
  int hp;
  int maxAtk;
  int atk = 0;
  int def = 0;
  int monTurnCount = 1;

  bool isDead = false;

  Monster(this.name, this.hp, this.maxAtk);

  ///몬스터의 한 턴
  void turnMonster(Character character) {
    ///플레이어 상태 체크
    character.checkPlayerStatus();

    ///몬스터 상태 체크
    checkMonsterStatus();
    attackChar(character);
    monTurnCount++;
  }

  void checkMonsterStatus() {
    ///몬스터 3번째 턴마다 방어력 증가
    if (monTurnCount == 3) {
      def += 2;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $def');
      monTurnCount = 1;
    }
  }

  void attackChar(Character character) {
    int damage = atk - character.def;
    if (damage < 0) damage = 0;
    print('$name의 턴');

    character.hp = character.hp - damage;
    print('$name(이)가 ${character.name}에게 $damage의 데미지를 입혔습니다!');
  }

  void showStatus() {
    print('$name - 체력 : $hp, 공격력 : $atk');
  }

  void checkIsDead() {
    if (hp <= 0) {
      hp = 0;
      isDead = true;
    }
  }
}
