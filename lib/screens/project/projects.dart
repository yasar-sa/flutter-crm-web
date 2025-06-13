import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    const String apiUrl = "https://real-pro-service.onrender.com/api/projects";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          projects = data.map((project) {
            return {
              "id": project["_id"] ?? project["id"] ?? "",
              "name": project["data"]["projectName"] ?? "Unknown Project",
              "location": project["data"]["location"] ?? "Unknown Location",
              "area": project["data"]["area"] ?? "N/A",
              "plots": project["plots"] != null ? project["plots"].length : 0,
            };
          }).toList();
          isLoading = false;
          hasError = false;
        });
      } else {
        _handleError("Failed to load projects");
      }
    } catch (e) {
      _handleError("Error fetching projects: $e");
    }
  }

  Future<void> _editProject(
      int index, String name, String location, String area) async {
    final String? projectId = projects[index]["id"];
    if (projectId == null || projectId.isEmpty) {
      _showSnackBar("Error: Project ID is missing");
      return;
    }

    final String apiUrl =
        "https://real-pro-service.onrender.com/api/projects/$projectId";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": {
            "projectName": name,
            "location": location,
            "area": area,
          },
        }),
      );

      if (response.statusCode == 200) {
        fetchProjects();
        _showSnackBar("Project updated successfully!");
      } else {
        _showSnackBar("Failed to update project");
      }
    } catch (e) {
      _showSnackBar("Error updating project: $e");
    }
  }

  Future<void> _addNewProject(String name, String location, String area) async {
    const String apiUrl = "https://real-pro-service.onrender.com/api/projects";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": {
            "projectName": name,
            "location": location,
            "area": area,
            "dtpcNumber": "DTPCXXXX",
            "localBodyApproval": "LBAXXXX",
            "rercAppNo": "RERCXXXXX",
            "parentDocuments": {},
            "uploadedDocuments": {},
          },
          "plots": []
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchProjects();
        _showSnackBar("Project added successfully!");
      } else {
        _showSnackBar("Failed to add project");
      }
    } catch (e) {
      _showSnackBar("Error adding project: $e");
    }
  }

  Future<void> _deleteProject(int index) async {
    final String? projectId = projects[index]["id"];

    if (projectId == null || projectId.isEmpty) {
      _showSnackBar("Error: Project ID is missing");
      return;
    }

    final String apiUrl =
        "https://real-pro-service.onrender.com/api/projects/$projectId";

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() => projects.removeAt(index));
        _showSnackBar("Project deleted successfully!");
      } else {
        _showSnackBar("Failed to delete project");
      }
    } catch (e) {
      _showSnackBar("Error deleting project: $e");
    }
  }

  void _showEditProjectDialog(int index) {
    TextEditingController nameController =
        TextEditingController(text: projects[index]["name"]);
    TextEditingController locationController =
        TextEditingController(text: projects[index]["location"]);
    TextEditingController areaController =
        TextEditingController(text: projects[index]["area"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Project", style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Project Name")),
            TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Location")),
            TextField(
                controller: areaController,
                decoration: InputDecoration(labelText: "Area (sq ft)")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  locationController.text.isNotEmpty &&
                  areaController.text.isNotEmpty) {
                _editProject(index, nameController.text,
                    locationController.text, areaController.text);
                Navigator.pop(context);
              }
            },
            child: Text("Update", style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProject(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Project",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this project?",
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteProject(index);
            },
            child:
                Text("Delete", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController areaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Project", style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Project Name")),
            TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Location")),
            TextField(
                controller: areaController,
                decoration: InputDecoration(labelText: "Area (sq ft)")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  locationController.text.isNotEmpty &&
                  areaController.text.isNotEmpty) {
                _addNewProject(nameController.text, locationController.text,
                    areaController.text);
                Navigator.pop(context);
              }
            },
            child: Text("Add", style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _handleError(String message) {
    setState(() {
      hasError = true;
      isLoading = false;
    });
    print(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.poppins())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects",
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Available Projects",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (hasError)
              Center(
                  child: Text("Failed to load projects. Try again later.",
                      style: GoogleFonts.poppins(color: Colors.red))),
            if (!isLoading && !hasError) Expanded(child: _buildProjectList()),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: _showAddProjectDialog,
                child: Text("+ Add New Project",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList() {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(project["name"],
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(
                "Location: ${project["location"]}\nArea: ${project["area"]}\nPlots: ${project["plots"]}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //     icon: const Icon(Icons.edit, color: Colors.blue),
                //     onPressed: () => _showEditProjectDialog(index)),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteProject(index)),
              ],
            ),
          ),
        );
      },
    );
  }
}
