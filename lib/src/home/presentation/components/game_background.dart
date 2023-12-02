import 'package:flutter/material.dart';
import 'package:space_metro/src/core/constants/assets.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(MetroAssets.kidsGalaxy),
          ),
        ),
      ),
    );
  }
}
