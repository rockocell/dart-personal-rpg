import 'package:pp_rpg_game/game.dart';

void main() async {
  Game game = Game();

  game.startGame();

  while (game.isStart == true) {
    print('게임을 시작합니다!');
    await game.makePlayerChar();
    await game.makeMonList();
    print('게임을 종료합니다!');
    game.isStart = false;
  }
}
