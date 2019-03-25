import 'package:flutter/material.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/service/allServices.dart';
import 'package:yande/store/tagStore.dart';
import 'dart:async';

typedef ImageCardBuilder = Widget Function(ImageModel image);

class MyImageLazyLoadGrid extends StatefulWidget {
  final int crossAxisCount;
  final Widget footer;
  final String heroPrefix;
  final ImageCardBuilder cardBuilder;
  final String searchTag;

  final int pages;
  final int limit;
  MyImageLazyLoadGrid({
    this.crossAxisCount = 2,
    this.cardBuilder,
    this.heroPrefix,
    this.pages = 1,
    this.searchTag,
    this.limit = 20,
    this.footer = const FootProgress(),
  });

  @override
  _MyImageLazyLoadGridState createState() => _MyImageLazyLoadGridState();
}

class _MyImageLazyLoadGridState extends State<MyImageLazyLoadGrid> {
  ScrollController controller = new ScrollController();
  List<ImageModel> imageList = new List();
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
    Widget footer = new FootProgress();
    if (this.noImageLoad) {
      footer = new Center(
        child: const Text("没有更多图片了"),
      );
    }
    if (imageList.length > 0) {
      return new RefreshIndicator(
        child: new LazyLoadGridView(
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
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  Widget buildErrorContent() {
    return new GestureDetector(
      child: new Container(
        height: double.infinity,
        width: double.infinity,
        child: new Center(
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
      List<ImageModel> imageList =
          await _getImageListByPagesAndLimit(pages, limit);
      this._updateImageList(imageList);
    } catch (e) {
      print(e);
    }
  }

  /// 事件方法，允许修改数据
  Future<void> reloadGallery() async {
    this.pages = 1;
    this.isInitError = false;
    this.imageList = new List();
    if (this.mounted) {
      setState(() {});
    }
    try {
      this.imageList =
          await _getImageListByPagesAndLimit(this.pages, this.limit);
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
  Future<List<ImageModel>> _getImageListByPagesAndLimit(int pages, int limit,
      [List<ImageModel> oldList]) async {
    this.loadingStatus = GridViewLoadingStatus.pending;

    try {
      List<ImageModel> imageList;
      if (this.widget.searchTag != null) {
        imageList = await ImageService.getIndexListByTags(
            this.widget.searchTag, pages, limit);
      } else {
        imageList = await ImageService.getIndexListByPage(pages, limit);
      }

      if (imageList.length == 0) {
        this.noImageLoad = true;
      }

      await getRankFilter();
      imageList.removeWhere(_imageFilter);
      imageList.removeWhere((image) => TagStore.isBlockedByName(image.tags));

      this.loadingStatus = GridViewLoadingStatus.success;
      if (oldList != null && oldList.length > 0) {
        imageList.addAll(oldList);
      }

      this.pages++;

      if (imageList.length > 10) {
        return imageList;
      } else {
        return await this
            ._getImageListByPagesAndLimit(this.pages, this.limit, imageList);
      }
    } catch (e) {
      this.loadingStatus = GridViewLoadingStatus.error;
      throw e;
    }
  }

  Future<void> getRankFilter() async {
    SettingItem filterRankItem =
        await SettingService.getSetting(SETTING_TYPE.FILTER_RANK);
    this.filterRank = filterRankItem.value;
  }

  /// @Param imageList 新的图片
  void _updateImageList(List<ImageModel> imageList) {
    this.imageList.addAll(imageList);
    if (this.mounted) {
      setState(() {});
    }
  }

  bool _imageFilter(ImageModel image) {
    if (this.filterRank == FILTER_RANK.RESTRICTED) {
      return false;
    } else if (this.filterRank == FILTER_RANK.NOT_RESTRICTED) {
      return image.rating == FILTER_RANK.RESTRICTED ? true : false;
    } else {
      return image.rating == FILTER_RANK.RESTRICTED ||
              image.rating == FILTER_RANK.NOT_RESTRICTED
          ? true
          : false;
    }
  }

  @override
  dispose() {
    super.dispose();
    this.controller.dispose();
  }
}
