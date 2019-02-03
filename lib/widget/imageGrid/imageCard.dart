import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef ImageTapCallBack = void Function(ImageModel);

class MainImageCard extends StatelessWidget {

  final ImageModel imageModel;
  final GestureTapCallback collectEvent;
  final GestureTapCallback downloadEvent;
  final ImageTapCallBack imageTap;
  final GestureLongPressCallback onLongPress;
  final String heroPrefix;
  MainImageCard(this.imageModel, {
    this.collectEvent,
    this.downloadEvent,
    this.onLongPress,
    this.imageTap,
    this.heroPrefix,
  }):assert(imageModel != null);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Stack(
              children: <Widget>[
                _buildImageBlockWidget(this.imageModel),
                _buildImageSizeText(this.imageModel),
              ],
            ),
            new Row(
              children: <Widget>[
                _CollectButton(
                  status: this.imageModel.isCollect(),
                  onTap: this.collectEvent,
                ),
                _DownloadButton(
                  status: this.imageModel.downloadStatus,
                  onTap: this.downloadEvent,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageSizeText(ImageModel imageModel) {
    return new Container(
      height: 20,
      decoration: new BoxDecoration(
        color: Color(0x1a000000),
        borderRadius: new BorderRadius.vertical(
            top: Radius.circular(5)
        )
      ),
      child: new Center(
        child: new Text(
            '${imageModel.width} x ${imageModel.height}',
            style: new TextStyle(
              color: Color(0xffffffff)
            ),
        ),
      ),
    );
  }

  Widget _buildImageBlockWidget(ImageModel imageModel) {
    return new SizedBox(
      height: 140,
      width: 200,
      child: new Container(
        decoration: new BoxDecoration(
//          color: Color(0x10000000),
          borderRadius: new BorderRadius.vertical(
              top: Radius.circular(5)
          )
        ),
        child: new GestureDetector(
          onTap: (){
            this.imageTap(imageModel);
          },
          child: Hero(
            tag: '$heroPrefix${imageModel.id}',
            child: new CachedNetworkImage(
                placeholder: new ImageCardCircularProgressIndicator(),
                imageUrl: imageModel.previewUrl
            ),
          ),
        )
      ),
    );
  }
}

class _CollectButton extends StatelessWidget {

  final GestureTapCallback onTap;
  final bool status;

  const _CollectButton({@required this.onTap, this.status})
      :assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return _CardMaterialButton(
      onTap: this.onTap,
      child: _buildStar(this.status),
    );
  }

  _buildStar(bool status) {
    if (status) {
      return Icon(
        Icons.star,
        color: Colors.amberAccent,
      );
    } else {
      return Icon(
        Icons.star_border,
      );
    }
  }
}

class _DownloadButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final ImageDownloadStatus status;
  const _DownloadButton({@required this.onTap, this.status})
      :assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    Color color = this.getColor();
    return _CardMaterialButton(
      onTap: this.onTap,
      child: Icon(
        Icons.file_download,
        color: color,
      ),
    );
  }


  Color getColor(){
    switch(this.status) {
      case ImageDownloadStatus.none: return Colors.black;
      case ImageDownloadStatus.success: return Colors.amberAccent;
      case ImageDownloadStatus.pending: return Colors.blueGrey;
      case ImageDownloadStatus.error: return Colors.redAccent;
      default: return Colors.black;

    }
  }

}

class _CardMaterialButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  const _CardMaterialButton({@required this.onTap,@required this.child})
      :assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return  new Material(
      child: new InkWell(
        child: new Container(
            width: 85,
            height: 30,
            child: child,
        ),
        onTap: this.onTap,
      ),
    );
  }

}


class ImageGalleryCard extends StatelessWidget {

  final ImageModel image;
  final ImageTapCallBack imageTap;
  final GestureLongPressCallback onLongPress;
  final String heroPrefix;

  ImageGalleryCard(this.image, {
    this.onLongPress,
    this.imageTap,
    this.heroPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        child: buildImageBlockWidget(this.image),
      ),
    );;
  }

  buildImageBlockWidget(ImageModel image) {
    return new SizedBox(
      height: 140,
      width: 200,
      child: new Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.vertical(
                  top: Radius.circular(5)
              )
          ),
          child: new GestureDetector(
            onTap: (){
              this.imageTap(image);
            },
            child: Hero(
              tag: '$heroPrefix${image.id}',
              child: new CachedNetworkImage(
                  placeholder: new ImageCardCircularProgressIndicator(),
                  imageUrl: image.previewUrl
              ),
            ),
          )
      ),
    );
  }

}