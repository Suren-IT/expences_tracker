import 'package:expences/bar_graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBargraph extends StatefulWidget {
  final List<double> monthlySalary; //[25,300,455]
  final int satrtMonth; //0 jan,1feb,2march
  const MyBargraph(
      {super.key, required this.monthlySalary, required this.satrtMonth});

  @override
  State<MyBargraph> createState() => _MyBargraphState();
}

class _MyBargraphState extends State<MyBargraph> {
  //create the list of the data that hold
  List<IndividualBar> bardata = [];

  //initialize the data
  void initializeBardata() {
    bardata = List.generate(
      widget.monthlySalary.length,
      (index) => IndividualBar(x: index, y: widget.monthlySalary[index],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,    
      ),
    );
  }
}
