import 'package:flutter/material.dart';
import 'package:yande/widget/progress.dart';

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
    return ListView(
      controller: this.controller,
      children: <Widget>[
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: this.crossAxisCount,
          children: this.children
        ),
        this.footer,
      ],
    );
  }

}

