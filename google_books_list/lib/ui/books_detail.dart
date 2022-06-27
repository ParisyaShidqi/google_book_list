import 'package:flutter/material.dart';
import 'package:google_books_list/model/book_model.dart';
import 'package:google_books_list/ui/preview_book.dart';

class DetailBooks extends StatelessWidget {
  BookModel book = BookModel(id: '', title: '', author: []);
  DetailBooks({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 200,
                  child: Image.network(book.thumbnailUrl ??
                      'https://source.unsplash.com/random/1920x1080?noimage'),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              const TextSpan(
                                  text: 'Title: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: book.title)
                            ]),
                        textAlign: TextAlign.start,
                      ),
                      for (var item in book.author ?? [])
                        RichText(
                          text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                    text: 'Authors: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: item)
                              ]),
                          textAlign: TextAlign.start,
                        ),
                      RichText(
                        text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              const TextSpan(
                                  text: 'Page Counts: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      '${book.pageCount ?? 'page count not available'}')
                            ]),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      book.previewUrl != null
                          ? ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PreviewBook(
                                            url: book.previewUrl,
                                          ))),
                              child: const Text('Preview'))
                          : const Text('No Preview Available')
                    ],
                  ),
                )
              ],
            ),
            const Divider(),
            Expanded(
                child: SingleChildScrollView(
                    child:
                        Text(book.description ?? 'no description available')))
          ],
        ),
      ),
    );
  }
}
