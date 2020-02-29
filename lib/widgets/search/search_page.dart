import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:mfilm/util/api_client.dart';
import 'package:mfilm/util/utils.dart';
import 'package:mfilm/model/searchresult.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mfilm/widgets/search/search_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> {
  ApiClient _apiClient = ApiClient();
  List<SearchResult> _resultList = List();
  SearchBar searchBar;
  LoadingState _currentState = LoadingState.WAITING;
  PublishSubject<String> querySubject = PublishSubject();
  TextEditingController textController = TextEditingController();

  _SearchPageState() {
    searchBar = SearchBar(
        inBar: true,
        controller: textController,
        setState: setState,
        buildDefaultAppBar: _buildAppBar,
        onSubmitted: querySubject.add);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchBar.beginSearch(context);
    });

    textController.addListener(() {
      querySubject.add(textController.text);
    });

    querySubject.stream
        .where((query) => query.isNotEmpty)
        .debounce(Duration(milliseconds: 250))
        .distinct()
        .switchMap((query) =>
            Observable.fromFuture(_apiClient.getSearchResults(query)))
        .listen(_setResults);
  }

  void _setResults(List<SearchResult> results) {
    setState(() {
      _resultList = results;
      _currentState = LoadingState.DONE;
    });
  }

  @override
  void dispose() {
    super.dispose();
    querySubject.close();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context), body: _buildContentSection());
  }

  Widget _buildContentSection() {
    switch (_currentState) {
      case LoadingState.WAITING:
        return Center(child: Text("Search for movies, shows and actors"));
      case LoadingState.ERROR:
        return Center(child: Text("An error occured"));
      case LoadingState.LOADING:
        return Center(
          child: CircularProgressIndicator(),
        );
      case LoadingState.DONE:
        return (_resultList == null || _resultList.length == 0)
            ? Center(
                child: Text("Unforunately there aren't any matching results!"))
            : ListView.builder(
                itemCount: _resultList.length,
                itemBuilder: (BuildContext context, int index) =>
                    SearchItemCard(_resultList[index]));
      default:
        return Container();
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Text('Search Movies'),
        actions: [searchBar.getSearchAction(context)]);
  }
}
