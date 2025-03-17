import 'package:expences/bar_graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBargraph extends StatefulWidget {
  final List<double> monthlySalary; //[25,300,455]
  final int startMonth; //0 jan,1feb,2march
  const MyBargraph(
      {super.key, required this.monthlySalary, required this.startMonth});

  @override
  State<MyBargraph> createState() => _MyBargraphState();
}

class _MyBargraphState extends State<MyBargraph> {
  //create the list of the data that hold
  List<IndividualBar> barData = [];

  void initState() {
    super.initState();

    //we need scroll to the end
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => scrollToEnd(),
    );
  }

  //Calculate the max value
  double calcualteUpperMax() {
    //initailly set the upper
    double max = 500;

    //get the highest value
    widget.monthlySalary.sort();

    //max value is calculate
    max = widget.monthlySalary.last * 1.05;

    if (max < 500) {
      return 500;
    }
    return max;
  }

  //initialize the data
  void initializeBardata() {
    barData = List.generate(
      widget.monthlySalary.length,
      (index) => IndividualBar(
        x: index,
        y: widget.monthlySalary[index],
      ),
    );
  }

  //scroller controler to the latest month
  final ScrollController _scrollController = ScrollController();
  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    //initalize it
    initializeBardata();

    //bar dimentions sizes
    double barWidth = 20;
    double spaceBetween = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          width:
              barWidth * barData.length + spaceBetween * (barData.length - 1),
          child: BarChart(
            BarChartData(
                minY: 0,
                maxY: calcualteUpperMax(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getTileWidget,
                      reservedSize: 24,
                    ),
                  ),
                ),
                barGroups: barData
                    .map(
                      (data) => BarChartGroupData(x: data.x, barRods: [
                        BarChartRodData(
                            toY: data.y,
                            width: barWidth,
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: calcualteUpperMax(),
                              color: Colors.white,
                            )),
                      ]),
                    )
                    .toList(),
                alignment: BarChartAlignment.center,
                groupsSpace: spaceBetween),
          ),
        ),
      ),
    );
  }
}

// //BOTTOM WIDGET
Widget getTileWidget(double value, TitleMeta meta) {
  TextStyle textStyle = const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = "J";
      break;
    case 1:
      text = "F";
      break;
    case 2:
      text = "M";
      break;
    case 3:
      text = "A";
      break;
    case 4:
      text = "M";
      break;
    case 5:
      text = "J";
      break;
    case 6:
      text = "J";
      break;
    case 7:
      text = "A";
      break;
    case 8:
      text = "S";
      break;
    case 9:
      text = "O";
      break;
    case 10:
      text = "N";
      break;
    case 11:
      text = "D";
      break;
    default:
      text = "";
      break;
  }

  return SideTitleWidget(
    child: Text(
      text,
      style: textStyle,
    ),
    meta: meta,
  );
}
