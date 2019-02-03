import 'package:flutter/material.dart';
import 'package:yande/view/allView.dart';


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
              title: const Text('收藏'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) {
                          return CollectImageView();
                        }
                    ));
              },
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