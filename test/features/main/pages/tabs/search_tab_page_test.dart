import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/features/main/pages/tabs/search_tab_page.dart';

void main() {
  testWidgets('tap on Pop sends genreTrending payload', (tester) async {
    final result = await _tapTileAndCaptureExtra(tester, 'Pop');
    expect(result?['mode'], 'genreTrending');
    expect(result?['value'], 'Pop');
  });

  testWidgets('tap on Hip Hop sends genreTrending payload', (tester) async {
    final result = await _tapTileAndCaptureExtra(tester, 'Hip Hop');
    expect(result?['mode'], 'genreTrending');
    expect(result?['value'], 'Hip Hop');
  });

  testWidgets('tap on Underground sends tracksUnderground payload', (
    tester,
  ) async {
    final result = await _tapTileAndCaptureExtra(tester, 'Underground');
    expect(result?['mode'], 'tracksUnderground');
  });

  testWidgets('tap on News & Politics sends playlistSearch preset', (
    tester,
  ) async {
    final result = await _tapTileAndCaptureExtra(tester, 'News &\nPolitics');
    expect(result?['mode'], 'playlistSearch');
    expect(result?['value'], 'News Politics');
  });
}

Future<Map<String, dynamic>?> _tapTileAndCaptureExtra(
  WidgetTester tester,
  String tileText,
) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  Object? receivedExtra;
  final router = GoRouter(
    initialLocation: RouteNames.searchTabPage,
    routes: [
      GoRoute(
        path: RouteNames.searchTabPage,
        builder: (_, __) => const SearchTabPage(),
        routes: [
          GoRoute(
            path: RouteNames.searchInputPage,
            builder: (_, state) {
              receivedExtra = state.extra;
              return const Scaffold(body: Text('SearchInputPage'));
            },
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();

  final finder = find.text(tileText);
  await tester.scrollUntilVisible(
    finder,
    250,
    scrollable: find.byType(Scrollable),
  );
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();

  await tester.tap(finder);
  await tester.pumpAndSettle();
  expect(find.text('SearchInputPage'), findsOneWidget);
  await tester.binding.setSurfaceSize(null);
  return receivedExtra as Map<String, dynamic>?;
}
