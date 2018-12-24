import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';

class ImageStatusDialog extends StatelessWidget {
  final ImageModel image;

  const ImageStatusDialog(this.image);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('图片详情'),
      children: _buildListItem(this.image),
    );
  }

  List<Widget> _buildListItem(ImageModel image) {
    List<Widget> list = new List();

    int id = image.id;
    list.add(new _ImageStatusListTile("Id", "$id"));

    int width = image.width;
    int height = image.height;
    list.add(new _ImageStatusListTile("Size", "$width x $height"));

    String source = image.source;
    if (source != null) {
      list.add(new _ImageStatusListTile("Source", source));
    }

    list.add(new _ImageStatusListTile("Rating", image.rating));


    return list;
  }
}

class _ImageStatusListTile extends StatelessWidget {

  final String name;
  final String value;

  _ImageStatusListTile(this.name, this.value);


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new InkWell(
        onTap: (){
          print("Copy!");
        },
        child: new Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 10,
            right: 10
          ),
          decoration: new BoxDecoration(
              border: Border(
                  bottom: new BorderSide(
                      color: const Color(0xffcccccc),
                      style: BorderStyle.solid
                  )
              )
          ),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: 20
                ),
                child: new SizedBox(
                  width: 80,
                  child: _imageStatusListText(this.name),
                ),
              ),
              new Expanded(
                child: _imageStatusListText(this.value)
              )
            ],
          ),
        ),
      ),
    );
  }

  Text _imageStatusListText(String value) {
    return new Text(
      this.name,
      overflow: TextOverflow.ellipsis,
      style: new TextStyle(
        fontSize: 16,
      ),
    );
  }
}