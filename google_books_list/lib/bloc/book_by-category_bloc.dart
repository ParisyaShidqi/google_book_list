import 'dart:async';
import 'package:google_books_list/model/book_model.dart';

class BookByCategoryBloc {
  Stream<List<BookModel>> mapEventToState(String category) async* {
      List<BookModel> bookModel = await BookModel.getBookByCategoryFromAPI(category);
      yield bookModel;   
  }

  
}
