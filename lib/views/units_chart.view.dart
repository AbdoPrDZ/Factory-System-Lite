import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../modes/display_types.dart';
import '../src/theme.dart';
import '../utils/date_range.dart';

class UnitsChartView extends StatelessWidget {
  final UnitsChartData Function(int orderId, DateTime date) getItems;
  final List<int> ordersIds;
  final DisplayTypes displayType;

  const UnitsChartView({
    Key? key,
    required this.getItems,
    required this.ordersIds,
    this.displayType = DisplayTypes.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0.4,
      title: ChartTitle(
        text: 'Units producted on this ${displayType.mode}',
        textStyle: TextStyle(
          color: UIThemeColors.text2,
        ),
      ),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0.2),
        dateFormat: displayType.isDay
            ? DateFormat.H()
            : displayType.isWeek
                ? DateFormat.E()
                : displayType.isMonth
                    ? DateFormat.d()
                    : DateFormat.M(),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0.2),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _getDefaultSplineSeries(),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.longPress,
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
      ),
    );
  }

  List<SplineSeries<UnitsChartData, DateTime>> _getDefaultSplineSeries() {
    DateRange dateRange;
    Duration delay;
    if (displayType.isDay) {
      dateRange = DateRange.thisDay();
      delay = const Duration(hours: 1);
    } else if (displayType.isWeek) {
      dateRange = DateRange.thisWeek();
      delay = const Duration(days: 1);
    } else if (displayType.isMonth) {
      delay = const Duration(days: 1);
      dateRange = DateRange.thisMonth();
    } else {
      dateRange = DateRange.thisYear();
      delay = const Duration(days: 30);
    }
    return <SplineSeries<UnitsChartData, DateTime>>[
      for (int orderId in ordersIds)
        SplineSeries<UnitsChartData, DateTime>(
          dataSource: [
            for (var i = dateRange.from.millisecondsSinceEpoch;
                i < dateRange.to.millisecondsSinceEpoch;
                i += delay.inMilliseconds)
              getItems(
                orderId,
                DateTime.fromMillisecondsSinceEpoch(i),
              ),
          ],
          xValueMapper: (UnitsChartData sales, _) => sales.date,
          yValueMapper: (UnitsChartData sales, _) => sales.unitsCount,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'Order $orderId',
        )
    ];
  }
}

class UnitsChartData {
  final DateTime date;
  final int unitsCount;

  UnitsChartData({
    required this.date,
    required this.unitsCount,
  });
}
