import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/widget/imageGrid/lazyloadGridview.dart';
import 'package:yande/widget/imageGrid/imageCard.dart';
import 'package:yande/service/allServices.dart';
import 'dart:async';

class ResultView extends StatefulWidget {
  final String tags;

  ResultView({this.tags});

  @override
  State<StatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _controller;
  List<ImageModel> imageList = new List();
  bool isShortcut;

  bool updateTagListLock = false;
  bool loadingStatus = false;
  bool noImageLoad = false;
  int pages = 1;
  int limit = 20;

  Key get fabKey => new ValueKey<String>('resultViewFabkey');

  @override
  void initState() {
    super.initState();
    this.getShortcutStatus();
    _controller = new ScrollController()..addListener(_scrollListener);
    this._loadPage(this.pages, this.limit);
  }

  void _scrollListener() {
    if (_controller.position.extentAfter < 50 && !loadingStatus) {
      this.pages++;
      this._loadPage(this.pages, this.limit);
    }
  }

  @override
  dispose() {
    super.dispose();
    this._controller.dispose();
  }

  Future<void> _loadPage(int pages, int limit) async {
    this._updateImageList(await _getImageListByPagesAndLimit(pages, limit));
  }

  /// @Param pages 页码
  /// @Param limit 每页显示条数
  Future<List<ImageModel>> _getImageListByPagesAndLimit(
      int pages, int limit, [List<ImageModel> oldList]) async {
    this.loadingStatus = true;
    List<ImageModel> imageList =
        await ImageService.getIndexListByTags(widget.tags, pages, limit);
    SettingItem filterRankItem =await SettingService.getSetting(SETTING_TYPE.FILTER_RANK);
    imageList.removeWhere((image) {
      if (filterRankItem.value != FILTER_RANK.RESTRICTED) {
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

  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    if (imageList.length == 0) {
      this.noImageLoad = true;
    }
    this.imageList.addAll(imageList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text("搜索： ${widget.tags}", overflow: TextOverflow.ellipsis,),
      ),
      body: new Container(
        child: _buildImageContent(this.imageList),
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  _buildImageContent(List<ImageModel> imageList) {
    Widget footer = new FootProgress();
    if (this.noImageLoad) {
      footer = new Center(
        child: const Text("没有更多图片了"),
      );
    }
    if (imageList.length > 0) {
      return new LazyLoadGridView(
        controller: _controller,
        children: imageList
            .map((image) => MainImageCard(
                  image,
                  imageTap: (ImageModel image) {
                    this._goImageStatus(image);
                  },
                  collectEvent: () {
                    this.collectAction(image);
                  },
                  heroPrefix: '${image.pages}result',
                  downloadEvent: () {
                    DownloadService.downloadImage(image);
                  },
                ))
            .toList(),
        footer: footer,
      );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  _goImageStatus(ImageModel image) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageStatusView(
        image: image,
      );
    }));
  }

  Future<void> collectAction(ImageModel image) async {
    image = await ImageService.collectImage(image);
    setState(() {});
  }

  _buildFloatingButton() {
    if (this.isShortcut == false) {
      return new FloatingActionButton(
          key: this.fabKey,
          child: new Icon(
            Icons.add,
          ),
          onPressed: () {
            this._addShortcut(widget.tags);
          });
    } else if (this.isShortcut == true) {
      return new FloatingActionButton(
          key: new ValueKey(this.fabKey),
          child: new Icon(
            Icons.delete,
          ),
          backgroundColor: Colors.red,
          onPressed: () {
            this._addShortcut(widget.tags);
          });
    } else {
      return new Container();
    }
  }

  void _addShortcut(String tags) async {
    if (this.isShortcut) {
      ShortCutService.deleteShortCutWord(tags);
      this.isShortcut = false;
    } else {
      ShortCutService.addShortCutWord(tags);
      this.isShortcut = true;
    }
    setState(() {});
  }

  void getShortcutStatus() async {
    this.isShortcut = await ShortCutService.isShortcutExist(widget.tags);
    setState(() {});
  }
}
