import 'package:audioplayers/audioplayers.dart';

class MetroAudioService {
  // give access to the AudioPlayer class

  // ! Background music
  // create AudioPlayer instance for background music
  final bgPlayer = AudioPlayer();

  // start and stop the background sound
  Future<void> startBackgroundSound() async {
    // set source
    await bgPlayer.setSourceAsset('sounds/draft-monk-ambience(chosic.com).mp3');

    // play the sound
    await bgPlayer.resume();
  }

  Future<void> pauseBackgroundSound() async {
    await bgPlayer.pause();
  }

  Future<void> resumeBackgroundSound() async {
    await bgPlayer.resume();
  }

  Future<void> stopBackgroundSound() async {
    await bgPlayer.stop();
  }

  // ! Success and failure sounds
  final successSoundPlayer = AudioPlayer();
  // play success sound
  Future<void> playSuccessSound() async {
    await _setPlayAndStopSound('sounds/applause_sound.mp3');
  }

  // play failure sound
  Future<void> playFailureSound() async {
    await _setPlayAndStopSound('sounds/mine_explosion.mp3');
  }

  // ! Helpers
  Future<void> _setPlayAndStopSound(String sourcePath) async {
    final player = AudioPlayer();
    // set source
    await player.setSourceAsset(sourcePath);
    // play sound
    await player.resume();

    // stop sound
    // await player.
  }
}
