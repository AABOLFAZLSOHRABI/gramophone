import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/ui/widgets/app_button.dart';

class AppBarTextIconAction extends StatelessWidget {
  const AppBarTextIconAction({
    super.key,
    required this.text,
    required this.iconPath,
    this.textStyle,
    this.textAlign,
    this.spacing = 6,
    this.iconColor,
    this.iconSize,
    this.onIconPressed,
  });

  final String text;
  final String iconPath;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double spacing;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onIconPressed;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      iconPath,
      width: iconSize,
      height: iconSize,
      colorFilter: iconColor == null
          ? null
          : ColorFilter.mode(iconColor!, BlendMode.srcIn),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        onIconPressed == null
            ? icon
            : Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: GestureDetector(
                  onTap: onIconPressed,
                  behavior: HitTestBehavior.opaque,
                  child: icon,
                ),
              ),
        SizedBox(width: spacing),
        Text(text, style: textStyle, textAlign: textAlign),
      ],
    );
  }
}

class PaddedText extends StatelessWidget {
  const PaddedText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.padding = EdgeInsets.zero,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final EdgeInsets padding;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: style?.copyWith(color: color) ??
            (color == null ? null : TextStyle(color: color)),
        textAlign: textAlign,
      ),
    );
  }
}

class FilledRoundedTextField extends StatelessWidget {
  const FilledRoundedTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.fillColor,
    this.borderRadius = 5,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Color? fillColor;
  final double borderRadius;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CenteredButton extends StatelessWidget {
  const CenteredButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.borderColor,
    this.iconPath,
  });

  final String text;
  final VoidCallback onPressed;
  final double? width;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? borderColor;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Padding(
          padding: padding,
          child: AppButton(
            text: text,
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            textColor: textColor,
            borderRadius: borderRadius,
            borderColor: borderColor,
            iconPath: iconPath,
          ),
        ),
      ),
    );
  }
}
