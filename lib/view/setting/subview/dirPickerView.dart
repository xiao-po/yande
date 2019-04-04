import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:yande/utils/utils.dart';
import 'package:yande/widget/progress.dart';

class DirectoryPickerView extends StatefulWidget {

  final String path;
  DirectoryPickerView(this.path): assert(path != null);

  @override
  State<StatefulWidget> createState() => _DirectoryPickerView();

}

class _DirectoryPickerView extends State<DirectoryPickerView>{

  bool isLoading = true;
  List<MyDirectoryStat> dirList;
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('选择文件夹'),
      ),
      body: _buildDirList(),
      bottomNavigationBar: _buildConfirmBottomButton(context),
    );
  }

  Widget _buildDirList() {
    if (isLoading) {
      return Column(
        children: <Widget>[
          _buildDirPathHeader(),
          Expanded(
            child:  Center(
              child: CenterProgress(),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          _buildDirPathHeader(),
          Expanded(
            child: ListView(
              children: _buildDirListTile(this.dirList),
            ),
          )
        ],
      );
    }
  }

  Future<void> getDirList(String path) async{

    this.isLoading = true;
    if (this.mounted) {
      setState(() {});
    }

    currentDir = Directory(path);
    this.dirList =await FileUtils.getAllDirectoryChildren(
      Directory(path)
    );

    this.isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  List<Widget> _buildDirListTile(List<MyDirectoryStat> dirList) {
    List<Widget> listTiles = List();
    if (this.currentDir.path != this.rootPath) {
      listTiles.add(ListTile(
        leading: Icon(Icons.folder_open),
        title: const Text('...'),
        onTap: () {
          this.getDirList(currentDir.parent.path);
        },
      ));
    }
    listTiles.addAll(
      this.dirList.map(
        (d) => ListTile(
          leading: Icon(
              Icons.folder,
              color: Colors.amberAccent,
          ),
          title: Text(basename(d.path)),
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
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 10,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xffeff0f1),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xffcccccc)
          )
        )
      ),
      child: Text(this.currentDir.path),
    );
  }

  _buildConfirmBottomButton(BuildContext context) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: const Color(0xffcccccc)
            )
          )
        ),
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        child: Row(
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

    return Expanded(
      child: Material(
        child: InkWell(
          onTap: this.onTap,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(text),
          ),
        ),
      ),
    );
  }

}