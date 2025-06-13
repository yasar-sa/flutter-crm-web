import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crm/screens/leads/add_lead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Leads extends StatefulWidget {
  const Leads({super.key});

  @override
  State<Leads> createState() => _LeadsState();
}

class _LeadsState extends State<Leads> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _leads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchLeads();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchLeads() async {
    final url = Uri.parse("https://real-pro-service.onrender.com/api/leads");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          // Extract leads from the response, correctly accessing the "data" field
          List<dynamic> extractedLeads = responseData.map((lead) {
            return {
              "_id": lead["id"], // Use the "id" field
              ...lead['data'], // Merge the lead's actual data
            };
          }).toList();

          setState(() {
            _leads = extractedLeads;
            _isLoading = false;
          });
        } else {
          print("Unexpected response format: $responseData");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print("Failed to load leads: ${response.body}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching leads: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteLead(String leadId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();

    if (confirmDelete == true) {
      final url = Uri.parse(
          "https://real-pro-service.onrender.com/api/leads/$leadId"); // Correct the URL with lead ID

      try {
        final response = await http.delete(url);
        if (response.statusCode == 200 || response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lead deleted successfully")),
          );
          _fetchLeads(); // Refresh after deletion
        } else {
          print("Failed to delete lead: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to delete lead")),
          );
        }
      } catch (e) {
        print("Error deleting lead: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error deleting lead")),
        );
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Lead",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to delete this lead?",
              style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete",
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  List<dynamic> _filterLeadsByStatus(String status) {
    return _leads.where((lead) {
      final leadStatus = (lead['status'] ?? "").toString().toLowerCase();
      return leadStatus == status.toLowerCase();
    }).toList();
  }

  Widget _buildLeadList(String status) {
    final filteredLeads = _filterLeadsByStatus(status);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredLeads.isEmpty) {
      return const Center(child: Text("No leads found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredLeads.length,
      itemBuilder: (context, index) {
        final lead = filteredLeads[index];

        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: Text(
            lead["personalDetails"]["firstName"] ?? "No Name",
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            lead["contactDetails"]["phone"] ?? "No Phone",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              final id = lead["_id"];
              if (id != null) {
                _deleteLead(id);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Lead ID not found")));
              }
            },
          ),
          onTap: () {
            _showLeadDetails(lead);
          },
        );
      },
    );
  }

  void _showLeadDetails(dynamic lead) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              "${lead["personalDetails"]["firstName"]} ${lead["personalDetails"]["lastName"]}"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("DOB: ${lead["personalDetails"]["dob"]}"),
              Text("Phone: ${lead["contactDetails"]["phone"]}"),
              Text("Email: ${lead["contactDetails"]["email"]}"),
              Text(
                  "Preferred Property: ${lead["propertyPreferences"]["type"]}"),
              Text(
                  "Budget: ₹${lead["propertyPreferences"]["budgetMin"]} - ₹${lead["propertyPreferences"]["budgetMax"]}"),
              Text("Location: ${lead["propertyPreferences"]["location"]}"),
              Text("Credit Score: ${lead["financialDetails"]["creditScore"]}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Lead Management",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.brown,
            labelColor: Colors.brown,
            unselectedLabelColor: Colors.brown.withOpacity(0.5),
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "New Leads"),
              Tab(text: "Pending Leads"),
              Tab(text: "Finished Leads"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeadList("new"),
                _buildLeadList("pending"),
                _buildLeadList("finished"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddLeadPage(), // Ensure AddLeadPage is imported
            ),
          );

          if (result == true) {
            _fetchLeads(); // Refresh the leads list after adding a new lead
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
