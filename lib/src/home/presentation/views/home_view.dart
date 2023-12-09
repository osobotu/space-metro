import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_metro/src/core/extensions/context_extensions.dart';
import 'package:space_metro/src/core/services/audio_service.dart';
import 'package:space_metro/src/core/theme/colors.dart';
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

  late MetroAudioService metroAudioService;

  @override
  void dispose() {
    metroAudioService.stopBackgroundSound();
    super.dispose();
  }

  @override
  void initState() {
    metroAudioService = MetroAudioService();

    // background music
    // metroAudioService.startBackgroundSound();

    // mines
    minePositions += getPositionOfMines(
      numberOfMines: widget.size.width * 2,
      boardSize: widget.size,
    );

    // winning
    winningPositions += getWinningPositions(widget.size);

    // initial accessible positions
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
                        // await metroAudioService.pauseBackgroundSound();
                        await metroAudioService.playFailureSound();
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MetroDialog(
                                  title: 'Oops!!! You stepped on a mine.',
                                  imageAsset: '',
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (context.navigator.canPop()) {
                                          context.navigator.pop();
                                        }
                                        // await metroAudioService
                                        // .resumeBackgroundSound();
                                        await _resetGame(EndStatus.failure);
                                      },
                                      child: const Text('Try Again'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (context.navigator.canPop()) {
                                          context.navigator.pop();
                                          context.navigator.pop();
                                        }
                                        // await metroAudioService
                                        // .stopBackgroundSound();
                                      },
                                      child: const Text('End Game'),
                                    ),
                                  ],
                                );
                              });
                        }
                      }

                      if (winningPositions.contains(spaceShipPosition) &&
                          !(minePositions.contains(spaceShipPosition))) {
                        // await metroAudioService.pauseBackgroundSound();
                        await metroAudioService.playSuccessSound();
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MetroDialog(
                                  title: 'Woohoo! You escaped all mines!',
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (context.navigator.canPop()) {
                                          context.navigator.pop();
                                        }
                                        await _resetGame(EndStatus.success);
                                        minePositions.clear();
                                        minePositions += getPositionOfMines(
                                          numberOfMines: widget.size.width * 2,
                                          boardSize: widget.size,
                                        );
                                        // await metroAudioService
                                        // .resumeBackgroundSound();
                                        // todo: find a way to increase the difficulty of the game
                                      },
                                      child: const Text('Play Again'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (context.navigator.canPop()) {
                                          context.navigator.pop();
                                          context.navigator.pop();
                                        }
                                        // await metroAudioService
                                        // .stopBackgroundSound();
                                      },
                                      child: const Text('End Game'),
                                    ),
                                  ],
                                  imageAsset: '',
                                );
                              });
                        }
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
                        width: context.scale(100),
                        height: context.scale(100),
                        child: ((spaceShipPosition.row == w &&
                                spaceShipPosition.col == h))
                            ? Center(
                                child: Container(
                                  width: context.scale(50),
                                  height: context.scale(50),
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
                          width: context.scale(100),
                          height: context.scale(100),
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
    gameState = NotStartedGame();
    accessiblePositions.clear();
    accessiblePositions += getInitialAccessiblePositions(widget.size);
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      spaceShipPosition = (col: -1, row: -1);
      hoveredBox = (col: -1, row: -1);
    });
  }
}

class MetroDialog extends StatelessWidget {
  const MetroDialog({
    super.key,
    required this.title,
    required this.actions,
    required this.imageAsset,
  });
  final String title;
  final String imageAsset;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(24),
      children: [
        SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: context.textTheme.headlineSmall!
                    .copyWith(color: MetroPalette.primary),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...actions,
                ],
              )
            ],
          ),
        )
      ],
    );
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
