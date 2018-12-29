import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yande/widget/all_widget.dart';

class ImageGalleryView extends StatefulWidget {

  final ImageModel image;

  ImageGalleryView({
    this.image
  });

  @override
  State<StatefulWidget> createState() => _ImageGalleryViewState();

}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GestureDetector(
        onLongPress: (){print("123");},
        child:  new PhotoView(
          imageProvider: NetworkImage(widget.image.jpegUrl),
        ),
      ),
    );
  }
}