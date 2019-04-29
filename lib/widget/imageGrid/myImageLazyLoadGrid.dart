import 'package:flutter/material.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/service/imageServive.dart';
import 'package:yande/widget/imageGrid/lazyloadView.dart';
import 'dart:async';

import 'package:yande/widget/progress.dart';

typedef ImageCardBuilder = Widget Function(ImageModel image);

class MyImageLazyLoadGrid extends StatefulWidget {
  final int crossAxisCount;
  final Widget footer;
  final String heroPrefix;
  final ImageCardBuilder cardBuilder;
  final String searchTag;

  final int pages;
  final int limit;

  final String sourceName;

  MyImageLazyLoadGrid({
    this.crossAxisCount = 2,
    this.cardBuilder,
    this.heroPrefix,
    this.pages = 1,
    this.searchTag,
    this.limit = 20,
    this.sourceName = null,
    this.footer = const FootProgress(),
  });

  @override
  _MyImageLazyLoadGridState createState() => _MyImageLazyLoadGridState();
}

class _MyImageLazyLoadGridState extends State<MyImageLazyLoadGrid> {
  ScrollController controller = ScrollController();
  List<ImageModel> imageList = List();
  GridViewLoadingStatus loadingStatus = GridViewLoadingStatus.pending;
  bool isInitError = false;
  String filterRank;
  bool noImageLoad = false;
  int pages;
  int limit;

  @override
  void initState() {
    super.initState();
    this.pages = this.widget.pages;
    this.limit = this.widget.limit;
    this.controller.addListener(this.scrollListener);
    this.reloadGallery();
  }

  @override
  Widget build(BuildContext context) {
    Widget footer = FootProgress();
    if (this.noImageLoad) {
      footer = Center(
        child: const Text("没有更多图片了"),
      );
    }
    if (imageList.length > 0) {
      return RefreshIndicator(
        child: LazyLoadGridView(
          controller: this.controller,
          heroPrefix: this.widget.heroPrefix,
          children: imageList.map(this.widget.cardBuilder).toList(),
          footer: footer,
        ),
        onRefresh: this.reloadGallery,
      );
    } else if (this.isInitError == true) {
      return buildErrorContent();
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget buildErrorContent() {
    return GestureDetector(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: const Text(
            '加载失败了呢~\n点击重试',
            textAlign: TextAlign.center,
            style: const TextStyle(color: const Color(0xffcccccc)),
          ),
        ),
      ),
      behavior: HitTestBehavior.translucent,
      onTap: () => this.reloadGallery(),
    );
  }

  void scrollListener() {
    if (this.controller.position.extentAfter < 50 &&
        this.loadingStatus != GridViewLoadingStatus.pending) {
      this._loadPage(this.pages, this.limit);
    }
  }

  Future<void> _loadPage(int pages, int limit) async {
    try {
      List<ImageModel> imageList = await _getImageList();
      this._updateImageList(imageList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> reloadGallery() async {
    this.pages = 1;
    this.isInitError = false;
    if (this.mounted) {
      setState(() {});
    }
    try {
      this.imageList = await _getImageList();
    } catch (e) {
      if (this.loadingStatus == GridViewLoadingStatus.error) {
        this.isInitError = true;
      }
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  /// @Param pages 页码
  /// @Param limit 每页显示条数
  Future<List<ImageModel>> _getImageList() async {
    this.loadingStatus = GridViewLoadingStatus.pending;

    try {
      List<ImageModel> imageList = [];
      var loadedPages = 0;
      while (imageList.length < 10 && loadedPages < 5) {
        try {
          if (this.widget.searchTag != null) {
            imageList.addAll(await ImageService.getImageByTag(
                this.widget.searchTag, pages, limit, sourceName: this.widget.sourceName));
          } else {
            imageList.addAll(await ImageService.getIndexListByPage(
              pages,
              limit,
              sourceName: this.widget.sourceName,
            )
            );
          }
          pages++;
          loadedPages++;
        } catch(e) {
          if (e is NoImageError) {
            this.noImageLoad = true;
            break;
          } else {
            throw e;
          }
        }

      }

      this.loadingStatus = GridViewLoadingStatus.success;
      return imageList;
    } catch (e) {
      this.loadingStatus = GridViewLoadingStatus.error;
      throw e;
    }
  }

  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    this.imageList.addAll(imageList);
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  dispose() {
    super.dispose();
    this.controller.dispose();
  }
}

enum GridViewLoadingStatus { pending, success, error }
