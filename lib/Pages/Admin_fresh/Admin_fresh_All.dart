import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cordrila_exe/Pages/Admin_fresh/Admin_fresh_monthly.dart';
import 'package:cordrila_exe/Widgets/Loaders/Loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Add_Employee_details.dart';
import 'Admin_fresh_daily.dart';

class FreshFilterProviderAll extends ChangeNotifier {
  int selectedIndex = 0;
  DateTime? selectedDate;
  DateTime? selectedMonth;

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void setMonth(DateTime? month) {
    selectedMonth = month;
    notifyListeners();
  }
}

class FreshFilterPageAll extends StatefulWidget {
  const FreshFilterPageAll({super.key});

  @override
  _FreshFilterPageAllState createState() => _FreshFilterPageAllState();
}

class _FreshFilterPageAllState extends State<FreshFilterPageAll>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    try {
      fetchNewData();
    } catch (e) {
      print('Error calling fetchNewData: $e');
      // Handle error appropriately, such as showing a message to the user
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderAll>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFreshEmployee(),
                    ));
              },
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
              ))
        ],
        automaticallyImplyLeading: false,
        title: const Text(
          'Fresh All',
          style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
        ),
        toolbarHeight: 55,
        backgroundColor: Colors.grey.shade200,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                enableFeedback: true,
                exitDuration: const Duration(milliseconds: 1),
                message: "Fresh All day's Data",
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Sorry"),
                          content: const Text("Already on All page"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "All",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Tooltip(
                exitDuration: const Duration(milliseconds: 1),
                message: "Fresh Daily Data",
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const FreshFilterPageDaily(),
                          ));
                    },
                    child: const Text(
                      "Daily",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              Tooltip(
                message: "Fresh Monthly Data",
                exitDuration: const Duration(milliseconds: 1),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AdminFreshMonthly(),
                        ),
                      );
                    },
                    child: const Text(
                      "Monthly",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: filterProvider.selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                await _downloadAllData(context);
              },
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.download,
                color: Colors.white,
              ),
            )
          : null,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildTabContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderAll>(context);
    switch (filterProvider.selectedIndex) {
      case 0:
        return _buildAllDataTab(context);

      default:
        return const Center(child: Text('Monthly Data'));
    }
  }

  Widget _buildAllDataTab(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userdata')
          .where('bags', isNotEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinnerWidget());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final documents = snapshot.data!.docs;
        return ListView.separated(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final employeedata =
                documents[index].data() as Map<String, dynamic>;
            return _buildListItem(employeedata);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
    );
  }

  Widget _buildListItem(Map<String, dynamic> employeedata) {
    List<Widget> buildEmployeeDetails(Map<String, dynamic> data) {
      List<Widget> details = [
        Text(
          '${data['ID']}',
          style: const TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          'Date: ${_formatDateTime(data['Date'])}', // Format date here
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
        Text(
          '${data['Name']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
        Text(
          'Location: ${data['Location']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ];

      if (data['Time'] != null && data['Time'].toString().isNotEmpty) {
        details.add(Text(
          'Time: ${data['Time']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ));
      }
      if (data['bags'] != null && data['bags'].toString().isNotEmpty) {
        details.add(Text(
          'bags: ${data['bags']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ));
      }
      if (data['orders'] != null && data['orders'].toString().isNotEmpty) {
        details.add(Text(
          'orders: ${data['orders']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ));
      }
      if (data['cash'] != null && data['cash'].toString().isNotEmpty) {
        details.add(Text(
          'cash: ${data['cash']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ));
      }

      return details;
    }

    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildEmployeeDetails(employeedata),
        ),
      ),
    );
  }

  String _formatDateTime(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formattedDate = DateFormat.yMMMMd().add_jm().format(dateTime);
    return formattedDate;
  }

  Future<String> _getDownloadDirectory() async {
    // Define the directory on the C drive
    const String downloadDirectory = 'C:\\Downloads';

    // Create the directory if it doesn't exist
    final Directory directory = Directory(downloadDirectory);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return downloadDirectory;
  }

  Future<void> _downloadCSV(
      BuildContext context, List<List<dynamic>> rows, String fileName) async {
    try {
      final String downloadDirectory = await _getDownloadDirectory();
      DateTime.now().millisecondsSinceEpoch.toString(); // Unique timestamp
      final String filePath = '$downloadDirectory/$fileName.csv';

      final List<List<dynamic>> formattedRows = [];

      // Convert each row to ensure proper date format
      for (final row in rows) {
        final List<dynamic> formattedRow =
            List.from(row); // Make a copy of the original row

        // Format the 'Date' column if it exists in your data
        if (formattedRow.length > 3 && formattedRow[3] is Timestamp) {
          final Timestamp timestamp = formattedRow[3] as Timestamp;
          final DateTime date = timestamp.toDate();
          formattedRow[3] = DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(date); // Format the date as needed
        }

        formattedRows.add(formattedRow);
      }

      final String csv = const ListToCsvConverter().convert(formattedRows);

      final File file = File(filePath);
      await file.writeAsString(csv);

      _showAlertDialog(
        context,
        'Success',
        'CSV file downloaded successfully',
        success: true,
      );
    } catch (e) {
      print('Error downloading CSV: $e');
      _showAlertDialog(context, 'Error', 'Error downloading CSV');
    }
  }

  Future<void> _downloadAllData(BuildContext context) async {
    try {
      final List<List<dynamic>> rows = [];

      final snapshot = await FirebaseFirestore.instance
          .collection('userdata')
          .where('bags', isNotEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        _showAlertDialog(
            context, 'No Data Found', 'No data found in the database.');
        return;
      }

      final headers = [
        'ID',
        'Name',
        'Location',
        'Date',
        'Time',
        'bags',
        'orders',
        'cash',
      ];
      rows.add(headers);

      for (final doc in snapshot.docs) {
        final employeedata = doc.data();
        final row = [
          employeedata['ID'],
          employeedata['Name'],
          employeedata['Location'],
          employeedata['Date'],
          employeedata['Time'],
          employeedata['bags'],
          employeedata['orders'],
          employeedata['cash'],
        ];
        rows.add(row);
      }

      await _downloadCSV(context, rows, 'fresh_all_data');
    } catch (e) {
      print('Error downloading all data: $e');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message,
      {bool success = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (success)
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/delivery.gif"),
                  radius: 30,
                ),
              const SizedBox(
                height: 20,
              ),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Future<void> storeLastFetchTime(DateTime lastFetchTime) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('lastFetchTime', lastFetchTime.toIso8601String());
}

Future<DateTime?> getLastFetchTime() async {
  final prefs = await SharedPreferences.getInstance();
  final lastFetchTimeString = prefs.getString('lastFetchTime');
  return lastFetchTimeString != null
      ? DateTime.parse(lastFetchTimeString)
      : null;
}

Future<void> fetchNewData() async {
  DateTime? lastFetchTime = await getLastFetchTime();

  QuerySnapshot querySnapshot;
  if (lastFetchTime != null) {
    querySnapshot = await FirebaseFirestore.instance
        .collection('userdata')
        .where('updatedAt', isGreaterThan: lastFetchTime)
        .get();
  } else {
    querySnapshot =
        await FirebaseFirestore.instance.collection('userdata').get();
  }

  for (var doc in querySnapshot.docs) {
    if (doc.exists && doc.data() is Map<String, dynamic>) {
      storeDataInSharedPreferences(doc.data() as Map<String, dynamic>);
    } else {
      print('Document data is not of type Map<String, dynamic>: ${doc.id}');
    }
  }

  await storeLastFetchTime(DateTime.now());
}

void storeDataInSharedPreferences(Map<String, dynamic> data) async {
  try {
    
  } catch (e) {
    print('Error storing data in SharedPreferences: $e');
  }
}
