abstract class GameState {}

class NotStartedGame extends GameState {}

class PlayingGame extends GameState {}

class PausedGame extends GameState {}

class EndedGame extends GameState {
  final EndStatus status;

  EndedGame({required this.status});
}

enum EndStatus { success, failure }
