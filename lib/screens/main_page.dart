import 'package:flutter/material.dart';
import 'package:flutter_crm/charts/chart_column.dart';
import 'package:flutter_crm/charts/line_chart.dart';
import 'package:flutter_crm/charts/radial_chart.dart';
import 'package:flutter_crm/screens/customer/customers.dart';
import 'package:flutter_crm/screens/leads/leads_gen.dart';
import 'package:flutter_crm/screens/plots/plots.dart';
import 'package:flutter_crm/screens/project/project_cards.dart';
import 'package:flutter_crm/screens/project/projects.dart';
import 'package:flutter_crm/settings/settings_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _screens = [
    MainPageContent(),
    CustomerInformationPage(),
    ProjectsPage(),
    PlotsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Light background color
      appBar: _selectedIndex == 0
          ? AppBar(
              elevation: 0,
              title: Text(
                'admin',
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu),
                color: Colors.white,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications),
                  color: Colors.white,
                ),
              ],
              backgroundColor: const Color(0xFF2C3E50), // Darker app bar color
              titleSpacing: 20.0,
            )
          : null,

      // Update the body to show selected screen
      body: _screens[_selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            label: "Customer",
            selectedIcon: Icon(Icons.person),
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            label: "Projects",
            selectedIcon: Icon(Icons.book),
          ),
          NavigationDestination(
            icon: Icon(Icons.location_city_rounded),
            label: "Plots",
            selectedIcon: Icon(Icons.location_city),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
            selectedIcon: Icon(Icons.settings),
          ),
        ],
        backgroundColor: const Color(0xFFF4F6F9),
      ),
    );
  }
}

// Separate the main page content so it can be navigated properly
class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Radial Chart Section
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 20),
            child: Text(
              'Plot Summary',
              style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          //chart for lead which should be resolved later
          // Card(
          //   elevation: 5,
          //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(15),
          //   ),
          //   child: LeadChartWidget(),
          // ),

          // Chart Column Section
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const ChartColumn(),
          ),

          // Lead Generation Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: SizedBox(
                width: 350,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Leads()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70),
                    ),
                  ),
                  child: Text(
                    "Lead Generation",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 7),

          // Line Chart Section
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const LineChartWidget(),
          ),

          // Projects Section
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 20),
            child: Text(
              'Projects',
              style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const ProjectCards(),
        ],
      ),
    );
  }
}
