import 'package:flutter/material.dart';
import 'package:yande/model/tag_model.dart';
import 'package:yande/service/tagService.dart';
import 'resultView.dart';
import 'dart:async';

class TagSearchView extends StatefulWidget {
  static const title = 'Tag搜索';
  static const route = '/search';
  @override
  State<StatefulWidget> createState() => _TagSearchState();

}

class _TagSearchState extends State<TagSearchView> {

  List<TagModel> tagList = List();
  final TextEditingController _searchQuery = TextEditingController();
  bool isLoading = false;
  String lastSearchWord = "";

  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back,color: Colors.black45,),
      onPressed: (){
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this._searchQuery.addListener(this.onSearch);
  }

  @override
  void dispose() {
    super.dispose();
    this._searchQuery.dispose();

  }

  void onSearch() async{
    if (this.mounted) {
      setState(() {});
    }
    this.isLoading = true;
    List<TagModel> result =await this.searchTag(this._searchQuery.text);
    this.lastSearchWord = this._searchQuery.text;

    if (this.lastSearchWord == this._searchQuery.text) {
      this.isLoading = false;
    }
    this.tagList = result;
    if (this.mounted) {
      setState(() {});
    }
  }


  Future<List<TagModel>> searchTag(String name) async{
      return await TagService.getTagByNameOrderAESC(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
        leading: buildLeading(context),
        title: buildSearchInput(),
        actions: <Widget>[
          _showLoadingStatus(this.isLoading)
        ],
      ),
      body: ListView(
        children: this.tagList.map(
                (tag) => _buildTagListTile(tag)
        ).toList(),
      ),
    );
  }

  TextField buildSearchInput() {
    return TextField(
        decoration: InputDecoration(
          hintText: "请输入需要搜索的tag",
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold
          ),
          border: InputBorder.none,
        ),
        controller: _searchQuery,
      );
  }

  Widget _buildTagListTile(TagModel tag) {
    List<String> chipNames = List();
    if (tag.type >= 0 && tag.type <= 3) {

      chipNames.add(TagType[tag.type]);
    }
    return MySearchListTile(
        name: tag.name,
        chipNameList: chipNames,
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return ResultView(
                      tags: tag.name,
                    );
                  }
              )
          );
        },
    );

  }

  Widget _showLoadingStatus(bool loadingStatus){
    if (loadingStatus) {
      return Container(
        margin: EdgeInsets.only(
            right: 10
        ),
        child: Center(
          child: SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    return Container();
  }


}


class MySearchListTile extends StatelessWidget {

  final String name;
  final List<String> chipNameList;
  final GestureTapCallback onTap;
  MySearchListTile({
    this.name,
    this.chipNameList,
    this.onTap
  });



  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    children.add(Text(this.name, style: TextStyle(fontSize: 18)));
    for (String chipName in this.chipNameList) {
      children.add(this._buildChip(chipName));
    }

    return Material(
        child: InkWell(
          child: Container(
            height: 40,
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 20),
            child: Row(
              children: children,
            ),
          ),
          onTap: this.onTap,
        )
    );
  }

  Widget _buildChip(String name) {
    return Container(
      margin: EdgeInsets.only(top: 5,left: 10),
      padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Color(0xffeaeaea)
      ),
      child: SizedBox(
        height: 14,
        child: Text(
            name,
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 10
            ),
        ),
      ),
    );
  }
}