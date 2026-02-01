import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/widgets/app_button.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/gen/assets.gen.dart';

class FavoriteArtistsPage extends StatelessWidget {
  const FavoriteArtistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Text(AppStrings.favoriteArtistsSubtitle),
                SvgPicture.asset(Assets.icons.chevronLeft),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchArtists,
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                      ),
                      8.h.height,
                      Text(
                        AppStrings.artistName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),

            // When the user selects three interests, the next button is activated
            AppButton(
              text: AppStrings.next,
              onPressed: () => context.push(RouteNames.favoritePodcastsPage),
            ),
          ],
        ),
      ),
    );
  }
}
