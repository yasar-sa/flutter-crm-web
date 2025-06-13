import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddLeadPage extends StatefulWidget {
  @override
  _AddLeadPageState createState() => _AddLeadPageState();
}

class _AddLeadPageState extends State<AddLeadPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _budgetMinController = TextEditingController();
  TextEditingController _budgetMaxController = TextEditingController();
  TextEditingController _creditScoreController = TextEditingController();

  String _status = "new"; // Default status

  Future<void> _addLead() async {
    if (!_formKey.currentState!.validate()) return;

    final leadData = {
      "data": {
        "personalDetails": {
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text
        },
        "contactDetails": {
          "phone": _phoneController.text,
          "email": _emailController.text
        },
        "propertyPreferences": {
          "budgetMin": int.tryParse(_budgetMinController.text) ?? 0,
          "budgetMax": int.tryParse(_budgetMaxController.text) ?? 0
        },
        "financialDetails": {
          "creditScore": int.tryParse(_creditScoreController.text) ?? 0
        },

        "status": _status // "new", "pending", "finished"
      }
    };

    final url = Uri.parse("https://real-pro-service.onrender.com/api/leads");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(leadData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lead added successfully!")),
        );
        Navigator.pop(context, true); // Go back & refresh lead list
      } else {
        print("Failed to add lead: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add lead")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding lead")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Lead")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: "First Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter first name" : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Enter last name" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Enter phone number" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: _budgetMinController,
                decoration: InputDecoration(labelText: "Min Budget"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _budgetMaxController,
                decoration: InputDecoration(labelText: "Max Budget"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _creditScoreController,
                decoration: InputDecoration(labelText: "Credit Score"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: ["new", "pending", "finished"]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status.toUpperCase()),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: "Lead Status"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addLead,
                child: Text("Add Lead"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
