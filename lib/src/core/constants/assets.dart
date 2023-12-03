class MetroAssets {
  static final String kidsGalaxy = _buildImagePath('kids-galaxy.jpg');
  // <a href="https://www.freepik.com/free-vector/cartoon-galaxy-with-stars-background_15266702.htm#query=space%20wallpaper&position=30&from_view=keyword&track=ais&uuid=79ca3f75-e86a-42fb-943d-2547ef54d05a">Image by pikisuperstar</a> on Freepik

  static final String galaxyNightSky =
      _buildImagePath('galactic-night-sky.jpg');
  // <a href="https://www.freepik.com/free-photo/galactic-night-sky-astronomy-science-combined-generative-ai_40968200.htm#query=space%20wallpaper&position=1&from_view=keyword&track=ais&uuid=beae91b1-dc06-41c3-a3d8-8cfc1e63c871">Image by vecstock</a> on Freepik

  static final String gameBoard = _buildImagePath('game_board.png');
  // helpers
  static String _buildIconPath(String name) => 'assets/images/svgs/$name.svg';
  static String _buildImagePath(String name) => 'assets/images/$name';
}
