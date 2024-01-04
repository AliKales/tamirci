import 'package:caroby/caroby.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

@immutable
final class PieItem {
  final String title;
  final double value;
  final Color color;

  const PieItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

class CPieChart extends StatefulWidget {
  const CPieChart({
    super.key,
    required this.items,
    this.height,
    this.width,
  });

  final List<PieItem> items;
  final double? height;
  final double? width;

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<CPieChart> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(30),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(Values.radiusLargeXX)),
        ),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.items.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final item = widget.items[i];

      return PieChartSectionData(
        color: item.color,
        value: item.value,
        title: item.title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
      );
    });
  }
}
