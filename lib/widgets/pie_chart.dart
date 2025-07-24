import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/models/pie_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensePieChart extends StatelessWidget {
  final List<PieChartModel> data;

  const ExpensePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double total = data.fold(0, (sum, item) => sum + item.totalAmount);
    return SfCircularChart(
      // backgroundColor: Colors.red,
      margin: EdgeInsets.all(0),
      palette: [
        Color(0xffF5EFFF),
        Color(0xffE5D9F2),
        Color(0xffCDC1FF),
        Color(0xffA294F9),

        // Color(0xff7A1CAC),
        Color(0xffAD49E1),
        Color(0xffEBD3F8),

        // // // Color(0xFFFFDFD6), // deep purple (matches your "My Expenses" card)
        Color(0xFFE3A5C7), // medium purple (used in circle decoration)
        Color(0xFFB692C2), // lavender tint (subtle accent)
        Color(0xFF694F8E), // soft lilac (for light categories)
        // Color(0xFFFDEEDC), // very light cream (neutral background match)
        // Color(0xFFB5A4C7), // grey-purple blend (good for inactive slices)
        // Color(0xFFFFC3A0), // pastel peach (a warmer accent)
      ],
      title: ChartTitle(text: ''), // إزالة العنوان إذا ما بدك ياه

      legend: Legend(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.left,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <PieSeries<PieChartModel, String>>[
        PieSeries<PieChartModel, String>(
          radius: '90%',
          explode: true,
          dataSource: data,
          xValueMapper: (PieChartModel data, _) => data.categoryName,
          yValueMapper: (PieChartModel data, _) => data.totalAmount,
          dataLabelMapper: (PieChartModel data, _) {
            final formatter =
                NumberFormat.decimalPattern(); // Uses current locale
            final formattedAmount = formatter.format(data.totalAmount);
            final percent = ((data.totalAmount / total) * 100).toStringAsFixed(
              1,
            );
            return '$formattedAmount (\u202A$percent%\u202C)';
          },

          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          enableTooltip: true,
        ),
      ],
    );
  }
}
