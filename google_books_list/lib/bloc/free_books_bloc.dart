import 'dart:async';
import 'package:google_books_list/model/book_model.dart';

class FreeBooksBloc {
  Stream<List<BookModel>> mapEventToState(String? searchKey) async* {
    List<BookModel> bookModel = await BookModel.getFreeBookFromAPI(searchKey);
    yield bookModel;
  }
}
