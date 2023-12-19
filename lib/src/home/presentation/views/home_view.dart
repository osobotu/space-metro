import 'package:flutter/material.dart';
import 'package:space_metro/src/core/extensions/context_extensions.dart';
import 'package:space_metro/src/core/services/audio_service.dart';
import 'package:space_metro/src/core/theme/colors.dart';
import 'package:space_metro/src/home/presentation/components/game_background.dart';
import 'package:space_metro/src/home/presentation/logic/game_engine.dart';
import 'package:space_metro/src/home/presentation/logic/game_state.dart';
import 'package:space_metro/src/home/presentation/logic/game_controller.dart';

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
  List<Position> minePositions = [];
  List<Position> accessiblePositions = [];
  List<Position> winningPositions = [];

  // GameState gameState = NotStartedGame();

  late MetroAudioService metroAudioService;
  late GameEngine gameEngine;
  late GameController gameController;

  @override
  void dispose() {
    metroAudioService.stopBackgroundSound();

    super.dispose();
  }

  @override
  void initState() {
    metroAudioService = MetroAudioService();
    gameEngine = GameEngine();
    gameController = GameController(gameEngine: gameEngine);
    // background music
    // metroAudioService.startBackgroundSound();

    // mines
    minePositions += gameController.minePositions;

    // winning
    winningPositions += gameController.winningPositions;

    // initial accessible positions
    if (gameController.value is NotStartedGame) {
      accessiblePositions += gameController.startingPositions;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: Listenable.merge([
          gameController.hoveredBox,
          gameController.spaceShipPosition,
          gameController.totalPlays,
          gameController.wins,
        ]),
        builder: (context, _) {
          // final hoveredBox = gameController.hoveredBox.value;
          // final spaceShipPosition = gameController.spaceShipPosition.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(widget.size.height, (i) => i).map(
                      (h) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(widget.size.width, (i) => i)
                              .map((w) {
                            final isHovering =
                                (gameController.hoveredBox.value.col == h &&
                                    gameController.hoveredBox.value.row == w);
                            final hasSpaceship = (gameController
                                        .spaceShipPosition.value.row ==
                                    w &&
                                gameController.spaceShipPosition.value.col ==
                                    h);
                            final currentPosition = (col: h, row: w);
                            return InkWell(
                              onHover: (val) {
                                gameController.hoveredBox.value =
                                    (col: h, row: w);
                              },
                              onTap: () async {
                                /// If the game has not started, the player will only be able to access boxes
                                /// in the first column of the game board. However, if the game has started
                                /// the accessiblePositions will be determined by the spaceShipPosition and
                                /// size of the game board.
                                if (accessiblePositions
                                    .contains(currentPosition)) {
                                  gameController.value = PlayingGame();
                                  gameController.spaceShipPosition.value =
                                      currentPosition;
                                  accessiblePositions.clear();
                                  accessiblePositions.addAll(gameController
                                      .accessiblePositions(currentPosition));

                                  if (minePositions.contains(
                                      gameController.spaceShipPosition.value)) {
                                    // await metroAudioService.pauseBackgroundSound();
                                    await metroAudioService.playFailureSound();
                                    if (context.mounted) {
                                      gameController.increaseTotal();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MetroDialog(
                                              title:
                                                  'Oops!!! You stepped on a mine.',
                                              imageAsset: '',
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (context.navigator
                                                        .canPop()) {
                                                      context.navigator.pop();
                                                    }
                                                    // await metroAudioService
                                                    // .resumeBackgroundSound();
                                                    await _resetGame(
                                                        EndStatus.failure);
                                                  },
                                                  child:
                                                      const Text('Try Again'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (context.navigator
                                                        .canPop()) {
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

                                  if (winningPositions.contains(
                                      gameController.spaceShipPosition.value)) {
                                    // await metroAudioService.pauseBackgroundSound();
                                    await metroAudioService.playSuccessSound();
                                    if (context.mounted) {
                                      gameController.increaseTotal();
                                      gameController.increaseWins();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MetroDialog(
                                              title:
                                                  'Woohoo! You escaped all mines!',
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (context.navigator
                                                        .canPop()) {
                                                      context.navigator.pop();
                                                    }
                                                    await _resetGame(
                                                        EndStatus.success);
                                                    minePositions.clear();
                                                    minePositions += gameEngine
                                                        .getPositionOfMines(
                                                      numberOfMines:
                                                          widget.size.width * 2,
                                                      boardSize: widget.size,
                                                    );
                                                    // await metroAudioService
                                                    // .resumeBackgroundSound();
                                                    // todo: find a way to increase the difficulty of the game
                                                  },
                                                  child:
                                                      const Text('Play Again'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (context.navigator
                                                        .canPop()) {
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
                                              ? Colors.transparent
                                                  .withOpacity(0.5)
                                              : Colors.black
                                          : w.isEven
                                              ? Colors.black
                                              : Colors.transparent
                                                  .withOpacity(0.5),
                                      border: (isHovering)
                                          ? Border.all(color: Colors.white)
                                          : null,
                                    ),
                                    width: context.scale(100),
                                    height: context.scale(100),
                                    child: (hasSpaceship)
                                        ? Center(
                                            child: Container(
                                              width: context.scale(50),
                                              height: context.scale(50),
                                              decoration: ShapeDecoration(
                                                shape: const OvalBorder(),
                                                color: minePositions.contains(
                                                        gameController
                                                            .spaceShipPosition
                                                            .value)
                                                    ? Colors.red
                                                    : Colors.teal,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  if (accessiblePositions
                                          .contains(currentPosition) &&
                                      (gameController.value is PlayingGame))
                                    Container(
                                      color: minePositions.contains(
                                              gameController
                                                  .spaceShipPosition.value)
                                          ? Colors.redAccent.withOpacity(0.5)
                                          : Colors.tealAccent.withOpacity(0.5),
                                      // color: Colors.tealAccent.withOpacity(0.5),
                                      width: context.scale(100),
                                      height: context.scale(100),
                                    ),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Plays: ${gameController.totalPlays.value}',
                      style: context.textTheme.headlineLarge!
                          .copyWith(color: MetroPalette.white),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Wins: ${gameController.wins.value}',
                      style: context.textTheme.headlineLarge!
                          .copyWith(color: MetroPalette.white),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Win ratio: ${gameController.winRatio.toStringAsFixed(2)}',
                      style: context.textTheme.headlineLarge!
                          .copyWith(color: MetroPalette.white),
                    ),
                  ],
                ),
              )
            ],
          );
        });

    // });
  }

  Future<void> _resetGame(EndStatus status) async {
    gameController.value = NotStartedGame();
    accessiblePositions.clear();
    accessiblePositions += gameController.startingPositions;
    Future.delayed(const Duration(milliseconds: 50)).then((value) {
      gameController.spaceShipPosition.value = kDefaultPosition;
      gameController.hoveredBox.value = kDefaultPosition;
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
