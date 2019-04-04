import 'package:flutter/material.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'package:yande/service/downloadService.dart';
import 'package:yande/service/imageServive.dart';
import 'package:yande/view/imageGallery/imageGalleryView.dart';
import 'package:yande/view/search/resultView.dart';
import 'package:yande/widget/button.dart';
import 'components/status_dialog.dart';
import 'components/imageStatusAppBar.dart';

class ImageStatusView extends StatefulWidget {
  static final String route = "/status";
  static final String title = "imageStatus";

  final ImageModel image;
  final String heroPrefix;

  ImageStatusView({this.image, this.heroPrefix});

  @override
  State<StatefulWidget> createState() => _ImageStatusView();
}

class _ImageStatusView extends State<ImageStatusView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Key get fabKey => ValueKey<String>('imageStatusFabkey');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: _buildMaterialButton(),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            ImageStatusSliverAppBar(
              image: widget.image,
              heroPrefix: widget.heroPrefix,
              showDialog: () => this._showImageStatus(),
            ),
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  ImageActionButtonFiled(
                    children: <Widget>[
                      _buildLargeButton(
                        "查看",
                        onPressed: () => this.viewImage(),
                      ),
                      _buildDownloadButton(
                        widget.image,
                        onPressed: () => this.downloadAction(widget.image),
                      )
                    ],
                  ),
                  TagChipFiled(
                    children: widget.image.tagTagModelList.map((tag) => _buildSearchChip(tag)).toList(),
                  )
                ]
                )
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildMaterialButton() {
    if (widget.image.collectStatus == ImageCollectStatus.star) {
      return _buildAddCollectFloatingButton();
    } else {
      return _buildDeleteCollectFloatingButton();
    }

  }

  FloatingActionButton _buildDeleteCollectFloatingButton() {
    return FloatingActionButton(
      key: this.fabKey,
      child: Icon(
        Icons.star_border,
        size: 30,
      ),
      onPressed: () => this.collectEvent(),
    );
  }

  void collectEvent() async{

    ImageModel image = await ImageService.collectImage(widget.image);
    widget.image.collectStatus = image.collectStatus;
    if (this.mounted) {
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  FloatingActionButton _buildAddCollectFloatingButton() {
    return FloatingActionButton(
      key: ValueKey(this.fabKey),
      child: Icon(
        Icons.star,
        size: 30,
        color: Colors.amberAccent,
      ),
      onPressed: () => this.collectEvent(),
    );
  }

  Widget _buildSearchChip(TagModel tag) {
    return Container(
      margin: EdgeInsets.only(
          left: 5,
          right: 5
      ),
      child: _tagChip(tag),
    );
  }

  TagChip _tagChip(TagModel tag) {
    return TagChip(
        backgroundColor: Color(0x44eeeeee),
        label: Text(tag.name),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultView(tags: tag.name))
        ),
        onLongPress: () {
          print('tag LongPress');
        },

    );
  }

  void viewImage(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) {
              return ImageGalleryView(
                image: widget.image,
                heroPrefix: widget.heroPrefix,
              );
            }
        ));
  }

  Widget _buildLargeButton(String name, {Function onPressed}) {
    return Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              name,
            ),
          ),
        ),
      ),
    );
  }

  void downloadAction(ImageModel image) async{
    if (image.downloadStatus != ImageDownloadStatus.pending
        && image.downloadStatus != ImageDownloadStatus.success
    ) {
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

  Widget _buildDownloadButton(ImageModel image, {void Function() onPressed}) {
    if (image.downloadStatus == ImageDownloadStatus.pending) {
      return _buildLargeButton("正在下载");
    } else if (image.downloadStatus == ImageDownloadStatus.success) {
      return _buildLargeButton("已经下载");
    } else {
      return _buildLargeButton(
        "下载",
        onPressed: () => this.downloadAction(
            image
        ),
      );
    }

  }

  _showMessageBySnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  _showImageStatus() {
    showDialog(
        context: context,
        builder: (context) => ImageStatusDialog(widget.image)
    );
  }
}

class TagChipFiled extends StatelessWidget {
  final List<Widget> children;

  TagChipFiled({this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(
        left: 40,
        right: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xffeaeaea),
            width: 1,
          ),
          bottom: BorderSide(
            color: Color(0xffeaeaea),
            width: 1,
          )
        )
      ),
      child: Wrap(
        children: this.children,
      ),
    );
  }
}
