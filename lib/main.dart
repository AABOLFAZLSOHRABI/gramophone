import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/ui/theme/app_theme.dart';
import 'package:gramophone/features/auth/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'gram',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(),
          home: StartScreen(),
        );
      },
    );
  }
}
// TODO: start start_screen as home