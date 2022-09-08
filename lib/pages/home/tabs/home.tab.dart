import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/order.model.dart';
import '../../../models/unit.model.dart';
import '../../../models/worker_status.model.dart';
import '../../../modes/display_types.dart';
import '../../../modes/order_status.mode.dart';
import '../../../pkgs/route.pkg.dart';
import '../../../src/pages_info.dart';
import '../../../src/theme.dart';
import '../../../views/dropdown.view.dart';
import '../../../views/table.view.dart';
import '../../../views/units_chart.view.dart';
import '../controller.dart';

class HomeTab extends StatefulWidget {
  final HomeController controller;

  const HomeTab(this.controller, {Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<DisplayTypes> unitsDisplayTypes = [
    DisplayTypes.day,
    DisplayTypes.week,
    DisplayTypes.month,
    DisplayTypes.year,
  ];
  int unitsDisplayTypeIndex = 0;

  bool compareUnitDateWithDate(UnitModel unit, DateTime date) {
    if (unitsDisplayTypes[unitsDisplayTypeIndex].isDay) {
      return unit.createdAt.year == date.year &&
          unit.createdAt.month == date.month &&
          unit.createdAt.day == date.day &&
          unit.createdAt.hour == date.hour;
    } else if (unitsDisplayTypes[unitsDisplayTypeIndex].isWeek ||
        unitsDisplayTypes[unitsDisplayTypeIndex].isMonth) {
      return unit.createdAt.year == date.year &&
          unit.createdAt.month == date.month &&
          unit.createdAt.day == date.day;
    } else if (unitsDisplayTypes[unitsDisplayTypeIndex].isYear) {
      return unit.createdAt.year == date.year &&
          unit.createdAt.month == date.month;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick units details graph:',
                  style: TextStyle(
                    color: UIThemeColors.text2,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Flexible(
                  child: DropDownView<int>(
                    value: unitsDisplayTypeIndex,
                    items: List.generate(
                      unitsDisplayTypes.length,
                      (index) => DropdownMenuItem(
                        value: index,
                        child: Text(unitsDisplayTypes[index].mode),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          unitsDisplayTypeIndex = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            // UnitsChartView(
            //   getItems: (orderId, date) => UnitsChartData(
            //     date: date,
            //     unitsCount: [
            //       for (UnitModel unit in orders[orderId]!.units)
            //         if (compareUnitDateWithDate(unit, date)) unit
            //     ].length,
            //   ),
            //   ordersIds: orders.keys.toList(),
            //   displayType: unitsDisplayTypes[unitsDisplayTypeIndex],
            // ),
            const Gap(15),
            SizedBox(
              height: 235,
              child: StreamTableView.textTitle(
                'Workers status:',
                columns: [
                  TableColumn(
                    'Fullname',
                    'fullname',
                    columnWidthMode: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? ColumnWidthMode.fill
                        : ColumnWidthMode.fitByCellValue,
                  ),
                  TableColumn('Enter time', 'enter_time'),
                  TableColumn('End time', 'end_time'),
                  TableColumn('Pre/Abs', 'is_present'),
                  TableColumn('Hour count', 'hour_count'),
                  TableColumn('Units count', 'units_count'),
                ],
                modelsStream: WorkerStatus.stream(),
                cellSetting: CellSetting(dateTime: DateTimeRnderData.time()),
                onRenderCell: (cell, rowIndex) {
                  if (cell.colName == 'is_present') {
                    return Text(
                      cell.value ? 'Present' : 'Absent',
                      style: TextStyle(
                        color: cell.value ? UIColors.success : UIColors.danger,
                        fontSize: 16,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 265,
              child: StreamTableView.textTitle(
                'Today units:',
                margin: const EdgeInsets.symmetric(vertical: 15),
                modelsStream: UnitModel.stream(),
                columns: [
                  TableColumn(
                    '#',
                    'id',
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
                  ),
                  TableColumn(
                    'Client',
                    'client',
                    columnWidthMode: ColumnWidthMode.fitByCellValue,
                  ),
                  TableColumn(
                    'Producted by',
                    'producted_by',
                    columnWidthMode: ColumnWidthMode.fitByCellValue,
                  ),
                  TableColumn('Weight', 'weight'),
                  TableColumn('Producted at', 'created_at'),
                ],
                cellSetting: CellSetting(
                  dateTime: DateTimeRnderData.time(),
                ),
                avaliableModels: (model) {
                  model = model as UnitModel;
                  var currentDate = DateTime.now();
                  return model.createdAt.year == currentDate.year &&
                      model.createdAt.month == currentDate.month &&
                      model.createdAt.day == currentDate.day;
                },
              ),
            ),
            SizedBox(
                height: 265,
                child: StreamTableView.textTitle(
                  'In progress orders:',
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  modelsStream: OrderModel.stream(),
                  columns: [
                    TableColumn(
                      '#',
                      'id',
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                    ),
                    TableColumn(
                      'Client',
                      'client',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                    ),
                    TableColumn(
                      'Cloth type',
                      'cloth_type',
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                    ),
                    TableColumn('Start product', 'start_product'),
                    TableColumn('End product', 'end_product'),
                    TableColumn('Units count', 'units'),
                    TableColumn('Total weight', 'total_weight'),
                  ],
                  cellSetting: CellSetting(
                    dateTime: DateTimeRnderData.date(),
                  ),
                  avaliableModels: (model) =>
                      (model as OrderModel).status == OrderStatus.inProgress,
                  onCellTap: (cell, model) {
                    RoutePkg.to(
                      PagesInfo.order,
                      arguments: model as OrderModel,
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
