import 'package:flutter/material.dart';


class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
 
     List<String> list = [
    "Qwert",
    "sadf",
    "asd",
    "gfggf",
  ];  
  

  List<String> books = [];
    
  @override
  void initState() {
    super.initState();
    books = list;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => searchBook(value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Text(book);
                  },
                ),  
              )
            ],
          ),
        ),
      ),
    );
  
  }
    void searchBook(String query) {
    final suggestions = list.where((book) {
      final bookTitle = book.toLowerCase();
      final input = query.toLowerCase();
      return bookTitle.contains(input);
    }).toList();

    setState(() {
      books = suggestions;
    });
  }

  
}
