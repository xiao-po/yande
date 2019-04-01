import 'package:flutter/material.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/view/imageStatus/imageStatusView.dart';
import 'package:yande/widget/imageGrid/imageCard.dart';
import 'package:yande/widget/imageGrid/lazyloadView.dart';
import 'package:yande/widget/progress.dart';
import 'dart:async';
import 'package:yande/service/allServices.dart';

class CollectImageView extends StatefulWidget {
  static const title = '收藏';
  static const route = '/collect';
  CollectImageView();

  @override
  State<StatefulWidget> createState() => _CollectImageViewState();
}

class _CollectImageViewState extends State<CollectImageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _controller;
  List<ImageModel> imageList = List();

  bool updateTagListLock = false;
  bool loadingStatus = false;
  bool noImageLoad = false;
  bool isInit = true;
  int pages = 1;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
    this._loadPage(this.pages, this.limit);
  }


  void _scrollListener() {
    if (_controller.position.extentAfter < 50 && !loadingStatus ) {
      this.pages++;
      this._loadPage(this.pages, this.limit);
    }
  }


  @override
  dispose(){
    super.dispose();
    this._controller.dispose();
  }

  Future<void> _loadPage(int pages,int limit) async {
    this._updateImageList(await _getImageListByPagesAndLimit(pages, limit));
  }

  /// @Param pages 页码
  /// @Param limit 每页显示条数
  Future<List<ImageModel>> _getImageListByPagesAndLimit(int pages,int limit) async {
    this.loadingStatus = true;
    List<ImageModel> imageList =await ImageService.getAllCollectedImage(pages, limit);
    this.loadingStatus = false;
    this.isInit = false;
    return imageList;
  }

  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    if (imageList.length == 0 ) {
      this.noImageLoad = true;
    }
    this.imageList.addAll(imageList);
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("收藏"),
      ),
      body: Container(
        child: _buildImageContent(this.imageList),
      ),
    );
  }

  _buildImageContent(List<ImageModel> imageList) {
    Widget footer = FootProgress();
    if (this.noImageLoad) {
      footer = Center(
        child: const Text("没有更多图片了"),
      );
    }
    if (imageList.length > 0) {
      return LazyLoadGridView(
        controller: _controller,
        children: imageList.map((image) =>
            MainImageCard(
              image,
              imageTap: (ImageModel image) => this._goImageStatus(image),
              collectEvent: () => this.collectAction(image),
              downloadEvent: () => this.downloadAction(image),
              heroPrefix: '${image.pages}collect',
            )
        ).toList(),
        footer: footer,
      );
    } else {
      if (this.isInit) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
          child: Center(
            child: const Text(
                '你没有收藏任何图片',
                style: TextStyle(
                    color: Color(0xffcccccc)
                ),
            ),
          ),
        );
      }
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