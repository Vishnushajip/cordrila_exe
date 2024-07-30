import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/Loaders/Spinner.dart';

class ALWDUtrProviderMonthly extends ChangeNotifier {
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

class ALWDAdminUtrMonthly extends StatefulWidget {
  const ALWDAdminUtrMonthly({super.key});

  @override
  _ALWDAdminUtrMonthlyState createState() => _ALWDAdminUtrMonthlyState();
}

class _ALWDAdminUtrMonthlyState extends State<ALWDAdminUtrMonthly>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
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
    final filterProvider = Provider.of<ALWDUtrProviderMonthly>(context);
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
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
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
        toolbarHeight: 65,
        backgroundColor: Colors.grey.shade200,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabButton(context, 2, 'Monthly'),
            ],
          ),
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
            child: filterProvider.selectedIndex == 1
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
        Provider.of<ALWDUtrProviderMonthly>(context, listen: false);
    return TextButton(
      onPressed: () {
        // Set the selected index
        filterProvider.setIndex(index);

        // Reset selected date when switching tabs
        filterProvider.setDate(null);

        // Reset selected month when switching to the Daily tab
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
    final filterProvider = Provider.of<ALWDUtrProviderMonthly>(context);

    if (filterProvider.selectedDate == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/error.gif"),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Select a date!', // Customize text as needed
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return _buildMonthlyDataTab(context);
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

  Widget _buildDateButton(BuildContext context) {
    final filterProvider = Provider.of<ALWDUtrProviderMonthly>(context);
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
    final filterProvider = Provider.of<ALWDUtrProviderMonthly>(context);
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
        Provider.of<ALWDUtrProviderMonthly>(context, listen: false);
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
                primary: Colors.black, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(
                      bottom: 5, left: 5, right: 5, top: 5),
                  foregroundColor: Colors.black,
                  // OK button background color// button text color
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
        Provider.of<ALWDUtrProviderMonthly>(context, listen: false);

    final DateTime? pickedDate = await showMonthPicker(
      context: context,
      initialDate: filterProvider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != filterProvider.selectedDate) {
      // Reset selected date to null
      filterProvider.setDate(null);
      filterProvider.setDate(pickedDate);
    }
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

  Widget _buildMonthlyDataTab(BuildContext context) {
    final filterProvider = Provider.of<ALWDUtrProviderMonthly>(context);
    final DateTime? selectedDate = filterProvider.selectedDate;
    if (selectedDate == null) {
      return const SizedBox.shrink();
    }

    final DateTime startOfMonth =
        DateTime(selectedDate.year, selectedDate.month);
    final DateTime endOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);

    String capitalizeEachWord(String input) {
      if (input.isEmpty) return input;
      return input.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }

    String transformedSearchQuery = capitalizeEachWord(_searchQuery);

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('userdata')
                .where('Date', isGreaterThanOrEqualTo: startOfMonth)
                .where('Date', isLessThanOrEqualTo: endOfMonth)
                .where('Utr', isNotEqualTo: true)
                .where('Location', whereIn: ['ALWD'])
                .where('Name', isGreaterThanOrEqualTo: transformedSearchQuery)
                .where('Name',
                    isLessThanOrEqualTo: '$transformedSearchQuery\uf8ff')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
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
                  child: Text('No data found for the selected month.'),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () async {
                _downloadMonthlyData(context, startOfMonth);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, color: Colors.blue), // Download icon
                  SizedBox(
                      width: 8), // Add some space between the icon and the text
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

  Future<void> _downloadMonthlyData(
      BuildContext context, DateTime month) async {
    try {
      final List<List<dynamic>> rows = [];

      final DateTime startOfMonth = DateTime(month.year, month.month, 1);
      final DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);

      final snapshot = await FirebaseFirestore.instance
          .collection('userdata')
          .where('Date', isGreaterThanOrEqualTo: startOfMonth)
          .where('Date', isLessThanOrEqualTo: endOfMonth)
          .where('Utr', isNotEqualTo: true)
          .where('Location', whereIn: ['ALWD']).get();

      if (snapshot.docs.isEmpty) {
        _showAlertDialog(
            context, 'No Data Found', 'No data found for the selected month.');
        return;
      }

      final headers = [
        'ID',
        'Name',
        'Location',
        'Date',
      ];
      rows.add(headers);

      for (final doc in snapshot.docs) {
        final employeedata = doc.data();
        // Convert Timestamp to DateTime and format it in 12-hour format with AM/PM
        DateFormat('dd-MM-yyyy hh:mm').format(employeedata['Date'].toDate());
        final row = [
          employeedata['ID'],
          employeedata['Name'],
          employeedata['Location'],
          employeedata['Date'],
        ];
        rows.add(row);
      }

      DateFormat('MM_yyyy').format(month);
      final formattedDateTime =
          DateFormat('dd_MM_yyyy_HH_mm_ss').format(DateTime.now());
      await _downloadCSV(context, rows, 'Utr_monthly_data_$formattedDateTime');
    } catch (e) {
      print('Error downloading monthly data: $e');
      _showAlertDialog(context, 'Error', 'Error downloading monthly data');
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
