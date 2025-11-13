import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/group/domain/usecase.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatefulWidget {
  final List<CustomBarChartData> data;
  final int year;
  const MonthlyBarChart({super.key, required this.data, required this.year});

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  final List<bool> isActiveList = List.generate(12, (index) => false);

  List<CustomBarChartData> get sortedData {
    // Tạo bản sao
    final sorted = List<CustomBarChartData>.from(widget.data);

    // Thêm tháng còn thiếu (1–12)
    for (int m = 1; m <= 12; m++) {
      final exists = sorted.any((e) => e.month == m);
      if (!exists) {
        sorted.add(CustomBarChartData(month: m, value: 0));
      }
    }

    // Sắp xếp lại theo tháng
    sorted.sort((a, b) => a.month.compareTo(b.month));

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            intl.year,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            '${widget.year}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppThemes.primary3Color
                ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final label = sortedData[value.toInt()].month;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            label.toString(),
                            style: TextStyle(
                              color: isActiveList[value.toInt()]
                                  ? const Color(0xFFB13346)
                                  : Colors.grey,
                              fontWeight: isActiveList[value.toInt()]
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0, // baseline tại 0
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                  ],
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final value = rod.toY;
                      // Gọi hàm format số (dạng 12.000, 134.000.400)
                      final formatted = formatNumber(value);
                      return BarTooltipItem(
                        formatted,
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      );
                    },
                  ),
                ),
                barGroups: _barGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _barGroups() {
    return List.generate(sortedData.length, (i) {
      final value = sortedData[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (value.value as num).toDouble(),
            borderRadius: BorderRadius.circular(8),
            width: 18,
            color: isActiveList[i] ? AppThemes.primary2Color : AppThemes.primary4Color,
          ),
        ],
        showingTooltipIndicators: isActiveList[i] ? [0] : [],
      );
    });
  }
}