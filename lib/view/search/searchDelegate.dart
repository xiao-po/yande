import 'package:flutter/material.dart';
import 'package:yande/model/all_model.dart';
import 'package:yande/service/services.dart';

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
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  void initState() {
    super.initState();
    this._searchQuery.addListener(this.onSearch);
  }

//  Widget buildSuggestions(BuildContext context) {
//    if (this.tagList.length > 0) {
//      return new _SuggestionList(
//        query: query,
//        suggestions: this.tagList.map((tag) => tag.name).toList(),
//        onSelected: (String suggestion) {
//          query = suggestion;
//          showResults(context);
//        },
//      );
//    } else {
//      return new Container();
//    }
//  }

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
      return await IndexService.getTagByNameOrderAESC(name);
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
                (tag) => _buildTagListTile(tag.name)
        ).toList(),
      ),
    );
  }

  Widget _buildTagListTile(String name) {
    return new ListTile(
        title: new Text(name),
        onTap: (){
          print("搜索tag $name");
        },
    );

  }

  Widget _showLoadingStatus(bool loadingStatus){
    if (loadingStatus) {
      return new Center(
        child: new SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            strokeWidth: 2,
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
