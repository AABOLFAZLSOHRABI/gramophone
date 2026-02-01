import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/widgets/app_button.dart';
import 'package:gramophone/gen/assets.gen.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

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
            Text(AppStrings.verificationCode),
            TextField(),
            Text(AppStrings.enterVerificationCodeSentToEmail),
            Row(
              children: [
                AppButton(
                  text: " 02:59 ${AppStrings.resendCode}",
                  onPressed: () {},
                ), // TODO : There should be a 2-minute timer next to the text, and the button should be disabled until that timer reaches 0.
                AppButton(text: AppStrings.next, onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
