import 'package:yande/widget/allWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';

class MyCachedImage extends StatelessWidget {

  final String url;

  MyCachedImage({
    this.url
  });

  @override
  Widget build(BuildContext context) {

    ImageModel image;

    if (image != null) {
      return Image.asset(image.fileUrl);
    } else  {
      return new CachedNetworkImage(
        placeholder: new ImageCardCircularProgressIndicator(),
        imageUrl: this.url,
        fit: BoxFit.cover,
      );
    }
  }
}