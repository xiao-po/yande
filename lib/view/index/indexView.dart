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

  ScrollController _controller;
  List<ImageModel> imageList = new List();

  bool updateTagListLock = false;
  GridViewLoadingStatus loadingStatus = GridViewLoadingStatus.pending;
  bool isInitError = false;
  int pages = 1;
  int limit = 20;

  String filterRank;

  @override
  void initState() {
    super.initState();
    MyDateBase.initDateBase();
    SettingService.initSetting();

    UpdateService.ignoreUpdateVersion('');
    this.checkUpdate();
    _controller = new ScrollController()..addListener(_scrollListener);
    this._reloadGallery();
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
        child: _buildImageContent(this.imageList),
      ),
    );
  }


  _buildImageContent(List<ImageModel> imageList) {
    if (imageList.length > 0) {
      return new RefreshIndicator(
        child: new LazyLoadGridView(
          controller: _controller,
          children: imageList.map(_buildImageCard).toList(),
        ),
        onRefresh: this._reloadGallery,
      );
    } else if (this.isInitError == true) {
      return new GestureDetector(
        child: new Container(
          height: double.infinity,
          width: double.infinity,
          child: new Center(
            child: const Text(
                '加载失败了呢~\n点击重试',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: const Color(0xffcccccc)
                ),
            ),
          ),
        ),
        onTap: () => this._reloadGallery(),
      );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
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


  void _scrollListener() {
    if (_controller.position.extentAfter < 50 && this.loadingStatus != GridViewLoadingStatus.pending ) {
      this.pages++;
      this._loadPage(this.pages, this.limit);
    }
  }


  /// 事件方法，允许修改数据
  Future<void> _reloadGallery() async {
    this.pages = 1;
    this.isInitError = false;
    this.imageList = new List();
    try{
      this.imageList = await _getImageListByPagesAndLimit(pages, this.limit);
    }catch(e) {
      if (this.loadingStatus == GridViewLoadingStatus.error) {
        this.isInitError = true;
      }
    }
    setState(() {
    });
  }

  /// @Param pages 页码
  /// @Param limit 每页显示条数
  Future<List<ImageModel>> _getImageListByPagesAndLimit
      (int pages,int limit, [List<ImageModel> oldList]) async {

    this.loadingStatus = GridViewLoadingStatus.pending;

    try{
      List<ImageModel> imageList =await ImageService.getIndexListByPage(pages, limit);

      SettingItem filterRankItem =await SettingService.getSetting(SETTING_TYPE.FILTER_RANK);
      this.filterRank = filterRankItem.value;
      imageList.removeWhere(_imageFilter);

      this.loadingStatus = GridViewLoadingStatus.success;
      if (oldList != null && oldList.length > 0) {

        imageList.addAll(oldList);
      }
      if (imageList.length > 10) {
        return imageList;
      } else {
        this.pages++;
        return await this._getImageListByPagesAndLimit(this.pages, this.limit, imageList);
      }
    }catch(e){
      this.loadingStatus = GridViewLoadingStatus.error;
      throw e;
    }

  }


  Future<void> _loadPage(int pages,int limit) async {
    try{
      List<ImageModel> imageList = await _getImageListByPagesAndLimit(pages, limit);
      this._updateImageList(imageList);
    }catch(e) {
      print(e);
    }
  }


  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    this.imageList.addAll(imageList);
    setState(() {});
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
    setState(() {

    });
  }

  void downloadAction(ImageModel image) async{
    if (image.downloadStatus != ImageDownloadStatus.pending
        && image.downloadStatus != ImageDownloadStatus.success) {
      this._showMessageBySnackbar("开始下载");
      setState(() {});
      await DownloadService.downloadImage(image);
      setState(() {});
    }
  }


  _showMessageBySnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(content: Text(text)),
    );
  }

  bool _imageFilter(ImageModel image) {
    if (this.filterRank == FILTER_RANK.RESTRICTED) {
      return false;
    } else if (this.filterRank == FILTER_RANK.NOT_RESTRICTED) {
      return image.rating == FILTER_RANK.RESTRICTED ? true : false;
    } else {
      return image.rating == FILTER_RANK.RESTRICTED
          || image.rating == FILTER_RANK.NOT_RESTRICTED ? true : false;
    }
  }

}

