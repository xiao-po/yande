import 'package:flutter/material.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/service/downloadService.dart';
import 'package:yande/service/imageServive.dart';
import 'package:yande/service/settingService.dart';
import 'package:yande/service/updateService.dart';
import 'package:yande/view/imageStatus/imageStatusView.dart';
import 'package:yande/view/index/components/drawer.dart';
import 'package:yande/view/search/searchView.dart';
import 'package:yande/widget/dialog.dart';
import 'package:yande/widget/imageGrid/imageCard.dart';
import 'package:yande/dao/init_dao.dart';

import 'dart:async';

import 'package:yande/widget/imageGrid/myImageLazyLoadGrid.dart';

class IndexView extends StatefulWidget {
  static final String route = "/";
  static final String title = "yande";

  IndexView();

  @override
  State<IndexView> createState() => _IndexView();

}

class _IndexView extends State<IndexView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool updateTagListLock = false;

  @override
  void initState() {
    super.initState();
    MyDateBase.initDateBase();
    SettingService.initSetting();

    UpdateService.ignoreUpdateVersion('');
    this.checkUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(IndexView.title),
        actions: <Widget>[
          _buildSearchButton(),
        ],
      ),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
      body: Container(
        child: _buildImageContent(),
      ),
    );
  }


  _buildImageContent() {
    return MyImageLazyLoadGrid(

      cardBuilder: (image) => _buildImageCard(image),
    );
  }

  MainImageCard _buildImageCard(image) =>
          MainImageCard(
            image,
            heroPrefix: '${image.pages}index',
            imageTap: (ImageModel image) => this._goImageStatus(image, '${image.pages}index'),
            collectEvent: () => this.collectAction(image),
            downloadEvent: () => this.downloadAction(image),
          );

  _goImageStatus(ImageModel image, String heroPrefix){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageStatusView(image: image, heroPrefix: heroPrefix)
        )
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      tooltip: 'Search',
      icon: const Icon(Icons.search),
      onPressed: () async {
        Navigator.pushNamed(context, TagSearchView.route );
      },
    );
  }

  void checkUpdate() {
    UpdateService.getVersion(
      shouldUpdate: (githubRelease){
        showDialog(
            context: context,
            builder: (context) => UpdateDialog(
              version: githubRelease.tagName,
              text: githubRelease.body,
              url: githubRelease.htmlUrl
            )
        );
      },
    );
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
        if (this.mounted) {
          setState(() {});
        }
      }
    }
  }


  _showMessageBySnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

}

