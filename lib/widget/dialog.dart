import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yande/service/allServices.dart';

class UpdateDialog extends StatelessWidget {

  final String version;
  final String text;
  final String url;

  UpdateDialog({
    this.version,
    this.text,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新版本已经发布'),
      content: Text(this.text),
      actions: <Widget>[
        FlatButton(
            child: const Text('忽略此版本'),
            onPressed: () {
              UpdateService.ignoreUpdateVersion(version);
              Navigator.pop(context);
            }
        ),
        FlatButton(
            child: const Text('暂时不'),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        FlatButton(
            child: const Text('更新'),
            onPressed: () async{
              if (await canLaunch(this.url)) {
                await launch(url);
              }
            }
        )
      ],
    );
  }
}
