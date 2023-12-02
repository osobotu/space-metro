import 'package:flutter/material.dart';
import 'package:space_metro/src/home/presentation/logic/game_state.dart';

class GameStateController extends ValueNotifier<GameState> {
  GameStateController() : super(NotStartedGame());

  void startGame() {
    value = PlayingGame();
  }

  void pauseGame() {
    value = PausedGame();
  }

  void endGame(EndStatus status) {
    value = EndedGame(status: status);
  }
}
