import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/view/index/components/drawer.dart';
import 'package:yande/service/services.dart';
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
  bool loadingStatus = false;
  int pages = 1;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    MyDateBase.initDateBase();
    SettingService.initSetting();
//    this.test();
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
          children: imageList.map((image) =>
              MainImageCard(
                image,
                heroPrefix: 'index',
                imageTap: (ImageModel image) {
                  this._goImageStatus(image);
                },
                collectEvent: (){
                  this.collectAction(image);
                },
                downloadEvent: (){
                  this.downloadAction(image);
                },
              )
          ).toList(),
        ),
        onRefresh: _reloadGallery,
      );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
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


  void _scrollListener() {
    if (_controller.position.extentAfter < 50 && !loadingStatus ) {
      this.pages++;
      this._loadPage(this.pages, this.limit);
    }
  }


  /// 事件方法，允许修改数据
  Future<void> _reloadGallery() async {
    this.pages = 1;
    this.imageList =await _getImageListByPagesAndLimit(pages, this.limit);
    setState(() {
    });
  }

  /// @Param pages 页码
  /// @Param limit 每页显示条数
  Future<List<ImageModel>> _getImageListByPagesAndLimit(int pages,int limit, [List<ImageModel> oldList]) async {
    this.loadingStatus = true;
    List<ImageModel> imageList =
      await ImageService.getIndexListByPage(pages, limit);
    SettingItem filterRankItem =await SettingService.getSetting(SETTING_TYPE.FILTER_RANK);
    imageList.removeWhere((image) {
      if (filterRankItem.value == FILTER_RANK.RESTRICTED) {
        return false;
      } else if (filterRankItem.value == FILTER_RANK.NOT_RESTRICTED) {
        return image.rating == FILTER_RANK.RESTRICTED ? true : false;
      } else {
        return image.rating == FILTER_RANK.RESTRICTED
            || image.rating == FILTER_RANK.NOT_RESTRICTED ? true : false;
      }
    });
    this.loadingStatus = false;
    if (oldList != null && oldList.length > 0) {

      imageList.addAll(oldList);
    }
    if (imageList.length > 10) {
      return imageList;
    } else {
      print('not enough 10');
      this.pages++;
      return await this._getImageListByPagesAndLimit(this.pages, this.limit, imageList);
    }
  }


  Future<void> _loadPage(int pages,int limit) async {
    List<ImageModel> imageList = await _getImageListByPagesAndLimit(pages, limit);
    this._updateImageList(imageList);
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return TagSearchView();
                }
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
        && image.downloadStatus != ImageDownloadStatus.success
    ) {
      this._showMessageBySnackbar("开始下载");
      setState(() {

      });
      await DownloadService.downloadImage(
          image
      );
      setState(() {

      });
    }
  }


  _showMessageBySnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(content: Text(text)),
    );
  }
}
