import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFreshEmployee extends StatefulWidget {
  const AddFreshEmployee({Key? key}) : super(key: key);

  @override
  _AddFreshEmployeeState createState() => _AddFreshEmployeeState();
}

class _AddFreshEmployeeState extends State<AddFreshEmployee> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('userdata');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shipmentController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _mfnController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timedateController = TextEditingController();
  TextEditingController? _selectedTimeSlotController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedTimeSlotController = TextEditingController();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _shipmentController.dispose();
    _mfnController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _locationController.dispose();
    _timedateController.dispose();
    _selectedTimeSlotController!.dispose();
    super.dispose();
  }

  Future<void> _addDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        Timestamp dateTimeStamp = Timestamp.fromDate(_selectedDate!);

        final data = {
          'Time': _selectedTimeSlotController!.text,
          'bags': _shipmentController.text,
          'orders': _pickupController.text,
          'cash': _mfnController.text,
          'ID': _idController.text,
          'Name': _nameController.text,
          'Date': dateTimeStamp,
          'Location': _locationController.text,
        };

        await users.add(data);
        _showSuccessDialog();
        _clearShoppingFields();
      } catch (e) {
        print('Error adding employee: $e');
        _showErrorDialog();
      }
    } else {
      _showValidationErrorDialog();
    }
  }
  void _clearShoppingFields() {
    _shipmentController.clear();
    _pickupController.clear();
    _mfnController.clear();
    _nameController.clear();
    _idController.clear();
    _locationController.clear();
    _timedateController.clear();
    _selectedTimeSlotController!.clear();
    _selectedDate = null;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Employee data added successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add employee data. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showValidationErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content:
              Text('Please fill out all fields before marking attendance.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, right: 15, left: 15, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Add Employee Data',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _nameController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 30),
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _idController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Employee ID",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.confirmation_number,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Employee ID is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _timedateController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Date",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _selectedDate = pickedDate;
                                          _timedateController.text =
                                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _locationController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Location",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Location is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _selectedTimeSlotController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Time",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.access_time,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Shift is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _shipmentController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "bags",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.shopping_bag,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Shipment is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _pickupController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Orders",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _mfnController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Cash",
                                  contentPadding: const EdgeInsets.all(10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 70),
                                  prefixIcon: Icon(
                                    Icons.format_list_bulleted,
                                    color: Colors.grey.shade500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'MFN is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 300),
                              child: Container(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: _addDetails,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Mark Attendance',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }
}
