
import 'package:flutter/material.dart';
import 'package:yande/model/image_model.dart';

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
    List<Widget> list = List();

    int id = image.id;
    list.add(_ImageStatusListTile("Id", "$id"));

    int width = image.width;
    int height = image.height;
    list.add(_ImageStatusListTile("Size", "$width x $height"));

    String source = image.source;
    if (source != null) {
      list.add(_ImageStatusListTile("Source", source));
    }

    list.add(_ImageStatusListTile("Rating", image.rating));


    return list;
  }
}

class _ImageStatusListTile extends StatelessWidget {

  final String name;
  final String value;

  _ImageStatusListTile(this.name, this.value);


  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: (){
          print("Copy!");
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 10,
            right: 10
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: const Color(0xffcccccc),
                      style: BorderStyle.solid
                  )
              )
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 20
                ),
                child: SizedBox(
                  width: 80,
                  child: _imageStatusListText(this.name),
                ),
              ),
              Expanded(
                child: _imageStatusListText(this.value)
              )
            ],
          ),
        ),
      ),
    );
  }

  Text _imageStatusListText(String value) {
    return Text(
      value,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}