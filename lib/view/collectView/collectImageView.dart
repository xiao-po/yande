import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/widget/imageGrid/lazyloadGridview.dart';
import 'package:yande/widget/imageGrid/imageCard.dart';
import 'package:yande/service/services.dart';

class CollectImageView extends StatefulWidget {

  CollectImageView();

  @override
  State<StatefulWidget> createState() => _CollectImageViewState();
}

class _CollectImageViewState extends State<CollectImageView> {
  ScrollController _controller;
  List<ImageModel> imageList = new List();

  bool updateTagListLock = false;
  bool loadingStatus = false;
  bool noImageLoad = false;
  int pages = 1;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController()..addListener(_scrollListener);
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
    List<ImageModel> newImageList =await ImageService.getAllCollectedImage(pages, limit);
    this.loadingStatus = false;
    return newImageList;
  }

  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    if (imageList.length == 0 ) {
      this.noImageLoad = true;
    }
    this.imageList.addAll(imageList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: const Text("收藏"),
      ),
      body: new Container(
        child: _buildImageContent(this.imageList),
      ),
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
        children: imageList.map((image) =>
            MainImageCard(
              image,
              imageTap: (ImageModel image) {
                this._goImageStatus(image);
              },
              collectEvent: (){
                this.collectAction(image);
              },
              downloadEvent: (){
                DownloadService.downloadImage(image);
              },
            )
        ).toList(),
        footer: footer,
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

  Future<void> collectAction(ImageModel image) async {
    image = await ImageService.collectImage(image);
    setState(() {

    });
  }
}