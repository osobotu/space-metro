import 'package:flutter/material.dart';
import 'package:space_metro/src/core/services/auth_service.dart';
import 'package:space_metro/src/core/services/local_storage_service.dart';
import 'package:space_metro/src/core/services/realtime_db_service.dart';
import 'package:space_metro/src/home/presentation/logic/game_engine.dart';
import 'package:space_metro/src/home/presentation/logic/game_state.dart';

typedef Position = ({int col, int row});
typedef BoardSize = ({int width, int height});

// DEFAULTS
const Position kDefaultPosition = (col: -1, row: -1);
const BoardSize kDefaultBoardSize = (width: 6, height: 6);

class GameController extends ValueNotifier<GameState> {
  GameController({
    required this.gameEngine,
    required this.secureStorage,
  }) : super(NotStartedGame()) {
    // getTotalPlays();
    // getWins();
    getScores();
  }

  final GameEngine gameEngine;
  final SecureStorage secureStorage;

  void startGame() {
    value = PlayingGame();
  }

  void pauseGame() {
    value = PausedGame();
  }

  void endGame(EndStatus status) {
    value = EndedGame(status: status);
  }

  // position
  ValueNotifier<Position> hoveredBox = ValueNotifier(kDefaultPosition);
  ValueNotifier<Position> spaceShipPosition = ValueNotifier(kDefaultPosition);

  // starting board size
  final BoardSize size = (width: 6, height: 6);

  // mines positions
  List<Position> get minePositions => gameEngine.getPositionOfMines(
        numberOfMines: size.width * 2,
        boardSize: size,
      );

  // start positions
  List<Position> get startingPositions => gameEngine.getStartingPositions(size);

  // accessible positions
  List<Position> accessiblePositions(Position currentPosition) {
    return gameEngine.getAccessibleBoxes(
        position: currentPosition, boardSize: size);
  }

  // win positions
  List<Position> winningPositions(List<Position> mines) =>
      gameEngine.getWinningPositions(size, mines);

  // score
  ValueNotifier<int> totalPlays = ValueNotifier(0);
  ValueNotifier<int> wins = ValueNotifier(0);

  double get winRatio =>
      totalPlays.value == 0 ? 0 : (wins.value / totalPlays.value) * 100;

  void increaseTotal() {
    totalPlays.value++;
    saveTotalPlays();
  }

  void increaseWins() {
    wins.value++;
    saveWins();
  }

  // save scores to local storage
  void saveTotalPlays() async {
    await secureStorage.save(
      totalPlaysKey,
      totalPlays.value.toString(),
    );
  }

  void saveWins() async {
    await secureStorage.save(
      winsKey,
      wins.value.toString(),
    );
  }

  // void getTotalPlays() async {
  //   final value = await secureStorage.get(totalPlaysKey);
  //   totalPlays.value = int.tryParse(value) ?? 0;
  // }

  // void getWins() async {
  //   final value = await secureStorage.get(winsKey);
  //   wins.value = int.tryParse(value) ?? 0;
  // }

  //get and save scores to realtime database
  void getScores() async {
    final currentUser = FirebaseAuthService.currentUser;
    if (currentUser != null) {
      final scores = await RealTimeDBService.getScores(currentUser.uid);
      wins.value = scores.wins;
      totalPlays.value = scores.totalPlays;
    }
  }

  void saveScores() async {
    final currentUser = FirebaseAuthService.currentUser;

    if (currentUser != null) {
      RealTimeDBService.writeToScoresJSON(
        name: currentUser.displayName ?? 'Unknown',
        userId: currentUser.uid,
        wins: wins.value,
        total: totalPlays.value,
      );
    } else {
      debugPrint('did not update realtime db cos user is logged in');
    }
  }
}

const String totalPlaysKey = 'TOTAL_PLAYS';
const String winsKey = 'WINS';
