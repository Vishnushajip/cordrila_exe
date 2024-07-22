import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/UploadCsv_Provider.dart';

class UploadExcelPage extends StatefulWidget {
  const UploadExcelPage({Key? key}) : super(key: key);

  @override
  _UploadExcelPageState createState() => _UploadExcelPageState();
}

class _UploadExcelPageState extends State<UploadExcelPage> {
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _empCodeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _businessTitleController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stationCodeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mailIDController = TextEditingController();
  final TextEditingController _panCardController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _clearTextControllers() {
    _employeeNameController.clear();
    _empCodeController.clear();
    _dobController.clear();
    _businessTitleController.clear();
    _categoryController.clear();
    _stationCodeController.clear();
    _locationController.clear();
    _mailIDController.clear();
    _panCardController.clear();
    _mobileNumberController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExcelUploadProvider>(context);

    void _showMessageDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Message'),
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _uploadToFirestore() async {
      // Validate all fields are not empty
      if (_employeeNameController.text.isEmpty ||
          _empCodeController.text.isEmpty ||
          _dobController.text.isEmpty ||
          _businessTitleController.text.isEmpty ||
          _categoryController.text.isEmpty ||
          _stationCodeController.text.isEmpty ||
          _locationController.text.isEmpty ||
          _mailIDController.text.isEmpty ||
          _panCardController.text.isEmpty ||
          _mobileNumberController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        _showMessageDialog(
          'Please fill in all fields',
        );
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('USERS').add({
          'Employee Name': _employeeNameController.text.toUpperCase(),
          'EmpCode': _empCodeController.text.toUpperCase(),
          'DOB': _dobController.text.toUpperCase(),
          'Business Title': _businessTitleController.text.toUpperCase(),
          'Category': _categoryController.text.toUpperCase(),
          'StationCode': _stationCodeController.text.toUpperCase(),
          'Location': _locationController.text.toUpperCase(),
          'Mail ID': _mailIDController.text.toUpperCase(),
          'PAN CARD': _panCardController.text.toUpperCase(),
          'Mobile Number': _mobileNumberController.text,
          'Password': _passwordController.text,
        });

        provider.setUploadStatus('Data uploaded to Firebase successfully');
        _clearTextControllers(); // Clear text fields after successful upload

        // Show alert dialog when upload is successful
        _showMessageDialog('Data uploaded to Firebase successfully!');
      } catch (e) {
        _showMessageDialog('Error uploading data: $e');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Add User',
          style: TextStyle(color: Colors.blue, fontSize: 35),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.blue),
                    left: BorderSide(color: Colors.blue),
                    right: BorderSide(color: Colors.blue),
                    top: BorderSide(color: Colors.blue))),
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Center(
                      child: Container(
                        width: 310,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _employeeNameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage(
                                    "assets/id-card.png",
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (text) {
                              _employeeNameController.value =
                                  _employeeNameController.value.copyWith(
                                text: text.toUpperCase(),
                                selection: TextSelection.collapsed(
                                    offset: text.length),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _empCodeController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                ("assets/empcode.png.png"),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            labelText: "EmpCode",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _empCodeController.value =
                                _empCodeController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            labelText: "DOB",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: AssetImage("assets/date.png"),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _dobController.value =
                                _dobController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _businessTitleController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/bag.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            labelText: "Business Title",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _businessTitleController.value =
                                _businessTitleController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            labelText: "Category",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  ("assets/market-segment.png"),
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _categoryController.value =
                                _categoryController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                    ),
                    Row(
                      children: [
                        Center(
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _stationCodeController,
                              decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/location.png.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                labelText: "Station",
                                labelStyle: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                              ),
                              textInputAction: TextInputAction.next,
                              onChanged: (text) {
                                _stationCodeController.value =
                                    _stationCodeController.value.copyWith(
                                  text: text.toUpperCase(),
                                  selection: TextSelection.collapsed(
                                      offset: text.length),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/map.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            labelText: "Location",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _locationController.value =
                                _locationController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _mailIDController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/gmail.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            labelText: "Mail",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _mailIDController.value =
                                _mailIDController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _panCardController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/identification.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            labelText: "Pan Card",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            _panCardController.value =
                                _panCardController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _mobileNumberController,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/phone.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            labelText: "Mobile",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            // No need to convert to uppercase for numbers
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureText,
                          onChanged: (text) {},
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: _uploadToFirestore,
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<ExcelUploadProvider>(
                  builder: (context, provider, _) => Text(
                    provider.uploadStatus,
                    style: TextStyle(
                      color: provider.uploadStatus.startsWith('Data uploaded')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
