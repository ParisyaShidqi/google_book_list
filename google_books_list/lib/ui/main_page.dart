import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_books_list/ui/category-page.dart';
import 'package:google_books_list/ui/free_books_list.dart';
import 'package:google_books_list/ui/search_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/library.jpg'))),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (String key) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchView(searchKey: key))),
                      decoration: const InputDecoration(
                        labelText: 'Search Books',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        isDense: true,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FreeBooksList())),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[400],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            child: const Text(
                              "Free Books",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryPage())),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[400],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            child: const Text(
                              "Category",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
