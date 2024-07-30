import 'dart:convert';
import 'package:cordrila_exe/Pages/ChangeAdminPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cordrila_exe/Pages/Add_emp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Edit_Prfoile.dart';

class UserProvider with ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  String _searchQuery = '';

  List<DocumentSnapshot> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;

  UserProvider() {
    searchController.addListener(() {
      print('Search query updated: ${searchController.text}');
      setSearchQuery(searchController.text);
    });
    _fetchAllUsers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void setSearchQuery(String query) {
    print('Setting search query: $query');
    _searchQuery = query.trim().toUpperCase();
    _searchEmployee(); // Trigger search whenever search query changes
    notifyListeners();
  }

  void _fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('USERS').get();
      _searchResults = querySnapshot.docs;

      // Convert _searchResults to a list of maps
      List<Map<String, dynamic>> usersData = _searchResults
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Save data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('usersData', jsonEncode(usersData));
      print('Data saved to SharedPreferences'); // Debug print

      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getSavedUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? usersDataString = prefs.getString('usersData');

      if (usersDataString != null) {
        List<dynamic> usersDataList = jsonDecode(usersDataString);
        return usersDataList
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error retrieving data from SharedPreferences: $e');
      return [];
    }
  }

  void _searchEmployee() async {
    String searchQuery = _searchQuery.trim();

    print('Searching for: $searchQuery');

    if (searchQuery.isNotEmpty) {
      try {
        QuerySnapshot querySnapshotByName = await FirebaseFirestore.instance
            .collection('USERS')
            .where('Employee Name', isGreaterThanOrEqualTo: searchQuery)
            .where('Employee Name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .get();

        QuerySnapshot querySnapshotByEmpCode = await FirebaseFirestore.instance
            .collection('USERS')
            .where('EmpCode', isEqualTo: searchQuery)
            .get();

        // Combine results from both queries
        Set<DocumentSnapshot> combinedResults = {
          ...querySnapshotByName.docs,
          ...querySnapshotByEmpCode.docs,
        };

        print('Number of documents found: ${combinedResults.length}');

        _searchResults = combinedResults.toList();

        // Convert _searchResults to a list of maps
        List<Map<String, dynamic>> usersData = _searchResults
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Save data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('usersData', jsonEncode(usersData));
        print('Data saved to SharedPreferences'); // Debug print

        notifyListeners();
      } catch (e) {
        print('Error searching employees: $e');
      }
    } else {
      print('Search query is empty, fetching all users.');
      _fetchAllUsers();
    }
  }
}

class SearchUser extends StatelessWidget {
  const SearchUser({super.key});

  String _getImageForTitle(String? title, String? location) {
    if (title == 'DRIVER') {
      if (location == 'FRESH') {
        return 'assets/fresh_boy.png'; // Adjust path as per your actual image path
      } else if (location == 'SHOPPING') {
        return 'assets/SHOPPING_BOY.png'; // Adjust path as per your actual image path
      }
    }

    switch (title) {
      case 'DEVELOPER':
        return 'assets/developerimage.jpeg';
      case 'HR':
        return 'assets/HR.jpeg';
      case 'DISPATCHER':
        return 'assets/dispatcher.jpeg';
      case 'JUNIOR HR':
        return 'assets/people.png';
      case 'SUPERVISOR':
        return 'assets/SUPERVISOR.jpeg';
      case 'SORTER':
        return 'assets/SORTER.jpg';
      case 'TEAM LEAD':
        return 'assets/TEAM LEAD.jpeg';
      default:
        return 'assets/meeting-businessperson-clip-art-business-discussion-cliparts.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    void _deleteDocument(String documentId) async {
      try {
        // Fetch the document to get the empCode
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('USERS')
            .doc(documentId)
            .get();

        // Check if the document exists and data is not null
        if (documentSnapshot.exists && documentSnapshot.data() != null) {
          // Cast the data to a Map
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          // Get the empCode from the document data
          String empCode = data['empCode'];

          // Delete the document
          await FirebaseFirestore.instance
              .collection('USERS')
              .doc(documentId)
              .delete();

          // Show a snackbar with the empCode of the deleted document
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Document with empCode $empCode deleted successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          // Fetch all users again
          userProvider._fetchAllUsers();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Document does not exist or data is null'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Show an error message if deletion fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete document: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    void _showDeleteConfirmationDialog(String documentId) async {
      try {
        // Fetch the document to get the empCode
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('USERS')
            .doc(documentId)
            .get();

        // Check if the document exists and data is not null
        if (documentSnapshot.exists && documentSnapshot.data() != null) {
          // Cast the data to a Map
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          // Get the empCode from the document data
          String empCode = data['Employee Name'];

          // Show the confirmation dialog with the empCode
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Confirm Deletion',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                content: Text('Delete $empCode Permanently?',
                    style: TextStyle(color: Colors.black)),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteDocument(documentId);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Document does not exist or data is null'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch document: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoDialogRoute(
                                  builder: (context) => ChangePasswordPage(),
                                  context: context));
                        },
                        child: const Text('Change Password'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoDialogRoute(
                                  builder: (context) => EmployeeEditPage(),
                                  context: context));
                        },
                        child: const Text('Add User'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.settings_sharp,
              color: Colors.blue,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 70,
        title: Tooltip(
          message: "Enter ID or Name",
          child: Container(
            width: 500,
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
                    controller: userProvider.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: userProvider._searchEmployee,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            int crossAxisCount = screenWidth > 1000 ? 3 : 1;

            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: userProvider.searchResults.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 13.0,
                            mainAxisSpacing: 13.0,
                          ),
                          itemCount: userProvider.searchResults.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc =
                                userProvider.searchResults[index];
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;

                            String imagePath = _getImageForTitle(
                                data['Business Title'], data['Location']);

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                      initialData: doc,
                                      initialId: data['EmpCode'],
                                      initialSearchTerm: data['EmpCode'],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        color: Colors.red,
                                        iconSize: 15,
                                        icon: Icon(Icons.delete),
                                        onPressed: () =>
                                            _showDeleteConfirmationDialog(doc
                                                .id), // Show confirmation dialog before deleting document
                                      ),
                                      Center(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              AssetImage(imagePath),
                                          onBackgroundImageError: (_, __) {
                                            imagePath = 'assets/default.png';
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Text(
                                          data['Employee Name'] ?? 'No Name',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: Text(
                                          ' ${data['EmpCode'] ?? 'No ID'}',
                                          style: const TextStyle(fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Designation',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                '${data['Business Title'] ?? 'No Title'}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 30),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Category',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                '${data['Location'] ?? 'No Location'}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 30),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Station',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                '${data['StationCode'] ?? 'No StationCode'}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Center(
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage('assets/no data.gif'),
                                  width: 200,
                                  height: 200,
                                ),
                                Text(
                                  "No Data On Selected Name",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
