import 'dart:convert';

import 'package:http/http.dart' as http;

class BookModel {
  String id;
  String title;
  List<dynamic>? author;
  String? thumbnailUrl;
  String? description;
  String? previewUrl;
  String? downloadUrl;
  int? pageCount;
  BookModel(
      {required this.id,
      required this.title,
      required this.author,
      this.description,
      this.thumbnailUrl,
      this.previewUrl,
      this.downloadUrl,
      this.pageCount});

  factory BookModel.createBook(Map<String, dynamic> object) {
    return BookModel(
        id: object['id'].toString(),
        title: object['volumeInfo']['title'],
        author: object['volumeInfo']['authors'],
        description: object['volumeInfo']['description'],
        thumbnailUrl: object['volumeInfo']['imageLinks']?['thumbnail'],
        previewUrl: object['volumeInfo']['previewLink'],
        downloadUrl: object['accessInfo']?['pdf']?['downloadLink'],
        pageCount: object['volumeInfo']['pageCount']);
  }

  static Future<List<BookModel>> getBookByCategoryFromAPI(
      String category) async {
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=subject:$category";

    var apiResult = await http.get(Uri.parse(apiUrl));
    var jsonObject = json.decode(apiResult.body);
    List bookData = (jsonObject as Map<String, dynamic>)['items'];

    List<BookModel> books = [];

    for (int i = 0; i < bookData.length; i++) {
      books.add(BookModel.createBook(bookData[i]));
    }
    return books;
  }

  static Future<List<BookModel>> getFreeBookFromAPI(String? searchKey) async {
    String apiUrl;
    if (searchKey != null && searchKey != '') {
      apiUrl =
          "https://www.googleapis.com/books/v1/volumes?filter=free-ebooks&q=$searchKey";
    } else {
      apiUrl =
          "https://www.googleapis.com/books/v1/volumes?filter=free-ebooks&q=a";
    }

    var apiResult = await http.get(Uri.parse(apiUrl));
    var jsonObject = json.decode(apiResult.body);
    List bookData = (jsonObject as Map<String, dynamic>)['items'];

    List<BookModel> books = [];

    for (int i = 0; i < bookData.length; i++) {
      books.add(BookModel.createBook(bookData[i]));
    }
    return books;
  }

  static Future<List<BookModel>> getSearchedBookFromAPI(
      String? searchKey) async {
    String apiUrl;
    if (searchKey != null && searchKey != '') {
      apiUrl = "https://www.googleapis.com/books/v1/volumes?q=$searchKey";
    } else {
      apiUrl = "https://www.googleapis.com/books/v1/volumes?q=a";
    }

    var apiResult = await http.get(Uri.parse(apiUrl));
    var jsonObject = json.decode(apiResult.body);
    List bookData = (jsonObject as Map<String, dynamic>)['items'];

    List<BookModel> books = [];

    for (int i = 0; i < bookData.length; i++) {
      books.add(BookModel.createBook(bookData[i]));
    }
    return books;
  }
}
