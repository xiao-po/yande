import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/value.dart';
import 'package:yande/view/index/components/drawer.dart';
import 'package:yande/service/allServices.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:yande/widget/imageGrid/lazyloadGridview.dart';
import 'package:yande/widget/imageGrid/imageCard.dart';
import 'package:yande/dao/init_dao.dart';

import 'dart:async';

class IndexView extends StatefulWidget {
  static final String route = "/";
  static final String title = "yande";

  IndexView();

  @override
  State<IndexView> createState() => _IndexView();

}

class _IndexView extends State<IndexView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: new Text(IndexView.title),
        actions: <Widget>[
          _buildSearchButton(),
        ],
      ),
      drawer: new LeftDrawer(),
      endDrawer: new RightDrawer(),
      body: new Container(
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
    return new IconButton(
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
      new SnackBar(content: Text(text)),
    );
  }

}

