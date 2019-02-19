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
  GridViewLoadingStatus loadingStatus = GridViewLoadingStatus.pending;
  bool isInitError = false;
  bool noImageLoad = false;
  int pages = 1;
  int limit = 20;

  String filterRank;

  Key get fabKey => new ValueKey<String>('resultViewFabkey');

  @override
  void initState() {
    super.initState();
    this.getShortcutStatus();
    _controller = new ScrollController()..addListener(_scrollListener);
    this._reloadGallery();
  }

  void _scrollListener() {
    if (_controller.position.extentAfter < 50 && this.loadingStatus != GridViewLoadingStatus.pending) {
      this.pages++;
      this._loadPage(this.pages, this.limit);
    }
  }

  @override
  dispose() {
    super.dispose();
    this._controller.dispose();
  }

  /// 事件方法，允许修改数据
  Future<void> _reloadGallery() async {
    this.pages = 1;
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

  Future<void> _loadPage(int pages, int limit) async {
    try{
      this._updateImageList(await _getImageListByPagesAndLimit(pages, limit));
    }catch(e) {
      print(e);
    }
  }

  /// @Param pages 页码
  /// @Param limit 每页显示条数
  Future<List<ImageModel>> _getImageListByPagesAndLimit(
      int pages, int limit, [List<ImageModel> oldList]) async {
    this.loadingStatus = GridViewLoadingStatus.pending;

    try{

      List<ImageModel> imageList =
      await ImageService.getIndexListByTags(widget.tags, pages, limit);


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
    }catch(e) {
      this.loadingStatus = GridViewLoadingStatus.success;
      throw e;
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
      return new RefreshIndicator(
        child: new LazyLoadGridView(
          controller: _controller,
          children: imageList
              .map(_buildImageCard)
              .toList(),
          footer: footer,
        ),
        onRefresh: this._reloadGallery,
      );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  MainImageCard _buildImageCard(ImageModel image) {
    return MainImageCard(
      image,
      imageTap: (ImageModel image) => this._goImageStatus(image),
      collectEvent: () => this.collectAction(image),
      downloadEvent: () => this.downloadAction(image),
      heroPrefix: "${image.pages}result",
    );
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
      return _buildAddShortcutFloatingButton();
    } else if (this.isShortcut == true) {
      return _buildDeleteShortcutFloatingButton();
    } else {
      return new Container();
    }
  }

  FloatingActionButton _buildDeleteShortcutFloatingButton() {
      return new FloatingActionButton(
        key: new ValueKey(this.fabKey),
        child: new Icon(
          Icons.delete,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          this._deleteShortcut(widget.tags);
        });
  }

  FloatingActionButton _buildAddShortcutFloatingButton() {
    return new FloatingActionButton(
        key: this.fabKey,
        child: new Icon(
          Icons.add,
        ),
        onPressed: () {
          this._addShortcut(widget.tags);
        });
  }

  void _deleteShortcut(String tags) async{

    ShortCutService.deleteShortCutWord(tags);
    this.isShortcut = false;
    setState(() {});
  }

  void _addShortcut(String tags) async {
    ShortCutService.addShortCutWord(tags);
    this.isShortcut = true;
    setState(() {});
  }

  void getShortcutStatus() async {
    this.isShortcut = await ShortCutService.isShortcutExist(widget.tags);
    setState(() {});
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
