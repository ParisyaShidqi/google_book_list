import 'package:flutter/material.dart';
import 'package:google_books_list/bloc/book_by-category_bloc.dart';
import 'package:google_books_list/model/book_model.dart';
import 'package:google_books_list/ui/books_detail.dart';
import 'package:google_books_list/ui/preview_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooksByCategory extends StatefulWidget {
  final String category;

  const BooksByCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<BooksByCategory> createState() => _BooksByCategoryState();
}

class _BooksByCategoryState extends State<BooksByCategory> {
  BookByCategoryBloc bookBloc = BookByCategoryBloc();
  List<String> readedId = [];

  @override
  void initState() {
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
            stream: bookBloc.mapEventToState(widget.category),
            initialData: [
              BookModel(id: '', title: '', author: [], description: '')
            ],
            builder: (context, AsyncSnapshot<List<BookModel>> snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              color: Colors.grey,
                            ),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return ListTile(
                              onTap: () {
                                sharedPreference(snapshot.data![index].id);
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
                              title: readedId.contains(snapshot.data![index].id)
                                  ? Text(
                                      '${snapshot.data![index].title} (readed)',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    )
                                  : Text(snapshot.data![index].title),
                              subtitle: Text(
                                  snapshot.data![index].description ??
                                      'no description available'),
                              isThreeLine: true,
                              trailing: snapshot.data![index].downloadUrl !=
                                      null
                                  ? InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PreviewBook(
                                                    url: snapshot.data![index]
                                                        .downloadUrl,
                                                  ))),
                                      child: const Icon(Icons.download))
                                  : Container(
                                      width: 10,
                                    ));
                        }),
                  ),
                ],
              );
            }));
  }
}
