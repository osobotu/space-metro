import 'dart:math';

import 'package:space_metro/src/home/presentation/logic/game_controller.dart';

class GameEngine {
  /// For any given position on the board, this function returns
  /// a list of positions that the player can move to.
  List<Position> getAccessibleBoxes({
    required Position position,
    required BoardSize boardSize,
  }) {
    List<({int col, int row})> positions = [];
    for (int i = -1; i < 2; i++) {
      final col = position.col + i;
      if (col >= 0 && col < boardSize.height) {
        for (int j = -1; j < 2; j++) {
          final row = position.row + j;
          if (row >= 0 && row < boardSize.width) {
            final currentPosition = (col: col, row: row);
            positions.add(currentPosition);
          }
        }
      }
    }
    return positions;
  }

  /// The getPositionOfMines returns a list of coordinates that contain mines
  List<Position> getPositionOfMines({
    required int numberOfMines,
    required BoardSize boardSize,
  }) {
    var minePositions = <Position>{};
    while (minePositions.length != numberOfMines) {
      // get random position for mine
      final Random random = Random(DateTime.now().millisecond);
      final mine = (
        col: random.nextInt(boardSize.height),
        row: random.nextInt(boardSize.width)
      );
      minePositions.add(mine);
    }
    return minePositions.toList();
  }

  /// The player can only start the game from the left side of the board i.e. the first column.
  /// This function returns that coordinates of the first column of the board.
  List<Position> getStartingPositions(BoardSize boardSize) {
    List<Position> accessiblePositions = [];
    for (int i = 0; i < boardSize.height; i++) {
      accessiblePositions.add((col: i, row: 0));
    }
    return accessiblePositions;
  }

  /// The game is won when the player gets across the board. However, some end squares may also
  /// contain mines. This function returns the possible winning positions for a particular game.
  List<Position> getWinningPositions(
      BoardSize boardSize, List<Position> minePositions) {
    List<Position> winningPositions = [];
    for (int i = 0; i < boardSize.height; i++) {
      final coordinate = (col: i, row: boardSize.width - 1);
      if (!minePositions.contains(coordinate)) {
        winningPositions.add(coordinate);
      }
    }
    return winningPositions;
  }
}
