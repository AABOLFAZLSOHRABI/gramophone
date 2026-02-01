import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/gen/assets.gen.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [ 
            Row(
              children: [
                Text(AppStrings.recentlyPlayed),
                SvgPicture.asset(Assets.icons.alert),
                SvgPicture.asset(Assets.icons.orientationLock),
                SvgPicture.asset(Assets.icons.settings),
              ],
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image), // Placeholder for the image
                        ),
                        const SizedBox(height: 8),
                        const Text(AppStrings.nameMusic),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// TODO: Implement the remaining sections of the Home tab page.