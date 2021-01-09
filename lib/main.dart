import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DiceCountBarChart(),
        ),
      ),
    );
  }
}

class DiceCountBarChart extends StatefulWidget {
  const DiceCountBarChart({
    Key key,
  }) : super(key: key);

  @override
  _DiceCountBarChartState createState() => _DiceCountBarChartState();
}

class _DiceCountBarChartState extends State<DiceCountBarChart> {
  final Color barColor = Colors.indigo;
  final Color barTouchColor = Colors.amber;
  final Color tooltipBgColor = Colors.blueGrey;
  final double width = 7;

  List<BarChartGroupData> barGroups;
  int touchedIndex;

  //test data
  List<BarChartGroupData> testBarGroups;
  Map testMap = {
    '1-1': 5,
    '1-2': 16,
    '1-3': 18,
    '1-4': 20,
    '1-5': 17,
    '1-6': 19,
    '2-2': 16,
    '2-3': 18,
    '2-4': 20,
    '2-5': 17,
    '2-6': 19,
    '3-3': 18,
    '3-4': 20,
    '3-5': 17,
    '3-6': 19,
    '4-4': 20,
    '4-5': 17,
    '4-6': 19,
    '5-5': 17,
    '5-6': 19,
    '6-6': 19,
  };

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 300,
        minWidth: 760,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 96.0, horizontal: 16.0),
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String dicePair;
                    switch (group.x.toInt()) {
                      case 0:
                        dicePair = '1 and 1';
                        break;
                      case 1:
                        dicePair = '1 and 2';
                        break;
                      case 2:
                        dicePair = '1 and 3';
                        break;
                      case 3:
                        dicePair = '1 and 4';
                        break;
                      case 4:
                        dicePair = '1 and 5';
                        break;
                      case 5:
                        dicePair = '1 and 6';
                        break;
                      case 6:
                        dicePair = '2 and 2';
                        break;
                      case 7:
                        dicePair = '2 and 3';
                        break;
                      case 8:
                        dicePair = '2 and 4';
                        break;
                      case 9:
                        dicePair = '2 and 5';
                        break;
                      case 10:
                        dicePair = '2 and 6';
                        break;
                      case 11:
                        dicePair = '3 and 3';
                        break;
                      case 12:
                        dicePair = '3 and 4';
                        break;
                      case 13:
                        dicePair = '3 and 5';
                        break;
                      case 14:
                        dicePair = '3 and 6';
                        break;
                      case 15:
                        dicePair = '4 and 4';
                        break;
                      case 16:
                        dicePair = '4 and 5';
                        break;
                      case 17:
                        dicePair = '4 and 6';
                        break;
                      case 18:
                        dicePair = '5 and 5';
                        break;
                      case 19:
                        dicePair = '5 and 6';
                        break;
                      case 20:
                        dicePair = '6 and 6';
                        break;
                    }
                    return BarTooltipItem(
                        dicePair + '\n' + (rod.y - 1).toString(),
                        TextStyle(color: Colors.amber));
                  }),
              touchCallback: (barTouchResponse) {
                setState(() {
                  if (barTouchResponse.spot != null &&
                      barTouchResponse.touchInput is! FlPanEnd &&
                      barTouchResponse.touchInput is! FlLongPressEnd) {
                    touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 10,
                rotateAngle: 45,
                getTitles: (double value) {
                  return getTitle(value.toInt());
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 32,
                reservedSize: 14,
                getTitles: (value) {
                  if (value == 0) {
                    return '0';
                  } else if (value == 10) {
                    return '10';
                  } else if (value == 50) {
                    return '50';
                  } else {
                    return '';
                  }
                },
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: showingGroups(testMap),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 7,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [barTouchColor] : [barColor],
          width: width,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  int getAxisNumber(String pair) {
    switch (pair) {
      case '1-1':
        return 0;
      case '1-2':
        return 1;
      case '1-3':
        return 2;
      case '1-4':
        return 3;
      case '1-5':
        return 4;
      case '1-6':
        return 5;
      case '2-2':
        return 6;
      case '2-3':
        return 7;
      case '2-4':
        return 8;
      case '2-5':
        return 9;
      case '2-6':
        return 10;
      case '3-3':
        return 11;
      case '3-4':
        return 12;
      case '3-5':
        return 13;
      case '3-6':
        return 14;
      case '4-4':
        return 15;
      case '4-5':
        return 16;
      case '4-6':
        return 17;
      case '5-5':
        return 18;
      case '5-6':
        return 19;
      case '6-6':
        return 20;
      default:
        return -1;
    }
  }

  String getTitle(int axis) {
    switch (axis) {
      case 0:
        return '1&1';
      case 1:
        return '1&2';
      case 2:
        return '1&3';
      case 3:
        return '1&4';
      case 4:
        return '1&5';
      case 5:
        return '1&6';
      case 6:
        return '2&2';
      case 7:
        return '2&3';
      case 8:
        return '2&4';
      case 9:
        return '2&5';
      case 10:
        return '2&6';
      case 11:
        return '3&3';
      case 12:
        return '3&4';
      case 13:
        return '3&5';
      case 14:
        return '3&6';
      case 15:
        return '4&4';
      case 16:
        return '4&5';
      case 17:
        return '4&6';
      case 18:
        return '5&5';
      case 19:
        return '5&6';
      case 20:
        return '6&6';
      default:
        return null;
    }
  }

  List<BarChartGroupData> showingGroups(Map map) =>
      List.generate(map.length, (i) {
        return makeGroupData(getAxisNumber(map.keys.toList()[i]),
            map[map.keys.toList()[i]].toDouble(),
            isTouched: i == touchedIndex);
      });
}
