import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/widget/all_widget.dart';
import 'icons.dart';


class ImageStatusSliverAppBar extends StatelessWidget {
  final ImageModel image;
  final Function showDialog;

  ImageStatusSliverAppBar({this.image, this.showDialog});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        new ImageStatusButton(
          showStatus: this.showDialog,
        )
      ],
      backgroundColor: Theme.of(context).accentColor,
      expandedHeight: 400.0,
      flexibleSpace: FlexibleSpaceBar(
        background: new Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: Hero(
            tag: this.image.id,
            child: new MyCachedImage(
              url: this.image.sampleUrl,
            ),
          ),
        ),
      ),
      pinned: true,
    );
  }
}

class ImageActionButtonFiled extends StatelessWidget {
  final List<Widget> children;

  ImageActionButtonFiled({this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white
      ),

      alignment: Alignment.center,
      child: new Container(
        decoration: new BoxDecoration(
            color: const Color(0xffffffff),
            border: new Border.all(color: Color(0xffeaeaea)),
            borderRadius: new BorderRadius.all(new Radius.circular(5)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                offset: Offset(0.0, 0.5),
                blurRadius: 5.0,
                color: const Color(0xffcccccc),
              ),
              BoxShadow(
                offset: Offset(0.0, 0.5),
                spreadRadius: 0.0,
                color: const Color(0xffcccccc),
              ),
              BoxShadow(
                offset: Offset(0.0, 0.5),
                spreadRadius: 0.0,
                color: const Color(0xffcccccc),
              ),
            ]
        ),
        margin: new EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        height: 50,
        width: 300,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: this.children,
        ),
      ),
    );
  }
}

