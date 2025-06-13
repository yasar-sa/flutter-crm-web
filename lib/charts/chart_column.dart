import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/project_analytics_model.dart';
import '../services/project_service.dart';

class ChartColumn extends StatefulWidget {
  const ChartColumn({super.key});

  @override
  State<ChartColumn> createState() => _ChartColumnState();
}

class _ChartColumnState extends State<ChartColumn> {
  String selectedChips = 'Dec';
  List<String> chips = ['Nov', 'Dec', 'Jan', 'Feb'];
  List<ProjectAnalytics> projectList = [];
  List<ChartColumnData> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final data = await ProjectService.fetchProjectAnalytics();

    List<ChartColumnData> temp = data.map((project) {
      return ChartColumnData(
        project.data.projectName,
        double.tryParse(project.data.area.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0.0,
      );
    }).toList();

    setState(() {
      projectList = data;
      chartData = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      surfaceTintColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                SizedBox(width: 10),
                Text(
                  "Project Area (Sq Ft)",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Text("Projects: ${projectList.length}",
                    style: GoogleFonts.poppins(
                        fontSize: 27, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10.0),
            FittedBox(
              child: Wrap(
                spacing: 10,
                children: chips.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    labelStyle: const TextStyle(color: Colors.black),
                    selectedColor: Colors.grey.shade200,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    selected: selectedChips.contains(category),
                    side: const BorderSide(width: 0, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) selectedChips = category;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SfCartesianChart(
              margin: const EdgeInsets.symmetric(vertical: 15),
              borderWidth: 0,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                isVisible: true,
                title: AxisTitle(text: 'Project Name'),
                labelRotation: 45,
              ),
              primaryYAxis: NumericAxis(
                isVisible: true,
                title: AxisTitle(text: 'Area (Sq Ft)'),
                minimum: 0,
                interval: 1000,
              ),
              series: <CartesianSeries>[
                ColumnSeries<ChartColumnData, String>(
                  dataSource: chartData,
                  width: 0.5,
                  color: Colors.amberAccent,
                  xValueMapper: (ChartColumnData data, _) => data.x,
                  yValueMapper: (ChartColumnData data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartColumnData {
  ChartColumnData(this.x, this.y);
  final String x;
  final double y;
}
