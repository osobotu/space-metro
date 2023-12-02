import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_metro/src/home/presentation/components/game_background.dart';
import 'package:space_metro/src/home/presentation/logic/game_state.dart';

typedef Position = ({int col, int row});
typedef BoardSize = ({int width, int height});

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: const Stack(
          alignment: Alignment.center,
          children: [
            BackgroundImageWidget(),
            GameBoard(
              size: (width: 6, height: 6),
            ),
          ],
        ),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
    required this.size,
  });

  final BoardSize size;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Position hoveredBox = (col: -1, row: -1);
  Position spaceShipPosition = (col: -1, row: -1);

  List<Position> minePositions = [];
  List<Position> accessiblePositions = [];
  List<Position> winningPositions = [];

  GameState gameState = NotStartedGame();

  @override
  void initState() {
    minePositions += getPositionOfMines(
      numberOfMines: widget.size.width * 2,
      boardSize: widget.size,
    );
    winningPositions += getWinningPositions(widget.size);

    if (gameState is NotStartedGame) {
      accessiblePositions += getInitialAccessiblePositions(widget.size);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool failed = minePositions.contains(spaceShipPosition);
    // final gameStateController = GameStateController();
    // return ValueListenableBuilder(
    // valueListenable: gameStateController,
    // builder: (context, gameState, _) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(widget.size.height, (i) => i).map(
          (h) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(widget.size.width, (i) => i).map(
                (w) => InkWell(
                  onHover: (val) {
                    setState(() {
                      hoveredBox = (col: h, row: w);
                    });
                  },
                  onTap: () async {
                    /// If the game has not started, the player will only be able to access boxes
                    /// in the first column of the game board. However, if the game has started
                    /// the accessiblePositions will be determined by the spaceShipPosition and
                    /// size of the game board.
                    if (accessiblePositions.contains((col: h, row: w))) {
                      setState(() {
                        gameState = PlayingGame();
                        spaceShipPosition = (col: h, row: w);
                        accessiblePositions.clear();
                        accessiblePositions.addAll(getAccessibleBoxes(
                            position: spaceShipPosition,
                            boardSize: widget.size));
                      });
                      if (minePositions.contains(spaceShipPosition)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Oops! You stepped on a mine! Try again."),
                          ),
                        );
                        await _resetGame(EndStatus.failure);
                      }
                      if (winningPositions.contains(spaceShipPosition)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Whohoo! You escaped all mines! "),
                            ),
                          );
                        }

                        await _resetGame(EndStatus.success);
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: h.isEven
                              ? w.isEven
                                  ? Colors.transparent.withOpacity(0.5)
                                  : Colors.black
                              : w.isEven
                                  ? Colors.black
                                  : Colors.transparent.withOpacity(0.5),
                          border: ((hoveredBox.col == h && hoveredBox.row == w))
                              ? Border.all(color: Colors.white)
                              : null,
                        ),
                        width: 100,
                        height: 100,
                        child: ((spaceShipPosition.row == w &&
                                spaceShipPosition.col == h))
                            ? Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    shape: const OvalBorder(),
                                    color: minePositions
                                            .contains(spaceShipPosition)
                                        ? Colors.red
                                        : Colors.teal,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      if (accessiblePositions.contains((col: h, row: w)) &&
                          (gameState is PlayingGame))
                        Container(
                          color: failed
                              ? Colors.redAccent.withOpacity(0.5)
                              : Colors.tealAccent.withOpacity(0.5),
                          width: 100,
                          height: 100,
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
    // });
  }

  Future<void> _resetGame(EndStatus status) async {
    gameState = EndedGame(status: status);
    accessiblePositions.clear();
    accessiblePositions += getInitialAccessiblePositions(widget.size);
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      spaceShipPosition = (col: -1, row: -1);
      hoveredBox = (col: -1, row: -1);
    });
  }
}

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

List<Position> getInitialAccessiblePositions(BoardSize boardSize) {
  List<Position> accessiblePositions = [];
  for (int i = 0; i < boardSize.height; i++) {
    accessiblePositions.add((col: i, row: 0));
  }
  return accessiblePositions;
}

List<Position> getWinningPositions(BoardSize boardSize) {
  List<Position> accessiblePositions = [];
  for (int i = 0; i < boardSize.height; i++) {
    accessiblePositions.add((col: i, row: boardSize.width - 1));
  }
  return accessiblePositions;
}
