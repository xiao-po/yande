import 'package:yande/widget/allWidget.dart';
import 'package:flutter/material.dart';

class LazyLoadGridView extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> children;
  final int crossAxisCount;
  final Widget footer;
  final String heroPrefix;
  LazyLoadGridView({
    this.crossAxisCount = 2,
    this.controller,
    this.children,
    this.heroPrefix,
    this.footer = const FootProgress(),
  }):assert(children != null && children.length > 0);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      controller: this.controller,
      children: <Widget>[
        new GridView.count(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: this.crossAxisCount,
          children: this.children
        ),
        this.footer,
      ],
    );
  }

}