import 'package:pp_rpg_game/character.dart';

class Monster {
  String name;
  int hp;
  int maxAtk;
  int atk = 0;
  int def = 0;

  Monster(this.name, this.hp, this.maxAtk);

  void attackCharacter(Character character) {
    character.hp = character.hp - atk;
  }
}
