import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:yande/utils/utils.dart';
import 'package:yande/widget/allWidget.dart';

class DirectoryPickerView extends StatefulWidget {

  final String path;
  DirectoryPickerView(this.path): assert(path != null);

  @override
  State<StatefulWidget> createState() => _DirectoryPickerView();

}

class _DirectoryPickerView extends State<DirectoryPickerView>{

  bool isLoading = true;
  List<Directory> dirList;
  Directory currentDir;
  String rootPath;

  @override
  void initState() {
    super.initState();
    this.getRootPath();
    this.getDirList(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: const Text('选择文件夹'),
      ),
      body: _buildDirList(),
      bottomNavigationBar: _buildConfirmBottomButton(context),
    );
  }

  Widget _buildDirList() {
    if (isLoading) {
      return new Column(
        children: <Widget>[
          _buildDirPathHeader(),
          new Expanded(
            child:  new Center(
              child: new CenterProgress(),
            ),
          )
        ],
      );
    } else {
      return new Column(
        children: <Widget>[
          _buildDirPathHeader(),
          new Expanded(
            child: new ListView(
              children: _buildDirListTile(this.dirList),
            ),
          )
        ],
      );
    }
  }

  Future<void> getDirList(String path) async{

    this.isLoading = true;
    setState(() {

    });

    currentDir = new Directory(path);
    this.dirList =await FileUtils.getAllDirectoryChildren(
      new Directory(path)
    );

    this.isLoading = false;
    setState(() {

    });
  }

  List<Widget> _buildDirListTile(List<Directory> dirList) {
    List<Widget> listTiles = new List();
    if (this.currentDir.path != this.rootPath) {
      listTiles.add(new ListTile(
        leading: new Icon(Icons.folder_open),
        title: const Text('...'),
        onTap: () {
          this.getDirList(currentDir.parent.path);
        },
      ));
    }
    listTiles.addAll(
      this.dirList.map(
        (d) => new ListTile(
          leading: new Icon(
              Icons.folder,
              color: Colors.amberAccent,
          ),
          title: new Text(basename(d.path)),
          onTap: () {
            this.getDirList(d.path);
          },
        )
      )
    );
    return listTiles;
  }

  Future<void> getRootPath() async{
    this.rootPath =(await getExternalStorageDirectory()).path;
  }

  Widget _buildDirPathHeader() {
    return new Container(
      height: 40,
      width: double.infinity,
      padding: new EdgeInsets.only(
        left: 10,
      ),
      alignment: Alignment.centerLeft,
      decoration: new BoxDecoration(
        color: const Color(0xffeff0f1),
        border: new Border(
          bottom: new BorderSide(
            color: const Color(0xffcccccc)
          )
        )
      ),
      child: new Text(this.currentDir.path),
    );
  }

  _buildConfirmBottomButton(BuildContext context) {
      return new Container(
        height: 60,
        decoration: new BoxDecoration(
          border: new Border(
            top: new BorderSide(
              color: const Color(0xffcccccc)
            )
          )
        ),
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        child: new Row(
          children: <Widget>[
            NormalButton(
                '选择',
                onTap: () {
                  Navigator.pop(context, this.currentDir.path);
                },
            ),
            NormalButton(
              '取消',
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
  }

}

class NormalButton extends StatelessWidget {

  final String text;
  final GestureTapCallback onTap;

  NormalButton(this.text, {this.onTap});

  @override
  Widget build(BuildContext context) {

    return new Expanded(
      child: new Material(
        child: new InkWell(
          onTap: this.onTap,
          child: new Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: new Text(text),
          ),
        ),
      ),
    );
  }

}