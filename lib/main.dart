import 'package:flutter/material.dart';
import 'package:yande/route/route.dart';
import 'package:yande/store/store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp() {
    TagStore.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: _buildRoutes(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return Map<String, WidgetBuilder>.fromIterable(
      allViewRoutes,
      key: (dynamic demo) => '${demo.routeName}',
      value: (dynamic demo) => demo.buildRoute,
    );
  }
}