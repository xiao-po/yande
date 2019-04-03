import 'package:flutter/material.dart';
import 'package:yande/model/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yande/service/cacheService.dart';
import 'package:yande/service/shareService.dart';
import 'package:yande/widget/progress.dart';
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
        background: Container(
          decoration: BoxDecoration(color: Colors.white),
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
        ImageStatusButton(
          showStatus: widget.showDialog,

        ),
        ImageShareButton(
          onTap: () {
            ShareService.shareImage(widget.image.sampleUrl);
          },
        )
      ];
    } else {
      return <Widget>[
        ImageStatusButton(
          showStatus: widget.showDialog,
        )
      ];
    }

  }

  Widget _buildCacheImage() {
    if (!this.imageLoadOver) {
      return Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: CachedNetworkImage(
              placeholder: ImageCardCircularProgressIndicator(),
              imageUrl: widget.image.previewUrl,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 30,
                width: double.infinity,
                alignment: Alignment.bottomRight,
                color: Color(0x5a000000),
                child: Container(
                  width: 20,
                  height: 30,
                  margin: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return CachedNetworkImage(
        placeholder: ImageCardCircularProgressIndicator(),
        imageUrl: widget.image.sampleUrl,
        fit: BoxFit.cover,
      );
    }
  }

  void listenImageLoadOver() async{
    await CacheService.getFile(widget.image.sampleUrl);
    this.imageLoadOver = true;
    if (this.mounted) {
      setState(() {});
    }
  }
}

class ImageActionButtonFiled extends StatelessWidget {
  final List<Widget> children;

  ImageActionButtonFiled({this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),

      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            border: Border.all(color: Color(0xffeaeaea)),
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
        margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        height: 50,
        width: 300,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: this.children,
        ),
      ),
    );
  }
}

