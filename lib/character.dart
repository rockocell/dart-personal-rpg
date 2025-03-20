import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:pp_rpg_game/monster.dart';
import 'package:pp_rpg_game/game.dart';

class Character {
  String name;
  int hp;
  int atk;
  int def;
  bool isDead = false;

  //Game 객체 불러오기 -- 기본 : null
  Game? game;

  ///특수턴 관리
  int atkDoubleTurn = 0;
  int defDoubleTurn = 0;
  int initialAtk = 0;
  int initialDef = 0;

  Character(this.name, this.hp, this.atk, this.def);

  ///외부에서 생성된 Game 객체를 set 해주는 메서드
  void setGame(Game gameInstance) {
    game = gameInstance;
  }

  void getName() {
    ///캐릭터 이름 입력
    ///올바른 형식으로 입력될 때까지 반복
    while (true) {
      print('캐릭터의 이름을 입력하세요: ');
      var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

      ///정규표현식으로 사용자 이름이 적절한지 확인
      if (input != null) {
        RegExp pattern = RegExp(r'^[가-힣a-zA-Z\s]+$');
        bool isValid = pattern.hasMatch(input);
        if (isValid == true) {
          name = input;
          break;
        } else {
          print('캐릭터 이름 형식이 올바르지 않습니다.');
          print('영어 소문자, 영어 대문자, 한글, 공백만 입력 가능합니다.');
          continue;
        }
      }
    }
  }

  ///플레이어의 한 턴
  void turnPlayer() {
    checkPlayerStatus();
    executePlayerAction(() => getInputInt()); //입력에 따른 플레이어 액션 실행
    game!.totalTurnCount++;
  }

  ///플레이어 상태 체크 -- 공격력 증가, 방어력 증가 확인
  void checkPlayerStatus() {
    /// 공격력 아이템 사용하는 턴인지 체크
    if (game!.totalTurnCount == atkDoubleTurn) {
      if (initialAtk == 0) {
        // 원래 공격력 저장
        initialAtk = atk;
      }
      atk = initialAtk * 2;
    } else {
      if (initialAtk != 0) {
        // 원래 공격력 복구
        atk = initialAtk;
      }
    }

    ///방어력 증가한 턴인지 체크
    if (game!.totalTurnCount == defDoubleTurn) {
      if (initialDef == 0) {
        // 원래 방어력 저장
        initialDef = def;
      }
      def = initialDef * 2;
    } else {
      if (initialDef != 0) {
        // 원래 방어력 복구
        def = initialDef;
      }
    }
  }

  ///유저 입력 확인 -- return 값: 1 or 2 or 3 (int 타입)
  getInputInt() {
    while (true) {
      print('');
      print('$name의 턴');
      print('행동을 선택하세요: (1 : 공격, 2: 방어, 3: 아이템 사용)');
      var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);
      if (input == '1') {
        return 1;
      } else if (input == '2') {
        return 2;
      } else if (input == '3') {
        ///아이템이 이미 사용됐는지 확인
        if (game!.isItemUsed == false) {
          game!.isItemUsed = true;
          return 3;
        } else {
          print('아이템이 이미 사용되었습니다!');
          continue;
        }
      } else {
        print('입력형식이 올바르지 않습니다.');
        continue;
      }
    }
  }

  ///입력값에 따른 플레이어 액션 실행
  void executePlayerAction(int Function() getPlayer) {
    int input = getPlayer();
    if (game == null) {
      print('오류: Game 인스턴스가 설정되지 않았습니다.');
      return;
    }
    switch (input) {
      case 1:
        attackMon(game!.currentMon);
        break;
      case 2:
        defend();
        break;
      case 3:
        useItem();
        break;
    }
  }

  ///공격 액션
  void attackMon(Monster monster) {
    int damage = atk - monster.def;
    if (damage < 0) {
      damage = 0;
    } else if (damage > monster.hp) {
      damage = monster.hp;
    }

    ///현재 턴이 공격력 두 배 적용 턴이면 안내 메세지 출력
    if (game!.totalTurnCount == atkDoubleTurn) {
      print('');
      print('아이템 효과 : 두 배의 공격력이 적용됩니다! 현재 공격력 : $atk');
    }
    monster.hp = monster.hp - damage;
    print('$name(이)가 ${monster.name}에게 $damage의 피해를 입혔습니다!');
  }

  ///방어 액션
  void defend() {
    ///현재 totalTurnCount값을 defDoubleTurn에 넣음
    defDoubleTurn = game!.totalTurnCount + 1;
    print('$name(이)가 방어 태세를 취했습니다!');
    print('다음 턴에 방어력이 2배로 증가합니다.');
  }

  ///아이템 사용 액션
  void useItem() {
    ///현재 totalTurnCount값을 atkDoubleTurn에 넣음
    atkDoubleTurn = game!.totalTurnCount + 1;
    print('공격력 증가 아이템을 사용했습니다!');
    print('다음 턴에 공격력이 2배로 증가합니다.');
  }

  void showStatus() {
    print('');
    print('─' * 50);
    print('$name - 체력 : $hp, 공격력 : $atk, 방어력 : $def');
  }

  void checkIsDead() {
    if (hp <= 0) {
      isDead = true;
    }
  }

  void getInjured() {
    Random random = Random();
    int chance = random.nextInt(10);
    if (chance <= 0) {
      atk -= 2;
      print('');
      print('$name(이)가 부상당했습니다! 공격력이 2 감소했습니다. ( 공격력 : $atk)');
    }
  }
}
