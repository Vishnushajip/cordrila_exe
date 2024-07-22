import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cordrila_exe/Pages/Homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/UploadCsv_Provider.dart';
import '../controller/password_provider copy.dart';
import 'Admin_Shopping/Add_Employee_details.dart';
import 'Admin_fresh/Add_Employee_details.dart';

class EmployeeEditPage extends StatefulWidget {
  const EmployeeEditPage({super.key});

  @override
  State<EmployeeEditPage> createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _empCodeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _MailController = TextEditingController();
  final TextEditingController _PanCardController = TextEditingController();
  final TextEditingController _MobileController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  String? _selectedDesignation;
  String? _selectedCategory;
  String? _selectedType;

  void _clearTextControllers() {
    _employeeNameController.clear();
    _empCodeController.clear();
    _dobController.clear();
    _stationController.clear();
    _MailController.clear();
    _PanCardController.clear();
    _MobileController.clear();
    _PasswordController.clear();
    _selectedDesignation = null;
    _selectedCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExcelUploadProvider>(context);
    final visibilityProvider = Provider.of<PasswordVisibilityProvider>(context);

    void showMessageDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Message'),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text(
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

    Future<void> uploadToFirestore() async {
      final employeeName = _employeeNameController.text.trim();
      final empCode = _empCodeController.text.trim();
      final dob = _dobController.text.trim();
      final stationCode = _stationController.text.trim();
      final mailId = _MailController.text.trim();
      final panCard = _PanCardController.text.trim();
      final mobileNumber = _MobileController.text.trim();
      final password = _PasswordController.text.trim();

      if (employeeName.isEmpty ||
          empCode.isEmpty ||
          dob.isEmpty ||
          stationCode.isEmpty ||
          mailId.isEmpty ||
          panCard.isEmpty ||
          mobileNumber.isEmpty ||
          password.isEmpty) {
        showMessageDialog('Please fill all the fields.');
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('USERS').add({
          'Employee Name': employeeName.toUpperCase(),
          'EmpCode': empCode.toUpperCase(),
          'DOB': dob.toUpperCase(),
          'StationCode': stationCode.toUpperCase(),
          'Mail ID': mailId.toUpperCase(),
          'PAN CARD': panCard.toUpperCase(),
          'Mobile Number': mobileNumber,
          'Password': password,
          'Business Title': _selectedDesignation!.toUpperCase(),
          'Category': _selectedType!.toUpperCase(),
          'Location': _selectedCategory!.toUpperCase(),
        });

        provider.setUploadStatus('Data uploaded to Firebase successfully');
        _clearTextControllers();

        showMessageDialog('Data uploaded to Firebase successfully!');
      } catch (e) {
        showMessageDialog('Error uploading data: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return Row(
            children: [
              Container(
                width: screenWidth < 500 ? 100 : 200,
                color: const Color.fromARGB(255, 32, 32, 32),
                child: Column(
                  children: [
                    const DrawerHeader(
                        child: Text(
                      "Add User",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: screenWidth < 500
                          ? null
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (context) => HomePage(),
                                        context: context));
                              },
                              child: const Text('Home',
                                  style: TextStyle(color: Colors.white)),
                            ),
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_grocery_store,
                          color: Colors.white),
                      title: screenWidth < 500
                          ? null
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (context) =>
                                            AddFreshEmployee(),
                                        context: context));
                              },
                              child: const Text('Fresh Attendance',
                                  style: TextStyle(color: Colors.white)),
                            ),
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.shopping_bag, color: Colors.white),
                      title: screenWidth < 500
                          ? null
                          : GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                      builder: (context) => AddEmployee(),
                                      context: context)),
                              child: const Text('Shopping Attendance',
                                  style: TextStyle(color: Colors.white)),
                            ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 30),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300),
                                  left: BorderSide(color: Colors.grey.shade300),
                                  right:
                                      BorderSide(color: Colors.grey.shade300),
                                  top: BorderSide(color: Colors.grey.shade300),
                                )),
                            width: screenWidth < 500 ? 150 : 300,
                            height: screenWidth < 500 ? 150 : 300,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/backgroundscaffold.png",
                                    width: screenWidth < 500 ? 100 : 130,
                                    height: screenWidth < 500 ? 100 : 130,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                    left:
                                        BorderSide(color: Colors.grey.shade300),
                                    right:
                                        BorderSide(color: Colors.grey.shade300),
                                    top:
                                        BorderSide(color: Colors.grey.shade300),
                                  )),
                              height: screenWidth < 400 ? 300 : 300,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      const Text("Full Name"),
                                      SizedBox(
                                        width: screenWidth < 800 ? 20 : 180,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _employeeNameController,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              labelText: 'Full Name'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      const Text("EmpCode "),
                                      SizedBox(
                                        width: screenWidth < 800 ? 20 : 180,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _empCodeController,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              labelText: 'EmpCode'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      const Text("Station "),
                                      SizedBox(
                                        width: screenWidth < 800 ? 10 : 195,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _stationController,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              labelText: 'Station'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: DefaultTabController(
                          length: 8,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                    left:
                                        BorderSide(color: Colors.grey.shade300),
                                    right:
                                        BorderSide(color: Colors.grey.shade300),
                                    top:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  color: Colors.white,
                                ),
                                child: TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.black,
                                  indicator: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 32, 32, 32),
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                  ),
                                  tabs: const [
                                    Tab(
                                      text: '     Work Info     ',
                                    ),
                                    Tab(text: '     Details     '),
                                    Tab(text: '      Employee Info      '),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: screenWidth < 300 ? 100 : 200,
                                  child: TabBarView(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 30),
                                          DropdownButtonFormField<String>(
                                            value: _selectedDesignation,
                                            items: const [
                                              DropdownMenuItem(
                                                  value: 'Driver',
                                                  child: Text('Driver')),
                                              DropdownMenuItem(
                                                  value: 'Sorter',
                                                  child: Text('Sorter')),
                                              DropdownMenuItem(
                                                  value: 'Dispatcher',
                                                  child: Text('Dispatcher')),
                                              DropdownMenuItem(
                                                  value: 'Team Lead',
                                                  child: Text('Team Lead')),
                                              DropdownMenuItem(
                                                  value: 'SuperVisor',
                                                  child: Text('SuperVisor')),
                                              DropdownMenuItem(
                                                  value: 'Others',
                                                  child: Text('Others')),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDesignation = value;
                                                print(
                                                    'Selected designation: $_selectedDesignation');
                                              });
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              labelText: 'Select Designation',
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          DropdownButtonFormField<String>(
                                            value: _selectedCategory,
                                            items: const [
                                              DropdownMenuItem(
                                                  value: 'UTR',
                                                  child: Text('UTR')),
                                              DropdownMenuItem(
                                                  value: 'Fresh',
                                                  child: Text('Fresh')),
                                              DropdownMenuItem(
                                                  value: 'Shopping',
                                                  child: Text('Shopping')),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedCategory = value;
                                                print(
                                                    'Selected Category: $_selectedDesignation');
                                              });
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              labelText: 'Select Category',
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 30),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: _selectedType,
                                                    items: const [
                                                      DropdownMenuItem(
                                                          value: 'OTR',
                                                          child: Text('OTR')),
                                                      DropdownMenuItem(
                                                          value: 'UTR',
                                                          child: Text('UTR')),
                                                      DropdownMenuItem(
                                                          value: 'Others',
                                                          child:
                                                              Text('Others')),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _selectedType = value;
                                                        print(
                                                            'Selected Type: $_selectedDesignation');
                                                      });
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      labelText: 'Select Type',
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: TextFormField(
                                                    controller: _MailController,
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      labelText: 'Mail',
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              controller: _dobController,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                labelText: 'DOB',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                      Center(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 20),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth *
                                                        0.3, // Adjust width based on screen size
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            _PanCardController,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15),
                                                          labelText: 'Pancard',
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          20), // Space between fields
                                                  SizedBox(
                                                    width: screenWidth *
                                                        0.3, // Adjust width based on screen size
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            _MobileController,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15),
                                                          labelText: 'Mobile',
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
                                              SizedBox(
                                                width: screenWidth *
                                                    0.2, // Adjust width based on screen size
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: TextFormField(
                                                    controller:
                                                        _PasswordController,
                                                    obscureText:
                                                        visibilityProvider
                                                            .isObscured,
                                                    decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      border:
                                                          const OutlineInputBorder(),
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          visibilityProvider
                                                                  .isObscured
                                                              ? Icons
                                                                  .visibility_off
                                                              : Icons
                                                                  .visibility,
                                                        ),
                                                        onPressed: () {
                                                          visibilityProvider
                                                              .toggleVisibility();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 260,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 32, 32, 32),
                                  ),
                                  onPressed: uploadToFirestore,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<ExcelUploadProvider>(
                        builder: (context, provider, _) => Text(
                          provider.uploadStatus,
                          style: TextStyle(
                            color: provider.uploadStatus
                                    .startsWith('Data uploaded')
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
            ],
          );
        },
      ),
    );
  }
}
