import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yande/model/image_model.dart';

class ImageGalleryView extends StatefulWidget {

  final ImageModel image;
  final String heroPrefix;

  ImageGalleryView({
    this.image,
    this.heroPrefix
  });

  @override
  State<StatefulWidget> createState() => _ImageGalleryViewState();

}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onLongPress: (){print("123");},
        child:  Hero(
            tag: '${widget.heroPrefix}${widget.image.id}',
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.image.sampleUrl),
            )
        ),
      ),
    );
  }
}