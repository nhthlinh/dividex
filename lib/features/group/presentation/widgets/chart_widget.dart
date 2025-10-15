import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ContributionPieChart extends StatefulWidget {
  final List<ChartData> chartData;
  const ContributionPieChart({super.key, required this.chartData});

  @override
  State<ContributionPieChart> createState() => _ContributionPieChartState();
}

class _ContributionPieChartState extends State<ContributionPieChart> {
  int? touchedIndex;
  late List<ChartData> datas;

  Color getColorByPercent(double percent) {
    // Giới hạn trong khoảng 0–100
    percent = percent.clamp(0, 100);
    // Càng cao thì alpha càng lớn (đậm hơn)
    final alpha = (100 + percent * 1.55).toInt().clamp(100, 255);
    return Color.fromARGB(alpha, 220, 0, 0); // đỏ cơ bản
  }

  @override
  Widget build(BuildContext context) {

    if (widget.chartData.isEmpty) {
      return SizedBox.shrink();
    }

    datas = widget.chartData.isNotEmpty
        ? widget.chartData
        : [ChartData(fullName: '', value: 1)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      touchedIndex = null;
                      return;
                    }
                    touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: _showingSections(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(datas.length, (i) {
      final data = datas[i];
      final isTouched = i == touchedIndex;

      return PieChartSectionData(
        color: getColorByPercent(data.value),
        value: data.value,
        radius: 110,
        title: isTouched ? '${data.fullName}\n${data.value.toStringAsFixed(0)}%' : '',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
        titlePositionPercentageOffset: 1.4, // label nằm ngoài
        badgeWidget: isTouched
            ? _BadgeWidget(
                name: data.fullName,
                percent: data.value,
                color: getColorByPercent(data.value),
              )
            : null,
        badgePositionPercentageOffset: 1.4,
      );
    });
  }
}

class _BadgeWidget extends StatelessWidget {
  final String name;
  final double percent;
  final Color color;

  const _BadgeWidget({
    required this.name,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$name\n${percent.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.1,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
