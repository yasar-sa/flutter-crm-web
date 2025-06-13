import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlotsPage extends StatefulWidget {
  @override
  _PlotsPageState createState() => _PlotsPageState();
}

class _PlotsPageState extends State<PlotsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> plots = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchPlots();
  }

  Future<void> fetchPlots() async {
    final url = Uri.parse('https://real-pro-service.onrender.com/api/plots');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> rawPlots = json.decode(response.body);
        setState(() {
          plots = rawPlots.map((plot) {
            var data = plot['data'];
            return {
              'id': plot['id'],
              'plotNumber': data['plotNumber'],
              'plotName': data['plotName'],
              'facing': getPlotFacing(data),
              'corner': data['plotCorner'],
              'status': data['plotStatus'],
              'phase': plot['phaseId'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load plots');
      }
    } catch (e) {
      print('Error fetching plots: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String getPlotFacing(Map<String, dynamic> data) {
    List<String> facing = [];
    if (data['plotFacingNorth']) facing.add("North");
    if (data['plotFacingSouth']) facing.add("South");
    if (data['plotFacingEast']) facing.add("East");
    if (data['plotFacingWest']) facing.add("West");
    return facing.isNotEmpty ? facing.join(', ') : "N/A";
  }

  void showEditPlotDialog(Map<String, dynamic> plot) {
    showDialog(
      context: context,
      builder: (context) {
        return EditPlotDialog(plot: plot, onPlotUpdated: fetchPlots);
      },
    );
  }

  void showAddPlotDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddPlotDialog(onPlotAdded: fetchPlots);
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Ensure enough height
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          title: Padding(
            padding:
                EdgeInsets.only(top: 8.0), // Pushes content slightly downward
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevents extra height
              children: [
                Text(
                  "Plots",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6), // Adds spacing between text and search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Plots...',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query.toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Phase A'),
              Tab(text: 'Phase B'),
              Tab(text: 'Phase C'),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.blueGrey,
            unselectedLabelColor: Colors.grey,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                PlotList(
                    phase: 'A',
                    plots: plots,
                    searchQuery: searchQuery,
                    showEditDialog: showEditPlotDialog),
                PlotList(
                    phase: 'B',
                    plots: plots,
                    searchQuery: searchQuery,
                    showEditDialog: showEditPlotDialog),
                PlotList(
                    phase: 'C',
                    plots: plots,
                    searchQuery: searchQuery,
                    showEditDialog: showEditPlotDialog),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPlotDialog,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlotList extends StatelessWidget {
  final String phase;
  final List<dynamic> plots;
  final String searchQuery;
  final Function(Map<String, dynamic>) showEditDialog;

  PlotList(
      {required this.phase,
      required this.plots,
      required this.searchQuery,
      required this.showEditDialog});

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredPlots = plots
        .where((plot) =>
            plot['phase'] == phase &&
            (plot['plotName'].toLowerCase().contains(searchQuery) ||
                plot['plotNumber'].toLowerCase().contains(searchQuery)))
        .toList();

    return ListView.builder(
      itemCount: filteredPlots.length,
      itemBuilder: (context, index) {
        var plot = filteredPlots[index];
        return Card(
          child: ListTile(
            title: Text('${plot['plotName']} (Plot No: ${plot['plotNumber']})'),
            subtitle: Text('Status: ${plot['status']}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => showEditDialog(plot),
            ),
          ),
        );
      },
    );
  }
}

class EditPlotDialog extends StatefulWidget {
  final Map<String, dynamic> plot;
  final VoidCallback onPlotUpdated;

  EditPlotDialog({required this.plot, required this.onPlotUpdated});

  @override
  _EditPlotDialogState createState() => _EditPlotDialogState();
}

class _EditPlotDialogState extends State<EditPlotDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String status = '';

  @override
  void initState() {
    super.initState();
    nameController.text = widget.plot['plotName'];
    numberController.text = widget.plot['plotNumber'];
    status = widget.plot['status'];
  }

  Future<void> updatePlot() async {
    final url = Uri.parse(
        'https://real-pro-service.onrender.com/api/plots/${widget.plot['id']}');
    Map<String, dynamic> updatedData = {
      "data": {
        "plotName": nameController.text,
        "plotNumber": numberController.text,
        "plotStatus": status
      }
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );
      if (response.statusCode == 200) {
        widget.onPlotUpdated();
        Navigator.pop(context);
      } else {
        print("Failed to update plot: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Plot"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Plot Name")),
          TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: "Plot Number")),
          TextField(
              controller: TextEditingController(text: status),
              decoration: InputDecoration(labelText: "Status")),
        ],
      ),
      actions: [
        TextButton(
            child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(child: Text("Update"), onPressed: updatePlot),
      ],
    );
  }
}

class AddPlotDialog extends StatefulWidget {
  final VoidCallback onPlotAdded;

  AddPlotDialog({required this.onPlotAdded});

  @override
  _AddPlotDialogState createState() => _AddPlotDialogState();
}

class _AddPlotDialogState extends State<AddPlotDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String phase = 'A';
  String status = 'Available';
  bool isCorner = false;

  Future<void> addPlot() async {
    final url = Uri.parse('https://real-pro-service.onrender.com/api/plots');
    Map<String, dynamic> plotData = {
      "data": {
        "plotName": nameController.text,
        "plotNumber": numberController.text,
        "plotFacingNorth": true,
        "plotFacingSouth": false,
        "plotFacingEast": true,
        "plotFacingWest": false,
        "plotCorner": isCorner,
        "plotStatus": status
      },
      "phaseId": phase
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(plotData),
      );

      if (response.statusCode == 201) {
        widget.onPlotAdded();
        Navigator.pop(context);
      } else {
        print("Failed to add plot: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Plot"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: phase,
            onChanged: (value) => setState(() => phase = value!),
            items: ["A", "B", "C"]
                .map((p) => DropdownMenuItem(value: p, child: Text("Phase $p")))
                .toList(),
          ),
          TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Plot Name")),
          TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: "Plot Number")),
          SwitchListTile(
              title: Text("Corner Plot"),
              value: isCorner,
              onChanged: (value) => setState(() => isCorner = value)),
        ],
      ),
      actions: [
        TextButton(
            child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
        ElevatedButton(child: Text("Add"), onPressed: addPlot)
      ],
    );
  }
}
