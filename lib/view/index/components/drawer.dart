import 'package:flutter/material.dart';


class LeftDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('yande'),
          ),
          MediaQuery.removePadding(
            context: context,
            child: ListTile(
              title: const Text('123'),
            ),
          )
        ],
      ),
    );
  }

}

class RightDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[

        ],
      ),
    );
  }

}