import 'package:cordrila_exe/Pages/Add_emp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Edit_Prfoile.dart';

class UserProvider with ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isExpanded = false;
  String _searchQuery = '';

  List<DocumentSnapshot> get searchResults => _searchResults;
  bool get isExpanded => _isExpanded;
  String get searchQuery => _searchQuery;

  UserProvider() {
    searchController.addListener(_searchEmployee);
    _fetchAllUsers();
  }

  @override
  void dispose() {
    searchController.removeListener(_searchEmployee);
    searchController.dispose();
    super.dispose();
  }

  void toggleExpand() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toUpperCase();
    notifyListeners();
  }

  void _fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('USERS').get();
      _searchResults = querySnapshot.docs;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _searchEmployee() async {
    String searchName = _searchQuery;

    if (searchName.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('USERS')
            .where('Employee Name', isGreaterThanOrEqualTo: searchName)
            .where('Employee Name', isLessThanOrEqualTo: '$searchName\uf8ff')
            .get();

        _searchResults = querySnapshot.docs;
        notifyListeners();
      } catch (e) {
        print('Error searching employees: $e');
      }
    } else {
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
        await FirebaseFirestore.instance
            .collection('USERS')
            .doc(documentId)
            .delete();
        // Show a success message or update UI as needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Refresh the search results after deletion
        userProvider._fetchAllUsers();
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

    void _showDeleteConfirmationDialog(String documentId) {
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
            content: Text('Are you sure to delete this document?',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
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
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Tooltip(
              message: "Add Employee",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoDialogRoute(
                              builder: (context) => EmployeeEditPage(),
                              context: context));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 30,
                    )),
              ))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 70,
        title: Container(
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
                                      initialId: data['Employee Name'],
                                      initialSearchTerm: data['Employee Name'],
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
