import 'package:flutter/material.dart';
import '../allView.dart';
import 'package:yande/model/all_model.dart';
import 'components/status_dialog.dart';
import 'package:yande/service/services.dart';
import 'components/imageStatusAppBar.dart';

class ImageStatusView extends StatefulWidget {
  static final String route = "/status";
  static final String title = "imageStatus";

  final ImageModel image;

  ImageStatusView({this.image});

  @override
  State<StatefulWidget> createState() => _ImageStatusView();
}

class _ImageStatusView extends State<ImageStatusView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: _buildMaterialButton(),
      body: new Container(
        child: new CustomScrollView(
          slivers: <Widget>[
            new ImageStatusSliverAppBar(
              image: widget.image,
              showDialog: () {
                showDialog(
                    context: context,
                    builder: (context) => ImageStatusDialog(widget.image));
              },
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                  new ImageActionButtonFiled(
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
                  new TagChipFiled(
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
    Icon icon = null;
    if (widget.image.collectStatus == ImageCollectStatus.star) {
      icon = new Icon(
        Icons.star,
        size: 30,
        color: Colors.amberAccent,
      );
    } else {
      icon = new Icon(
        Icons.star_border,
        size: 30,
      );
    }
    return new FloatingActionButton(
      child: icon,
      onPressed: () async{
        ImageModel image = await ImageService.collectImage(widget.image);
        widget.image.collectStatus = image.collectStatus;
        setState(() {

        });
      },
    );
  }

  Widget _buildSearchChip(TagModel tag) {
    return new Container(
      margin: new EdgeInsets.only(
        left: 5,
        right: 5
      ),
      child: ActionChip(
        backgroundColor: Color(0x44eeeeee),
        label: Text(tag.name),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) {
                    return new ResultView(
                      tags: tag.name,
                    );
                  }
              )
          );
        },

      ),
    );
  }

  void viewImage(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) {
              return ImageGalleryView(
                image: widget.image,
              );
            }
        ));
  }

  Widget _buildLargeButton(String name, {Function onPressed}) {
    return new Expanded(
      child: new MaterialButton(
        onPressed: onPressed,
        child: new SizedBox(
          height: 50,
          child: new Center(
            child: new Text(
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
      setState(() {

      });
      await DownloadService.downloadImage(
          image
      );
      setState(() {

      });
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
      new SnackBar(content: Text(text)),
    );
  }
}

class TagChipFiled extends StatelessWidget {
  final List<Widget> children;

  TagChipFiled({this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: new EdgeInsets.only(
        left: 40,
        right: 40,
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border(
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
      child: new Wrap(
        children: this.children,
      ),
    );
  }
}
