// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Book {
  final String title;
  final String author;
  final String description;
  final int pageCount;
  final String genre;
  final String status;
  DateTime beginDate; // Added beginDate field
  DateTime endDate; // Added endDate field

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.pageCount,
    required this.genre,
    required this.status,
    required this.beginDate,
    required this.endDate,
  });
}

class BookForm extends StatefulWidget {
  final Function(Book) onSave;

  const BookForm({required this.onSave});

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _description;
  late int _pageCount;
  late String _genre;
  late String _status;
  late DateTime _beginDate; // New field for begin date
  late DateTime _endDate; // New field for end date
  TextEditingController _beginDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _pageCountController = TextEditingController();
  TextEditingController _genreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status = 'New';
    _beginDate = DateTime.now();
    _endDate = _beginDate!.add(Duration(days: 10));
    _beginDateController.text = _beginDate!.toString().substring(0, 10);
    _endDateController.text = _endDate!.toString().substring(0, 10);
  }

  @override
  void dispose() {
    _beginDateController.dispose();
    _endDateController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _pageCountController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isBeginDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isBeginDate) {
          _beginDate = picked;
          _beginDateController.text = _beginDate!.toString().substring(0, 10);
        } else {
          _endDate = picked;
          _endDateController.text = _endDate!.toString().substring(0, 10);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Book Title *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              TextFormField(
                controller: _pageCountController,
                decoration: const InputDecoration(
                  labelText: 'Page Count *',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter page count';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(
                  labelText: 'Genre *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter genre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _beginDateController,
                      decoration: const InputDecoration(
                        labelText: 'Begin Date *',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, true),
                      validator: (value) {
                        if (_beginDate == null) {
                          return 'Please select begin date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date *',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, false),
                      validator: (value) {
                        if (_endDate == null) {
                          return 'Please select end date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: ['New', 'In Progress', 'Completed', 'Optional']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Book book = Book(
                      title: _titleController.text,
                      author: _authorController.text,
                      description: _descriptionController.text,
                      pageCount: int.parse(_pageCountController.text),
                      genre: _genreController.text,
                      status: _status,
                      beginDate: _beginDate!,
                      endDate: _endDate!,
                    );
                    widget.onSave(book);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExistingBooksDialog extends StatelessWidget {
  final Function(Book) onSelect; // Define onSelect function

// final Function(Book) onAddToGoalDetails; // Add callback for adding book to goal details

  const ExistingBooksDialog({required this.onSelect});
  Future<List<Book>> _fetchBooks() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/books'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['books'];
      List<Book> books = data.map((item) {
        // Assuming default values for beginDate and endDate
        DateTime beginDate = DateTime.now();
        DateTime endDate = DateTime.now();

        return Book(
          title: item['title'],
          author: item['author'],
          description: item['description'],
          pageCount: item['number_of_pages'],
          genre: item['genre'],
          status: item['ratings'].toString(),
          beginDate: beginDate,
          endDate: endDate,
        );
      }).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _fetchBooks(), // Pass any required date here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Book> books = snapshot.data!;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Existing Books',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(books[index].title),
                          subtitle: Text(
                            'Author: ${books[index].author}\nRating: ${books[index].status}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              onSelect(books[index]);
                              // onAddToGoalDetails(books[index]); // Add this line to update goal details
                              // Navigator.pop(context);
                            },
                          ),
                          // Other details...
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
