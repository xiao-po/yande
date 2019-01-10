import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/service/services.dart';
import 'resultView.dart';

class TagSearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TagSearchState();

}

class _TagSearchState extends State<TagSearchView> {

  List<TagModel> tagList = new List();
  final TextEditingController _searchQuery = new TextEditingController();
  bool isLoading = false;
  String lastSearchWord = "";


  Widget buildLeading(BuildContext context) {
    return new IconButton(
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
    setState(() {
      this.isLoading = true;
    });
    print("search ${this._searchQuery.text}");
    List<TagModel> result =await this.searchTag(this._searchQuery.text);
    this.lastSearchWord = this._searchQuery.text;
    setState(() {
      if (this.lastSearchWord == this._searchQuery.text) {
        this.isLoading = false;
      }
      this.tagList = result;
    });
  }


  Future<List<TagModel>> searchTag(String name) async{
      return await TagService.getTagByNameOrderAESC(name);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

        backgroundColor: Colors.white,
        leading: buildLeading(context),
        title: new TextField(
          decoration: InputDecoration(
            hintText: "请输入需要搜索的tag",
            hintStyle: new TextStyle(
              fontWeight: FontWeight.bold
            ),
            border: InputBorder.none,
          ),
          controller: _searchQuery,
        ),
        actions: <Widget>[
          _showLoadingStatus(this.isLoading)
        ],
      ),
      body: new ListView(
        children: this.tagList.map(
                (tag) => _buildTagListTile(tag)
        ).toList(),
      ),
    );
  }

  Widget _buildTagListTile(TagModel tag) {
    List<String> chipNames = new List();
    if (tag.type >= 0 && tag.type <= 3) {

      chipNames.add(TagType[tag.type]);
    }
    return new MySearchListTile(
        name: tag.name,
        chipNameList: chipNames,
        onTap: (){
          Navigator.push(
              context,
              new MaterialPageRoute(
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
      return new Container(
        margin: new EdgeInsets.only(
            right: 10
        ),
        child: new Center(
          child: new SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    return new Container();
  }


}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return new ListTile(
//          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: new Text(suggestion) ,
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
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
    List<Widget> children = new List();
    children.add(new Text(this.name, style: new TextStyle(fontSize: 18)));
    for (String chipName in this.chipNameList) {
      children.add(this._buildChip(chipName));
    }

    return new Material(
        child: new InkWell(
          child: new Container(
            height: 40,
            margin: new EdgeInsets.only(top: 5, bottom: 5, left: 20),
            child: new Row(
              children: children,
            ),
          ),
          onTap: this.onTap,
        )
    );
  }

  Widget _buildChip(String name) {
    return new Container(
      margin: new EdgeInsets.only(top: 5,left: 10),
      padding: new EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(3)),
          color: new Color(0xffeaeaea)
      ),
      child: new SizedBox(
        height: 14,
        child: new Text(
            name,
            style: new TextStyle(
              color: new Color(0xff333333),
              fontSize: 10
            ),
        ),
      ),
    );
  }
}