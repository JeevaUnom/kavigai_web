// service_page.dart

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../Components/Navbar.dart';

// ignore: unused_import
import 'package:item_count_number_button/item_count_number_button.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    int itemCount = 0; // Assuming this is the count related to your calendar

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Page'),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),
      body: const Column(
        children: [
          NavBar(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Service Page Content Goes Here',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                // Text(
                //   'Calendar Item Count: $itemCount',
                //   style: const TextStyle(fontSize: 18),
                // ),
                // ItemCountNumberButton(
                //   initialValue: itemCount,
                //   onChanged: (value) {
                //     // You can handle the onChanged event to update the count
                //     // related to your calendar.
                //     itemCount = value;
                //     // You might want to update the UI when count changes.
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

ItemCountNumberButton(
    {required int initialValue,
    required Null Function(dynamic value) onChanged}) {}
