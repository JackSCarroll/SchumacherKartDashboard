import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/line_chart_data.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/widgets/custom_card_widget.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({super.key});
  

  @override
  Widget build (BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lineData = LineData(context);
    if(lineData.spots.isNotEmpty) {
      return CustomCard(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12, right: 18),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(
                          handleBuiltInTouches: true
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: settingsProvider.selectedPrimaryColour.withOpacity(0.5),
                              strokeWidth: 0.5,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10000,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                  return lineData.bottomTitle[value] != null
                                  ? SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    angle: 125,
                                    child: Text(
                                      lineData.bottomTitle[value]!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 10, color: settingsProvider.selectedPrimaryColour),
                                    )
                                  ): const SizedBox();
                                }
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return lineData.leftTitle[value] != null
                                  ? Text(
                                    lineData.leftTitle[value].toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12, color: settingsProvider.selectedPrimaryColour),)
                                  : const SizedBox();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            color: settingsProvider.selectedPrimaryColour,
                            barWidth: 2.5,
                            belowBarData: BarAreaData(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [settingsProvider.selectedPrimaryColour.withOpacity(0.5), Colors.transparent],
                              ),
                              show: true,
                            ),
                            dotData: const FlDotData(show: false),
                            spots: lineData.spots,
                          )
                        ],
                        minX: lineData.spots.first.x,
                        maxX: lineData.spots.last.x,
                        minY: -1,
                        maxY: 100,
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}