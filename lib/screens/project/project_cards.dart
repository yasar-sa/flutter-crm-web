import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_analytics.dart';
import '../services/project_service.dart';

class ProjectCards extends StatefulWidget {
  const ProjectCards({super.key});

  @override
  State<ProjectCards> createState() => _ProjectCardsState();
}

class _ProjectCardsState extends State<ProjectCards> {
  late Future<List<ProjectAnalytics>> projectAnalytics;

  @override
  void initState() {
    super.initState();
    projectAnalytics =
        ProjectService.fetchProjectAnalytics(); // Fetch data from API
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProjectAnalytics>>(
      future: projectAnalytics,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No projects available.'));
        }

        // Extract data for the chart, with null safety
        List<ProjectAnalytics> projects = snapshot.data!;

        return Card(
          child: Container(
            color: Color.fromARGB(255, 221, 221, 221),
            height: 280, // Fixed height for the ListView
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              itemCount: projects.length,
              separatorBuilder: (context, _) => SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  buildProjectCard(project: projects[index]),
            ),
          ),
        );
      },
    );
  }

  Widget buildProjectCard({required ProjectAnalytics project}) {
    return Container(
      width: 200,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3, // Maintain aspect ratio for image
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent, // Ensures only image is visible
              child: Ink.image(
                image: AssetImage(
                    "assets/images/card1.jpg"), // Replace with relevant image
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    print(
                        "${project.data.projectName} tapped!"); // Handle tap event
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            project.data.projectName,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Location: ${project.data.location}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Area: ${project.data.area}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
