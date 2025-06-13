import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> get allSpots => const [
        FlSpot(0, 20),
        FlSpot(1, 30),
        FlSpot(2, 40),
        FlSpot(3, 50),
        FlSpot(4, 35),
        FlSpot(5, 40),
        FlSpot(6, 30),
        FlSpot(7, 20),
        FlSpot(8, 25),
        FlSpot(9, 40),
        FlSpot(10, 50),
        FlSpot(11, 35),
        FlSpot(12, 50),
        FlSpot(13, 40),
        FlSpot(14, 50),
        FlSpot(15, 60),
        FlSpot(16, 20),
        FlSpot(17, 40),
        FlSpot(18, 50),
        FlSpot(19, 20),
        FlSpot(20, 25),
        FlSpot(21, 80),
        FlSpot(22, 30),
        FlSpot(23, 25),
        FlSpot(24, 40),
        FlSpot(25, 80),
      ];
  List<int> showingTooltipOnSpots = [21];

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            const Color(0xff9dceff).withOpacity(0.4),
            const Color(0xff9da3fd).withOpacity(0.4),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: const LinearGradient(
          colors: [Color(0xff9dceff), Color(0xff92a3fd)],
        ),
      ),
    ];

    return Card(
      color: Colors.grey,
      surfaceTintColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Lead Generation Trends",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("250 LEADS",
                  style: GoogleFonts.poppins(
                      fontSize: 27, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("Last 30 days +12%",
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300, // Set a fixed height for the chart
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    lineBarsData: lineBarsData,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
