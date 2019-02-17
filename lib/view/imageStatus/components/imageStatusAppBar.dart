import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:yande/service/allServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'icons.dart';

class ImageStatusSliverAppBar extends StatefulWidget {

  final ImageModel image;
  final Function showDialog;
  final String heroPrefix;

  ImageStatusSliverAppBar({this.image, this.showDialog, this.heroPrefix});

  @override
  State<StatefulWidget> createState() => _ImageStatusSliverAppBarState();


}


class _ImageStatusSliverAppBarState extends State<ImageStatusSliverAppBar> {
  bool imageLoadOver = false;

  @override
  void initState() {
    super.initState();
    this.listenImageLoadOver();
  }


  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      actions: _buildAppBarActionButton(),
      backgroundColor: Theme.of(context).accentColor,
      expandedHeight: 400.0,
      flexibleSpace: FlexibleSpaceBar(
        background: new Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: Hero(
            tag: '${widget.heroPrefix}${widget.image.id}',
            child: _buildCacheImage(),
          ),
        ),
      ),
      pinned: true,
    );
  }

  List<Widget> _buildAppBarActionButton() {
    if (this.imageLoadOver) {
      return <Widget>[
        new ImageStatusButton(
          showStatus: widget.showDialog,

        ),
        new ImageShareButton(
          onTap: () {
            ShareService.shareImage(widget.image.sampleUrl);
          },
        )
      ];
    } else {
      return <Widget>[
        new ImageStatusButton(
          showStatus: widget.showDialog,
        )
      ];
    }

  }

  Widget _buildCacheImage() {
    if (!this.imageLoadOver) {
      return new Stack(
        children: <Widget>[
          new Container(
            height: double.infinity,
            width: double.infinity,
            child: CachedNetworkImage(
              placeholder: new ImageCardCircularProgressIndicator(),
              imageUrl: widget.image.previewUrl,
              fit: BoxFit.cover,
            ),
          ),
          new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Container(
                height: 30,
                width: double.infinity,
                alignment: Alignment.bottomRight,
                color: Color(0x5a000000),
                child: new Container(
                  width: 20,
                  height: 30,
                  margin: new EdgeInsets.all(5),
                  child: new CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return new CachedNetworkImage(
        placeholder: new ImageCardCircularProgressIndicator(),
        imageUrl: widget.image.sampleUrl,
        fit: BoxFit.cover,
      );
    }
  }

  void listenImageLoadOver() async{
    await CacheService.getFile(widget.image.sampleUrl);
    this.imageLoadOver = true;
    print('over');
    setState(() {});
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

