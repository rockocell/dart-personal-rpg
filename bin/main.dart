import 'package:pp_rpg_game/game.dart';

void main() async {
  Game game = Game();
  await game.makePlayerChar();
  await game.makeMonList();

  ///character.dart 내에서 game을 사용하기 위해 호출
  game.player.setGame(game);

  ///if 문으로 게임 시작 조건(characdters, monsters파일이 정상적으로 읽혔는지) 확인
  ///true일 때만 게임 시작, false인 경우 멘트 출력 후 게임 종료
  if (game.charIsValid && game.monIsValid) {
    game.player.getName();
    game.randomAdditionalHp();
    game.startGame();
  } else {
    print('게임 진행에 필요한 파일을 불러오지 못했습니다.');
    print('게임을 종료합니다.');
  }
}
