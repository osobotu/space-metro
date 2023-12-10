import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:space_metro/src/core/constants/assets.dart';
import 'package:space_metro/src/core/constants/urls.dart';
import 'package:space_metro/src/core/extensions/context_extensions.dart';
import 'package:space_metro/src/core/routing/router.dart';
import 'package:space_metro/src/core/theme/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:space_metro/src/shared/responsive/responsive_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MetroResponsiveWidget(
        desktop: _DesktopOnboardingView(),
        mobile: _MobileOnboardingView(),
        tablet: _MobileOnboardingView(),
      ),
    );
  }
}

class _MobileOnboardingView extends StatelessWidget {
  const _MobileOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Column(
              children: [
                Text(
                  'Welcome to Space Metro',
                  style: context.textTheme.displaySmall!
                      .copyWith(color: MetroPalette.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  // width: context.scale(50),
                  height: 300,
                  child: Image.asset(
                    MetroAssets.gameBoard,
                    fit: BoxFit.fill,
                    height: double.infinity,
                  ),
                ),
                const SizedBox(height: 16),
                DefaultTextStyle(
                  style: context.textTheme.headlineMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 20),
                  textAlign: TextAlign.center,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Your objective is to get across the board, \nfrom left to right, \none step at a time, \nwithout stepping on any mines.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                    displayFullTextOnTap: true,
                    totalRepeatCount: 1,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).restorablePushNamed(MetroRouter.game);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      context.scale(300),
                      context.scale(50),
                    ),
                  ),
                  child: const Text('Play'),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: 'Made by ',
                      children: [
                        TextSpan(
                          text: 'Obotu',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final gitHubProfileUrl =
                                  Uri.parse(GITHUB_PROFILE);
                              if (await canLaunchUrl(gitHubProfileUrl)) {
                                await launchUrl(gitHubProfileUrl);
                              } else {
                                throw 'Could not launch $gitHubProfileUrl';
                              }
                            },
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: MetroPalette.primary,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopOnboardingView extends StatelessWidget {
  const _DesktopOnboardingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            MetroAssets.gameBoard,
            fit: BoxFit.fill,
            height: double.infinity,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Welcome to Space Metro',
                  style: context.textTheme.displayLarge!
                      .copyWith(color: MetroPalette.primary),
                  textAlign: TextAlign.center,
                ),
                DefaultTextStyle(
                  style: context.textTheme.headlineMedium!
                      .copyWith(fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Your objective is to get across the board, \nfrom left to right, \none step at a time, \nwithout stepping on any mines.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                    displayFullTextOnTap: true,
                    totalRepeatCount: 1,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .restorablePushNamed(MetroRouter.game);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          context.scale(300),
                          context.scale(50),
                        ),
                      ),
                      child: const Text('Play'),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(text: 'Made by ', children: [
                          TextSpan(
                            text: 'Obotu',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final gitHubProfileUrl =
                                    Uri.parse(GITHUB_PROFILE);
                                if (await canLaunchUrl(gitHubProfileUrl)) {
                                  await launchUrl(gitHubProfileUrl);
                                } else {
                                  throw 'Could not launch $gitHubProfileUrl';
                                }
                              },
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: MetroPalette.primary,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
