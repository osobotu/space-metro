import 'package:flutter/material.dart';
import 'package:space_metro/src/home/presentation/logic/game_engine.dart';
import 'package:space_metro/src/home/presentation/logic/game_state.dart';

typedef Position = ({int col, int row});
typedef BoardSize = ({int width, int height});

// DEFAULTS
const Position kDefaultPosition = (col: -1, row: -1);
const BoardSize kDefaultBoardSize = (width: 6, height: 6);

class GameController extends ValueNotifier<GameState> {
  GameController({required this.gameEngine}) : super(NotStartedGame());

  final GameEngine gameEngine;

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
  final BoardSize _size = (width: 6, height: 6);

  // mines positions
  List<Position> get minePositions => gameEngine.getPositionOfMines(
        numberOfMines: _size.width * 2,
        boardSize: _size,
      );

  // start positions
  List<Position> get startingPositions =>
      gameEngine.getStartingPositions(_size);

  // accessible positions
  List<Position> accessiblePositions(Position currentPosition) {
    return gameEngine.getAccessibleBoxes(
        position: currentPosition, boardSize: _size);
  }

  // win positions
  List<Position> get winningPositions =>
      gameEngine.getWinningPositions(_size, minePositions);

  // score
  ValueNotifier<int> totalPlays = ValueNotifier(0);
  ValueNotifier<int> wins = ValueNotifier(0);

  double get winRatio =>
      totalPlays.value == 0 ? 0 : wins.value / totalPlays.value;

  void increaseTotal() => totalPlays.value++;
  void increaseWins() => wins.value++;
}
