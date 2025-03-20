import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:pp_rpg_game/character.dart';
import 'package:pp_rpg_game/monster.dart';

class Game {
  List<Monster> monsters = [];
  int victory = 0;

  Character player = Character('name', 1, 1, 1);
  List<Monster> monList = [];

  ///게임 시작 조건 관리
  bool charIsValid = false;
  bool monIsValid = false;

  //게임의 상태 관리
  bool isStart = true;
  bool isEnd = false;
  bool isWin = false;

  bool isPlayerDead = false;

  ///게임 결과 관리
  String result = '';

  Monster currentMon = Monster('', 1, 1);

  ///게임 턴, 아이템 관리
  int totalTurnCount = 1;
  int atkDoubleTurn = 0;
  bool isItemUsed = false;
  int countForMonDef = 1;

  ///class 내부 변수 선언 끝
  ///
  ///
  ///
  ///필수기능 메서드 시작

  ///파일에서 플레이어 정보 가져오기
  Future<void> makePlayerChar() async {
    try {
      ///캐릭터 파일 불러오기
      var charFile = File('assets/characters.csv');

      ///파일 내부 정보를 리스트화
      List<String> charInfo = (await charFile.readAsString()).split(',');
      player = Character(
        'name',
        int.parse(charInfo[0]),
        int.parse(charInfo[1]),
        int.parse(charInfo[2]),
      );

      ///게임 시작 조건 -- characters 파일 읽어오기 true
      charIsValid = true;

      ///플레이어 기본정보 적용 완료
    } catch (e) {
      print('Error: $e');
    }
  }

  ///파일에서 몬스터 정보 가져와 리스트화
  Future<void> makeMonList() async {
    try {
      ///몬스터 파일 불러오기
      var monFile = File('assets/monsters.csv');

      ///파일 내부 정보 리스트화
      Stream<String> lines = monFile
          .openRead()
          .transform(utf8.decoder)
          .transform(LineSplitter());
      await for (var line in lines) {
        List<String> monInfo = line.split(',');
        Monster monster = Monster(
          monInfo[0],
          int.parse(monInfo[1]),
          int.parse(monInfo[2]),
        );

        ///몬스터 maxAtk 이용해서 랜덤 atk 설정하기
        ///
        Random random = Random();
        int atk = random.nextInt(monster.maxAtk - player.def + 1) + player.def;
        monster.atk = atk;

        monList.add(monster);
      }

      ///게임 시작 조건 -- monsters 파일 읽어오기 true
      monIsValid = true;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> startGame() async {
    while (true) {
      ///최종 승리까지 필요한 승리의 수
      final int requiredVictory = monList.length;

      ///최종 승리수를 채울 때까지 전투(battle()) 반복
      for (victory; victory <= requiredVictory;) {
        if (isEnd) break;
        getRandomMon();
        battle();
        if (isPlayerDead) break;

        ///최종 승리수를 채웠다면 isEnd, isWin 값 변경 후 break;
        if (victory == requiredVictory) {
          isEnd = true;
          isWin = true;
          break;
        }

        ///승리수가 부족하다면 다음 몬스터와의 대결 의사 물음
        while (true) {
          print('다음 몬스터와 대결하시겠습니까? ( y / n )');
          var input = stdin.readLineSync(
            encoding: Encoding.getByName('utf-8')!,
          );
          if (input == 'y') {
            ///계속 => 상단의 for문으로 돌아가 다시 battle()실행
            break;
          } else if (input == 'n') {
            ///중단, 종료 => 상단의 for문으로 돌아가 if(isEnd)에서 break;
            isEnd = true;
            break;
          } else {
            print('입력형식이 올바르지 않습니다.');
            continue;
          }
        }
      }
      endGame(isEnd, isWin); //두 개의 bool값에 따라 각각 다른 게임 종료 멘트 출력
      break;
    }
  }

  void checkAction() {
    while (true) {
      print('${player.name}의 턴');
      print('행동을 선택하세요: (1 : 공격, 2: 방어)');
      var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);
      if (input == '1') {
        player.attackMon(currentMon);
        break;
      } else if (input == '2') {
        player.defend();
        break;
      }
      ///캐릭터 아이템 사용 기능 추가
      else if (input == '3') {
        ///아이템이 이미 사용됐는지 확인
        if (!isItemUsed) {
          isItemUsed = true;

          ///다음 턴에서 공격력 2배 적용
          atkDoubleTurn = totalTurnCount + 1;
          print('공격력 증가 아이템을 사용했습니다!');
          print('다음 턴에 공격력이 2배로 증가합니다.');
          break;
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

  ///한 번의 전투를 구현하는 메서드
  ///
  void battle() async {
    while (true) {
      checkAction();
      totalTurnCount++; //플레이어의 입력 받아 공격/방어 실행
      ///몬스터 상태 체크 -- 몬스터가 죽었으면 리스트에서 제거, 승리 횟수 증가, break
      if (currentMon.checkIsDead()) {
        monList.remove(currentMon);
        victory++;
        break;
      } else {
        //몬스터 살았으면 몬스터 턴
        currentMon.attackChar(player);
      }

      ///플레이어 상태 체크 -- 플레이어가 죽었으면 isDead 관리, break
      if (player.checkIsDead()) {
        isPlayerDead = true;
        break;
      }

      ///showStatus로 턴 결과 출력
      player.showStatus();
      currentMon.showStatus();
    }
  }

  void getRandomMon() {
    print('새로운 몬스터가 나타났습니다!');
    int currentMonIndex = Random().nextInt(monList.length);
    currentMon = monList[currentMonIndex];
    print('${currentMon.name} - 체력: ${currentMon.hp}, 공격력: ${currentMon.atk}');
  }

  void endGame(isEnd, isWin) {
    if (isEnd) {
      if (isWin) {
        result = '승리';
        print('축하합니다! 게임에서 승리했습니다.');
      } else {
        result = '패배';
        print('패배했습니다.');
      }

      ///결과 저장 확인
      while (true) {
        print('결과를 저장하시겠습니까? ( y / n )');
        var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);
        if (input == 'y') {
          saveResult();
          break;
        } else if (input == 'n') {
          print('저장하지 않습니다.');
          break;
        } else {
          print('입력형식이 올바르지 않습니다.');
          continue;
        }
      }
      print('게임을 종료합니다.');
    } else {}
  }

  void saveResult() {
    List resultList = [player.name, player.hp, result];

    String filePath = 'assets/result.csv';
    String csvData = '${resultList.join(',')}\n';
    File file = File(filePath);
    file.writeAsStringSync(
      csvData,
      mode: FileMode.write,
      encoding: Encoding.getByName('utf-8')!,
    );
    print('결과가 저장되었습니다.');
  }

  ///필수기능 메서드 끝
  ///
  ///
  ///
  ///도전기능 메서드 시작

  void randomAdditionalHp() {
    Random random = Random();
    int chance = random.nextInt(10);
    if (chance <= 2) {
      player.hp += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${player.hp}');
    }
  }
}
