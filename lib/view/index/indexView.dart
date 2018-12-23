import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/view/index/components/drawer.dart';
import 'package:yande/service/services.dart';
import 'components/lazyloadGridview.dart';
import 'components/imageCard.dart';

class IndexView extends StatefulWidget {
  static final String route = "/";
  static final String title = "yande";

  IndexView();

  @override
  State<IndexView> createState() => _IndexView();

}

class _IndexView extends State<IndexView> {
  ScrollController _controller;
  List<ImageModel> imageList = new List();

  bool loadingStatus = false;
  int pages = 1;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController()..addListener(_scrollListener);
    this._reloadGallery();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(IndexView.title),
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
                imageTap: (ImageModel image) {
                  this._goImageStatus(image);
                },
                collectEvent: (){

                },
                downloadEvent: (){

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
  Future<List<ImageModel>> _getImageListByPagesAndLimit(int pages,int limit) async {
    this.loadingStatus = true;
    print(pages);
    List<ImageModel> newImageList =
      await IndexService.getIndexListByPage(pages, limit);
    this.loadingStatus = false;
    return newImageList;
  }


  Future<void> _loadPage(int pages,int limit) async {
    this._updateImageList(await _getImageListByPagesAndLimit(pages, limit));
  }


  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    this.imageList.addAll(imageList);
    setState(() {});
  }
}