import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'components/icons.dart';
import 'components/status_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yande/widget/all_widget.dart';

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
    return new CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
              new ImageStatusButton(
                showStatus: (){
                  showDialog(
                    context: context,
                    builder: (context) => ImageStatusDialog(widget.image)
                  );

                },
              )
          ],
          backgroundColor: Theme.of(context).accentColor,
          expandedHeight: 400.0,
          flexibleSpace: FlexibleSpaceBar(
            background: new Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: Hero(
                tag: widget.image.id,
                child: new CachedNetworkImage(
                  placeholder: new ImageCardCircularProgressIndicator(),
                  imageUrl: widget.image.sampleUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          pinned: true,
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          List.generate(20, (index) {
            return new Material(
                child: new InkWell(
              child: new ListTile(
                title: new Text("$index"),
              ),
            ));
          }).toList(),
        ))
      ],
    );
  }
}
