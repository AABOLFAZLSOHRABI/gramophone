import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/widgets/app_button.dart';
import 'package:gramophone/gen/assets.gen.dart';

class PasswordStepPage extends StatelessWidget {
  const PasswordStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Text(AppStrings.createAccount),
                SvgPicture.asset(Assets.icons.chevronLeft),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Text(AppStrings.createPassword),
            TextField(),
            Text(AppStrings.useAtLeast8Characters),
            AppButton(
              text: AppStrings.next,
              onPressed: () => context.push(RouteNames.profileInfoStepPage),
            ), // TODO = By pressing the button, a pop-up will open and ask the user if the pass is correct. If they say yes, they will go to the next page.
          ],
        ),
      ),
    );
  }
}
