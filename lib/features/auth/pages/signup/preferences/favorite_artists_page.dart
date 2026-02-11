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
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: SvgPicture.asset(Assets.icons.chevronLeft),
          ),
          title: Text(
            AppStrings.favoriteArtistsSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: AppStrings.searchArtists,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final avatarDiameter =
                          (constraints.maxWidth * 0.78).clamp(56.0, 84.0);
                      final avatarRadius = avatarDiameter / 2;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: Colors.grey,
                          ),
                          8.h.height,
                          SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              AppStrings.artistName,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // When the user selects three interests, the next button is activated
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: AppButton(
                text: AppStrings.next,
                onPressed: () => context.push(RouteNames.favoritePodcastsPage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
