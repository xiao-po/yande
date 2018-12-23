import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/widget/all_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef ImageTapCallBack = void Function(ImageModel);

class MainImageCard extends StatelessWidget {

  final ImageModel imageModel;
  final GestureTapCallback collectEvent;
  final GestureTapCallback downloadEvent;
  final ImageTapCallBack imageTap;
  final GestureLongPressCallback onLongPress;
  MainImageCard(this.imageModel, {
    this.collectEvent,
    this.downloadEvent,
    this.onLongPress,
    this.imageTap
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
                  status: false,
                  onTap: this.collectEvent,
                ),
                _DownloadButton(
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
            tag: imageModel.id,
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
        Icons.star_border,
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
  const _DownloadButton({@required this.onTap})
      :assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return _CardMaterialButton(
      onTap: this.onTap,
      child: Icon(
        Icons.file_download,
      ),
    );
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