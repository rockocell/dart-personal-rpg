import 'package:pp_rpg_game/game.dart';

void main() async {
  Game game = Game();
  await game.makePlayerChar();
  await game.makeMonList();
  game.player.getName();
  game.startGame();
}
