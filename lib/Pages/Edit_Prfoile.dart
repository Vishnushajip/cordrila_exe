import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Togggle_button.dart';

class EditProfilePage extends StatefulWidget {
  final DocumentSnapshot? initialData;
  final String? initialId;
  final String? initialSearchTerm;

  const EditProfilePage({
    super.key,
    this.initialData,
    this.initialId,
    this.initialSearchTerm,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialSearchTerm ?? '';
    _searchEmployee();

    _typeController.addListener(() {
      _typeController.value = _typeController.value.copyWith(
        text: _typeController.text.toUpperCase(),
        selection: TextSelection.collapsed(offset: _typeController.text.length),
      );
    });

    _stationController.addListener(() {
      _stationController.value = _stationController.value.copyWith(
        text: _stationController.text.toUpperCase(),
        selection:
            TextSelection.collapsed(offset: _stationController.text.length),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _panController.dispose();
    _mobileController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    _stationController.dispose();
    super.dispose();
  }

  void _populateFields(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      _nameController.text = userData['Employee Name'] ?? ''.toUpperCase();
      _idController.text = userData['EmpCode'] ?? ''.toUpperCase();
      ;
      _titleController.text = userData['Business Title'] ?? ''.toUpperCase();
      ;
      _emailController.text = userData['Mail ID'] ?? ''.toUpperCase();
      ;
      _dobController.text = userData['DOB'] ?? ''.toUpperCase();
      _panController.text = userData['PAN CARD'] ?? ''.toUpperCase();
      ;
      _mobileController.text = userData['Mobile Number'] ?? ''.toString();
      _categoryController.text = userData['Category'] ?? ''.toUpperCase();
      _typeController.text = userData['Location'] ?? ''.toUpperCase();
      _stationController.text = userData['StationCode'] ?? ''.toUpperCase();
    }
  }

  void _searchEmployee() async {
    String searchName = _searchController.text.trim().toUpperCase();

    if (searchName.isNotEmpty) {
      // Perform Firestore query based on employee name
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('EmpCode', isEqualTo: searchName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        _populateFields(snapshot);
      } else {
        _clearFields();
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Employee Not Found'),
            content: const Text('No employee found with that name.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      _clearFields();
    }
  }

  void _clearFields() {
    _nameController.clear();
    _idController.clear();
    _titleController.clear();
    _emailController.clear();
    _dobController.clear();
    _panController.clear();
    _mobileController.clear();
    _categoryController.clear();
    _typeController.clear();
    _stationController.clear();
  }

  void _updateEmployeeData() async {
    String searchName = _searchController.text.trim().toUpperCase();

    if (searchName.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('Employee Name', isEqualTo: searchName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        await FirebaseFirestore.instance
            .collection('USERS')
            .doc(snapshot.id)
            .update({
          'Employee Name': _nameController.text.toUpperCase(),
          'EmpCode': _idController.text.toUpperCase(),
          'Business Title': _titleController.text.toUpperCase(),
          'Mail ID': _emailController.text.toUpperCase(),
          'DOB': _dobController.text.toUpperCase(),
          'PAN CARD': _panController.text.toUpperCase(),
          'Mobile Number': _mobileController.text.toUpperCase(),
          'Category': _categoryController.text.toUpperCase(),
          'Location': _typeController.text.toUpperCase(),
          'StationCode': _stationController.text.toUpperCase(),
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Update Successful',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text('Employee data has been updated.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Employee Not Found'),
            content: const Text('No employee found with that name.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50),
              child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 70,
                  backgroundImage: AssetImage("assets/AppIcon.jpg")),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Row(
                children: [
                  Text(
                    _searchController.text,
                    style: const TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Consumer<ToggleProvider>(
                    builder: (context, toggleProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Inactive',
                            style: TextStyle(
                              color: toggleProvider.isActive
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Switch(
                            value: toggleProvider.isActive,
                            onChanged: (value) {
                              toggleProvider.setActive(value);
                            },
                            activeTrackColor: Colors.green,
                            activeColor: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: toggleProvider.isActive
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      buildTextField(
                          _idController,
                          "Enter your ID",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                              AssetImage("assets/human.png"),
                            ),
                          ),
                          suffixText: "Emp Code"),
                      SizedBox(
                        height: 20,
                      ),
                      buildTextField(
                          _nameController,
                          "Employee Name",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                                AssetImage("assets/date-of-birth.png")),
                          ),
                          suffixText: "Name"),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                          _titleController,
                          "Enter your title",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                              AssetImage("assets/portfolio.png"),
                            ),
                          ),
                          suffixText: "Title"),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                          _emailController,
                          "Enter your email",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(AssetImage("assets/email.png")),
                          ),
                          suffixText: "Gmail"),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                          _typeController,
                          "Category",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                ImageIcon(AssetImage("assets/networking.png")),
                          ),
                          suffixText: "Category"),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      buildTextField(
                          _dobController,
                          "Enter your DOB",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                                AssetImage("assets/date-of-birth.png")),
                          ),
                          suffixText: "DOB"),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                          _panController,
                          "Enter your PAN",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                                AssetImage("assets/identification.png")),
                          ),
                          suffixText: "Pan"),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                          _mobileController,
                          "Enter your phone",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ImageIcon(
                              AssetImage("assets/telephone.png"),
                            ),
                          ),
                          suffixText: "Mobile"),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                          _stationController,
                          "Enter your station code",
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                ImageIcon(AssetImage("assets/warehouse.png")),
                          ),
                          suffixText: "Station"),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 380),
              child: ElevatedButton(
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _updateEmployeeData();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hintText, Widget prefixIcon,
      {String? suffixText, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        child: TextField(
          onChanged: (value) {
            controller.value = controller.value.copyWith(
              text: value.trim(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: value.trim().length),
              ),
            );
          },
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: prefixIcon,
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
