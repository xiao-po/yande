import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/widget/allWidget.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/service/allServices.dart';
import 'package:yande/store/store.dart';
import 'dart:async';

class ResultView extends StatefulWidget {
  final String tags;

  ResultView({this.tags});

  @override
  State<StatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isShortcut;

  bool updateTagListLock = false;
  bool noImageLoad = false;

  String filterRank;

  Key get fabKey => new ValueKey<String>('resultViewFabkey');

  @override
  void initState() {
    super.initState();
    this.getShortcutStatus();
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
        child: new MyImageLazyLoadGrid(
          searchTag: this.widget.tags,
          cardBuilder: (image) =>  _buildImageCard(image),
        ),
      ),
      floatingActionButton: _buildFloatingButton(),
    );
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
    if (this.mounted) {
      setState(() {});
    }
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

  void _deleteShortcut(String tag) async{

    TagStore.unCollectTag(new TagModel(null, tag, null, null, null));
    this.isShortcut = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  void _addShortcut(String tag) async {
    TagStore.collectTag(new TagModel(null, tag, null, null, null));
    this.isShortcut = true;
    if (this.mounted) {
      setState(() {});
    }
  }

  void getShortcutStatus() {
    this.isShortcut = TagStore.isCollectByName(widget.tags);
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
