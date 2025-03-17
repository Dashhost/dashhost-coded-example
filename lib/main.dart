import 'package:dashhost_coded_example/about_screen.dart';
import 'package:dashhost_coded_example/detail_screen.dart';
import 'package:dashhost_coded_example/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();
  // DashDevTools().enable();
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/artwork/:number', builder: (context, state) => DetailScreen(identifier: int.parse(state.pathParameters['number']!))),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: _router,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
    );
  }
}
