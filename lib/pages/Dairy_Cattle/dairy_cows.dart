import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cow_details_page.dart';


class DairyCows extends StatefulWidget {
  const DairyCows({Key? key}) : super(key: key);

  @override
  State<DairyCows> createState() => _DairyCowsState();
}

class _DairyCowsState extends State<DairyCows> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _cowsStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(); // Initialize the search controller
    _cowsStream = FirebaseFirestore.instance.collection('Dairy_Cows').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dairy Cows',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by name or ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _searchCows(_searchController.text);
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildUserTable(),
      bottomNavigationBar: const BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add a new cow
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

  Widget _buildUserTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: _cowsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final query = _searchController.text.toLowerCase();

        final filteredDocs = snapshot.data!.docs.where((doc) {
          final name = (doc['name'] ?? '').toLowerCase();
          final tagNumber = (doc['tagNumber'] ?? '').toLowerCase();
          return name.contains(query) || tagNumber.contains(query);
        }).toList();

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CowDetailsPage(
                        cowData: filteredDocs[index].data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
                child: _buildUserTableRow(filteredDocs[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserTableRow(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Stack(
              children: [
                if (data['cowImage'] != null && data['cowImage'] != '')
                  Image.network(
                    data['cowImage'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  const Icon(Icons.pets, size: 50, color: Colors.grey),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Name:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('ID/TAG No:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data['tagNumber'] ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _searchCows(String query) {
    setState(() {
      _cowsStream = FirebaseFirestore.instance
          .collection('Dairy_Cows')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .snapshots();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
