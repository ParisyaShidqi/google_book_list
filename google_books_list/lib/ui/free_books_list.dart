import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_books_list/bloc/free_books_bloc.dart';
import 'package:google_books_list/model/book_model.dart';
import 'package:google_books_list/ui/books_detail.dart';
import 'package:google_books_list/ui/preview_book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class FreeBooksList extends StatefulWidget {
  FreeBooksList({Key? key}) : super(key: key);
  final ChromeSafariBrowser browser = MyChromeSafariBrowser();
  @override
  State<FreeBooksList> createState() => _FreeBooksListState();
}

class _FreeBooksListState extends State<FreeBooksList> {
  FreeBooksBloc bookBloc = FreeBooksBloc();
  String? searchKey;
  List<String> readedId = [];
  late final String path;

  @override
  void initState() {
    widget.browser.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 1, label: 'Custom item menu 1', action: (url, title) {}));

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
              return Container(
                child: SingleChildScrollView(
                  primary: true,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 30,
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
                                    isDense: true,
                                    labelText: 'Search Books',
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
                                                builder: (context) =>
                                                    DetailBooks(
                                                        book: snapshot
                                                            .data![index])));
                                      },
                                      dense: true,
                                      leading: SizedBox(
                                        width: 70,
                                        child: Image.network(snapshot
                                                .data![index].thumbnailUrl ??
                                            "https://source.unsplash.com/random/1920x1080?noimage"),
                                      ),
                                      title: readedId.contains(
                                              snapshot.data![index].id)
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
                                      trailing: snapshot.data![index].downloadUrl !=
                                              null
                                          ? InkWell(
                                              onTap: () async => await widget.browser.open(
                                                  url: Uri.parse(snapshot
                                                          .data![index]
                                                          .downloadUrl ??
                                                      ''),
                                                  options: ChromeSafariBrowserClassOptions(
                                                      android:
                                                          AndroidChromeCustomTabsOptions(shareState: CustomTabsShareState.SHARE_STATE_OFF),
                                                      ios: IOSSafariOptions(barCollapsingEnabled: true))),
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
                ),
              );
            }));
  }
}
