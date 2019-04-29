import 'package:flutter/material.dart';
import 'package:yande/dao/init_dao.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/service/downloadService.dart';
import 'package:yande/service/imageServive.dart';
import 'package:yande/view/imageStatus/imageStatusView.dart';
import 'package:yande/widget/imageGrid/imageCard.dart';
import 'package:yande/widget/imageGrid/lazyloadView.dart';
import 'package:yande/widget/imageGrid/myImageLazyLoadGrid.dart';
import 'package:yande/widget/progress.dart';
import 'dart:async';

class CollectImageView extends StatefulWidget {
  static const title = '收藏';
  static const route = '/collect';
  CollectImageView();

  @override
  State<StatefulWidget> createState() => _CollectImageViewState();
}

class _CollectImageViewState extends State<CollectImageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ImageModel> imageList = List();

  bool updateTagListLock = false;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
  }



  @override
  dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("收藏"),
      ),
      body: MyImageLazyLoadGrid(
        sourceName: DaoDataSource.name,
        cardBuilder: (image) => MainImageCard(
          image,
          imageTap: (ImageModel image) => this._goImageStatus(image),
          collectEvent: () => this.collectAction(image),
          downloadEvent: () => this.downloadAction(image),
          heroPrefix: '${image.pages}collect',
        ),
      ),
    );
  }

  _goImageStatus(ImageModel image){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) {
              return ImageStatusView(
                image: image,
              );
            }
        ));
  }

  Future<void> collectAction(ImageModel image) async {
    image = await ImageService.collectImage(image);
    if (this.mounted) {
      setState(() {});
    }
  }

  void downloadAction(ImageModel image) async{
    if (image.downloadStatus != ImageDownloadStatus.pending
        && image.downloadStatus != ImageDownloadStatus.success) {
      this._showMessageBySnackbar("开始下载");
      if (this.mounted) {
        setState(() {});
      }
      await DownloadService.downloadImage(image);
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  _showMessageBySnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}