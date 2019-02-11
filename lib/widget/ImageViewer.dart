import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'dart:io' show File;
import 'package:cached_network_image/cached_network_image.dart';
import 'allWidget.dart';

class MyImageViewer extends StatefulWidget {

  final ImageModel image;

  MyImageViewer(this.image);

  @override
  State<StatefulWidget> createState() => _MyImageViewerState();



}

class _MyImageViewerState extends State<MyImageViewer> {

  bool isAssetsLoadingOver;
  File imageFile = null;
  
  @override
  initState(){
    super.initState();
    if (widget.image.isDownload()) {
        this.getImageFile(widget.image.downloadPath);
    }
  }

  Widget build(BuildContext context) {
    if (widget.image.isDownload()) {
      if (this.isAssetsLoadingOver) {
        return Image.file(this.imageFile);
      } else {
        return new ImageCardCircularProgressIndicator();
      }
    } else {
      return new CachedNetworkImage(
          placeholder: new ImageCardCircularProgressIndicator(),
          imageUrl: widget.image.previewUrl
      );
    }
  }

  void getImageFile(String path) async{
    this.imageFile = new File(path);
    this.isAssetsLoadingOver = true;
    setState(() {

    });
  }

}