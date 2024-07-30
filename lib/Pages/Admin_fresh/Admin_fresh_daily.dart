import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cordrila_exe/Pages/Admin_fresh/Admin_fresh_monthly.dart';
import 'package:cordrila_exe/Pages/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/Loaders/Spinner.dart';
import '../transition.dart';

class FreshFilterProviderDaily extends ChangeNotifier {
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

class FreshFilterPageDaily extends StatefulWidget {
  const FreshFilterPageDaily({super.key});

  @override
  _FreshFilterPageDailyState createState() => _FreshFilterPageDailyState();
}

class _FreshFilterPageDailyState extends State<FreshFilterPageDaily>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchNewData();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        print('Search Query: $_searchQuery');
      });
      _searchController.value = _searchController.value.copyWith(
        text: _searchController.text.toUpperCase(),
        selection: _searchController.selection,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderDaily>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Tooltip(
                      message: "Enter Full Name",
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.search, color: Colors.blue),
                      onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Tooltip(
            message: 'Monthly Page',
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminFreshMonthly(),
                  ),
                );
              },
              icon: const Icon(
                Icons.forward,
                color: Colors.black,
              ),
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        backgroundColor: Colors.grey.shade200,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const TransitionPage(
                          destination: AdminFreshMonthly());
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                );
              },
              child: Tooltip(
                  message: "Double Tap To Get Monthly Data",
                  child: _buildTabButton(context, 0, 'Daily'))),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildTabContent(context),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: filterProvider.selectedIndex == 0
                ? _buildDateButton(context)
                : filterProvider.selectedIndex == 2
                    ? _buildMonthPickerButton(context)
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, int index, String text) {
    final filterProvider =
        Provider.of<FreshFilterProviderDaily>(context, listen: false);
    return TextButton(
      onPressed: () {
        filterProvider.setIndex(index);

        filterProvider.setDate(null);

        if (index == 1) {
          filterProvider.setMonth(null);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: filterProvider.selectedIndex == index
              ? Colors.black
              : Colors.grey,
          fontWeight: filterProvider.selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderDaily>(context);
    {
      return filterProvider.selectedDate == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/error.gif"),
                    radius: 50,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select a date!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : _buildDailyDataTab(context);
    }
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
          'Date: ${_formatDateTime(data['Date'])}',
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
      if (data['GSF'] != null && data['GSF'].toString().isNotEmpty) {
        details.add(Text(
          'GSF: ${data['GSF']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ));
      }
      if (data['Login'] != null && data['Login'].toString().isNotEmpty) {
        details.add(Text(
          'Login: ${data['Login']}',
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

  Widget _buildDailyDataTab(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderDaily>(context);
    final DateTime? selectedDate = filterProvider.selectedDate;
    if (selectedDate == null) {
      return const SizedBox.shrink();
    }

    final DateTime startOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
    final DateTime endOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    String transformedSearchQuery = _searchQuery;
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('userdata')
                .where('Date', isGreaterThanOrEqualTo: startOfDay)
                .where('Date', isLessThanOrEqualTo: endOfDay)
                .where('bags', isNotEqualTo: true)
                .where('Name', isGreaterThanOrEqualTo: transformedSearchQuery)
                .where('Name',
                    isLessThanOrEqualTo: '$transformedSearchQuery\uf8ff')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(
                  child: BoxLoader(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              final documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return const Center(
                  child: Text('No data found for the selected date.'),
                );
              }
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
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                _downloadDailyData(context);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Download',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderDaily>(context);
    final dateFormat = DateFormat('dd-MM-yyyy');
    final formattedDate = filterProvider.selectedDate == null
        ? 'Select Date'
        : dateFormat.format(filterProvider.selectedDate!);

    return TextButton.icon(
      onPressed: () => _pickDate(context),
      icon: const Icon(
        Icons.calendar_today,
        color: Colors.black,
      ),
      label: Text(
        formattedDate,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMonthPickerButton(BuildContext context) {
    final filterProvider = Provider.of<FreshFilterProviderDaily>(context);
    final dateFormat = DateFormat('MMMM yyyy');
    final formattedDate = filterProvider.selectedDate == null
        ? 'Select Month'
        : dateFormat.format(filterProvider.selectedDate!);

    return TextButton.icon(
      onPressed: () => _pickMonth(context),
      icon: const Icon(
        Icons.calendar_today,
        color: Colors.black,
      ),
      label: Text(
        formattedDate,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final filterProvider =
        Provider.of<FreshFilterProviderDaily>(context, listen: false);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: filterProvider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Theme(
            data: Theme.of(context).copyWith(
              appBarTheme: const AppBarTheme(foregroundColor: Colors.yellow),
              colorScheme: const ColorScheme.dark(
                brightness: Brightness.light,
                surface: Colors.white,
                primary: Colors.black,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(
                      bottom: 5, left: 5, right: 5, top: 5),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (pickedDate != null && pickedDate != filterProvider.selectedDate) {
      filterProvider.setDate(pickedDate);
    }
  }

  Future<void> _pickMonth(BuildContext context) async {
    final filterProvider =
        Provider.of<FreshFilterProviderDaily>(context, listen: false);

    final DateTime? pickedDate = await showMonthPicker(
      context: context,
      initialDate: filterProvider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != filterProvider.selectedDate) {
      filterProvider.setDate(null);
      filterProvider.setDate(pickedDate);
    }
  }

  Future<void> _downloadDailyData(BuildContext context) async {
    try {
      final filterProvider =
          Provider.of<FreshFilterProviderDaily>(context, listen: false);
      final List<List<dynamic>> rows = [];

      final DateTime? selectedDate = filterProvider.selectedDate;
      if (selectedDate == null) {
        return;
      }

      final DateTime startOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
      final DateTime endOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      final snapshot = await FirebaseFirestore.instance
          .collection('userdata')
          .where('Date', isGreaterThanOrEqualTo: startOfDay)
          .where('Date', isLessThanOrEqualTo: endOfDay)
          .where('bags', isNotEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        _showAlertDialog(
            context, 'No Data Found', 'No data found for selected date.');
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
        'GSF',
        'Login',
      ];
      rows.add(headers);

      for (final doc in snapshot.docs) {
        final employeedata = doc.data();
        DateFormat('dd-MM-yyyy hh:mm').format(employeedata['Date'].toDate());
        final row = [
          employeedata['ID'],
          employeedata['Name'],
          employeedata['Location'],
          employeedata['Date'],
          employeedata['Time'],
          employeedata['bags'],
          employeedata['orders'],
          employeedata['cash'],
          employeedata['GSF'],
          employeedata['Login'],
        ];
        rows.add(row);
      }

      final formattedDate =
          DateFormat('dd_MM_yyyy_HH_mm_ss').format(DateTime.now());
      await _downloadCSV(context, rows, 'Fresh_daily_data_$formattedDate');
    } catch (e) {
      print('Error downloading data: $e');
      _showAlertDialog(context, 'Error', 'Error downloading data');
    }
  }

  Future<String> _getDownloadDirectory() async {
    const String downloadDirectory = 'C:\\Downloads';

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
      DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '$downloadDirectory/$fileName.csv';

      final List<List<dynamic>> formattedRows = [];

      for (final row in rows) {
        final List<dynamic> formattedRow = List.from(row);

        if (formattedRow.length > 3 && formattedRow[3] is Timestamp) {
          final Timestamp timestamp = formattedRow[3] as Timestamp;
          final DateTime date = timestamp.toDate();
          formattedRow[3] = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
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
  try {} catch (e) {
    print('Error storing data in SharedPreferences: $e');
  }
}
