// ignore_for_file: file_names, library_private_types_in_public_api, use_super_parameters, sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../components/navbar.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _photoFile;
  String _userName = '';
  String _firstName = '';
  String _lastName = '';
  String _userEmail = '';
  String _mobileNumber = '';
  String _qualification = '';
  String _profession = '';
  String _linkedIn = '';
  String _location = '';
  String _instagram = '';
  String _city = '';
  String _state = '';
  String _country = '';
  String _pincode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: const Color.fromARGB(255, 241, 244, 247),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBar(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPhotoPicker(),
                  _buildTextField(
                      'Username', _userName, (value) => _userName = value),
                  _buildTextField(
                      'First Name', _firstName, (value) => _firstName = value),
                  _buildTextField(
                      'Last Name', _lastName, (value) => _lastName = value),
                  _buildTextField(
                      'Email', _userEmail, (value) => _userEmail = value),
                  _buildTextField('Mobile Number', _mobileNumber,
                      (value) => _mobileNumber = value),
                  _buildTextField('Qualification', _qualification,
                      (value) => _qualification = value),
                  _buildTextField('Profession', _profession,
                      (value) => _profession = value),
                  _buildTextField(
                      'LinkedIn', _linkedIn, (value) => _linkedIn = value),
                  _buildTextField(
                      'Location', _location, (value) => _location = value),
                  _buildTextField(
                      'Instagram', _instagram, (value) => _instagram = value),
                  _buildTextField('City', _city, (value) => _city = value),
                  _buildTextField('State', _state, (value) => _state = value),
                  _buildTextField(
                      'Country', _country, (value) => _country = value),
                  _buildTextField(
                      'Pincode', _pincode, (value) => _pincode = value),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Perform save action here
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Perform update action here
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _photoFile != null
            ? Image.file(
                _photoFile!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              ),
        ElevatedButton(
          onPressed: _pickPhoto,
          child: const Text('Pick Photo'),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).orientation == Orientation.landscape
              ? MediaQuery.of(context).size.width * 0.3
              : null,
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  void _pickPhoto() {}
}
