import 'package:flutter/material.dart';
import 'package:yande/view/allView.dart';

export 'package:yande/view/allView.dart';

class ViewRoute {
  const ViewRoute({
    this.title,
    this.icon,
    this.subtitle,
    this.routeName,
    this.buildRoute,
  }) : assert(title != null),
        assert(routeName != null),
        assert(buildRoute != null);

  final String title;
  final IconData icon;
  final String subtitle;
  final String routeName;
  final WidgetBuilder buildRoute;

  @override
  String toString() {
    return '$runtimeType($title $routeName)';
  }
}


List<ViewRoute> _allViewRoutes() {
  return <ViewRoute>[
    ViewRoute(
      title: IndexView.title,
      routeName: IndexView.route,
      buildRoute: (BuildContext context) => IndexView(),
    ),
    ViewRoute(
      title: ImageStatusView.title,
      routeName: ImageStatusView.route,
      buildRoute: (BuildContext context) => ImageStatusView(),
    ),
    ViewRoute(
      title: '设置',
      routeName: '/setting',
      buildRoute: (BuildContext context) => SettingView(),
    ),
  ];
}


final List<ViewRoute> allViewRoutes = _allViewRoutes();