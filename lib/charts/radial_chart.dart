import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/lead_service.dart';
import '../models/lead_model.dart';

class LeadChartWidget extends StatelessWidget {
  final LeadService leadService = LeadService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lead>>(
      future: leadService.fetchLeads(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No leads available.'));
        }

        // Extract data for the chart, with null safety
        List<Lead> leads = snapshot.data!;
        List<ChartData> chartData = leads
            .map((lead) => ChartData(
                  lead.name ?? 'Unnamed', // Provide a fallback if name is null
                  int.tryParse(lead.creditScore) ??
                      0, // Provide fallback if creditScore is null or invalid
                ))
            .toList();

        return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Lead Credit Scores'),
          series: <CartesianSeries<ChartData, String>>[
            BarSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.name,
              yValueMapper: (ChartData data, _) => data.creditScore,
              color: Colors.blue,
            )
          ],
        );
      },
    );
  }
}

class ChartData {
  final String name;
  final int creditScore;

  ChartData(this.name, this.creditScore);
}
