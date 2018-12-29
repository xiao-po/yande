import 'package:flutter/material.dart';
import '../imageGallery/imageGalleryView.dart';
import 'package:yande/model/all_model.dart';
import 'components/status_dialog.dart';
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                        onPressed: () {
                          this.viewImage();
                        },
                      ),
                      _buildLargeButton(
                        "下载",
                        onPressed: () {
                          // TODO:
                        },
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
          // todo: serachTag
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
