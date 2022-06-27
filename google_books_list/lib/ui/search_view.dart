import 'package:flutter/material.dart';
import 'package:google_books_list/bloc/book_by-category_bloc.dart';
import 'package:google_books_list/bloc/book_by_searched_bloc.dart';
import 'package:google_books_list/model/book_model.dart';
import 'package:google_books_list/ui/books_detail.dart';
import 'package:google_books_list/ui/preview_book.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class SearchView extends StatefulWidget {
  final String searchKey;

  const SearchView({Key? key, required this.searchKey}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  SearchedBooksBloc bookBloc = SearchedBooksBloc();
  String searchKey = '';
  List<String> readedId = [];

  @override
  void initState() {
    searchKey = widget.searchKey;
    sharedPreference('id');
    super.initState();
  }

  void sharedPreference(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('readedId') ?? [];

    items.add(id);

    await prefs.setStringList('readedId', items);
    setState(() {
      readedId = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: bookBloc.mapEventToState(searchKey),
            initialData: [
              BookModel(id: '', title: '', author: [], description: '')
            ],
            builder: (context, AsyncSnapshot<List<BookModel>> snapshot) {
              return SingleChildScrollView(
                primary: true,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: StickyHeader(
                          header: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextField(
                              onSubmitted: (String key) {
                                setState(() {
                                  searchKey = key;
                                });
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Search Books',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                            ),
                          ),
                          content: ListView.separated(
                              primary: false,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return ListTile(
                                    onTap: () {
                                      sharedPreference(
                                          snapshot.data![index].id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailBooks(
                                                    book: snapshot.data![index],
                                                  )));
                                    },
                                    dense: true,
                                    leading: SizedBox(
                                      width: 70,
                                      child: Image.network(snapshot
                                              .data![index].thumbnailUrl ??
                                          "https://source.unsplash.com/random/1920x1080?noimage"),
                                    ),
                                    title: readedId
                                            .contains(snapshot.data![index].id)
                                        ? Text(
                                            '${snapshot.data![index].title} (readed)',
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          )
                                        : Text(snapshot.data![index].title),
                                    subtitle: Text(
                                        snapshot.data![index].description ??
                                            'no description available'),
                                    isThreeLine: true,
                                    trailing: snapshot
                                                .data![index].downloadUrl !=
                                            null
                                        ? InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PreviewBook(
                                                          url: snapshot
                                                              .data![index]
                                                              .downloadUrl,
                                                        ))),
                                            child: const Icon(Icons.download))
                                        : Container(
                                            width: 10,
                                          ));
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
