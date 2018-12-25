import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'components/status_dialog.dart';
import 'components/imageStatusAppBar.dart';

class ImageStatusView extends StatefulWidget {
  static final String route = "/status";
  static final String title = "imageStatus";

  final ImageModel image;

  ImageStatusView({this.image});

  @override
  State<StatefulWidget> createState() => _ImageStatusView();
}

class _ImageStatusView extends State<ImageStatusView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new CustomScrollView(
          slivers: <Widget>[
            new ImageStatusSliverAppBar(
              image: widget.image,
              showDialog: () {
                showDialog(
                    context: context,
                    builder: (context) => ImageStatusDialog(widget.image));
              },
            ),
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              new ImageActionButtonFiled(
                children: <Widget>[
                  _buildLargeButton(
                    "查看",
                    onPressed: () {
                      // TODO:
                    },
                  ),
                  _buildLargeButton(
                    "下载",
                    onPressed: () {
                      // TODO:
                    },
                  )
                ],
              )
            ]))
          ],
        ),
      ),
    );
  }

  Widget _buildTagFiled() {
    return new Text("123");
  }

  Widget _buildLargeButton(String name, {Function onPressed}) {
    return new Expanded(
      child: new MaterialButton(
        onPressed: onPressed,
        child: new SizedBox(
          height: 50,
          child: new Center(
            child: new Text(
              name,
            ),
          ),
        ),
      ),
    );
  }
}
