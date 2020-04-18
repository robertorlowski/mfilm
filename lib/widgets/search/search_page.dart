import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:netfilm/i18/app_localizations.dart';
import 'package:netfilm/util/mediaproviders.dart';
import 'package:netfilm/util/utils.dart';
import 'package:netfilm/model/searchresult.dart';
import 'package:rxdart/rxdart.dart';
import 'package:netfilm/widgets/search/search_item.dart';

class SearchScreen extends StatefulWidget {
  final MediaProvider provider;

  SearchScreen(this.provider);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> {
  List<SearchResult> _resultList = List();
  SearchBar searchBar;
  LoadingState _currentState = LoadingState.WAITING;
  PublishSubject<String> querySubject = PublishSubject();
  TextEditingController textController = TextEditingController();

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
            Observable.fromFuture(widget.provider.getSearchResults(query)))
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
    if (searchBar == null) {
      searchBar = SearchBar(
          hintText: AppLocalizations.of(context).translate("search"),
          inBar: true,
          controller: textController,
          setState: setState,
          buildDefaultAppBar: _buildAppBar,
          onSubmitted: querySubject.add);
    }

    return Scaffold(
        appBar: searchBar.build(context), body: _buildContentSection());
  }

  Widget _buildContentSection() {
    switch (_currentState) {
      case LoadingState.WAITING:
        return Center(
            child: Text(
                AppLocalizations.of(context).translate("search_for_movies")));
      case LoadingState.ERROR:
        return Center(
            child: Text(
                AppLocalizations.of(context).translate("an_error_occured")));
      case LoadingState.LOADING:
        return Center(
          child: CircularProgressIndicator(),
        );
      case LoadingState.DONE:
        return (_resultList == null || _resultList.length == 0)
            ? Center(
                child: Text(AppLocalizations.of(context)
                    .translate("unforunately_there_no_matching_results")))
            : ListView.builder(
                itemCount: _resultList.length,
                itemBuilder: (BuildContext context, int index) =>
                    SearchItemCard(_resultList[index], widget.provider));
      default:
        return Container();
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(AppLocalizations.of(context).translate("search_movies")),
        actions: [searchBar.getSearchAction(context)]);
  }
}
