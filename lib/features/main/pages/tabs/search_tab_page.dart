import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';

class SearchTabPage extends StatelessWidget {
  const SearchTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.push(RouteNames.playerPage);
            },
            child: const Text('Test with GetIt'),
          ),
        ),
      ),
    );
  }
}
