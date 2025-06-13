import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerInformationPage extends StatelessWidget {
  final List<Map<String, String>> customers = [
    {
      'name': 'John Smith',
      'projectId': '2345',
      'plotNo': 'Phase A-123',
      'customerId': '9876',
      'status': 'Advance',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'Emma Watson',
      'projectId': '5432',
      'plotNo': 'Phase B-456',
      'customerId': '5678',
      'status': 'Pending',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
    {
      'name': 'David Warner',
      'projectId': '6789',
      'plotNo': 'Phase C-789',
      'customerId': '1234',
      'status': 'Completed',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'name': 'Sophia Lee',
      'projectId': '7890',
      'plotNo': 'Phase D-321',
      'customerId': '4321',
      'status': 'Processing',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {},
        // ),
        title: Text(
          'Customer Information',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Add',
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search customers...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(customer['image']!),
                    ),
                    title: Text(
                      customer['name']!,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project ID: ${customer['projectId']}',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade700),
                        ),
                        Text(
                          'Plot No: ${customer['plotNo']}',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade700),
                        ),
                        Text(
                          'Customer ID: ${customer['customerId']}',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey.shade700),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
