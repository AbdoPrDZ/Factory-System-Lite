import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/unit.model.dart';
import '../../../src/theme.dart';
import '../../../utils/date_range.dart';
import '../../../views/multi_type_table.view.dart';
import '../../../views/table.view.dart';
import '../controller.dart';

class UnitsTab extends StatelessWidget {
  final HomeController controller;
  const UnitsTab(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: MultiTypeStreamTableView(
        types: [
          TableType(
            value: 'all',
            name: 'All',
            columns: [
              TableColumn(
                '#',
                'id',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn(
                'Client',
                'client',
                columnWidthMode: ColumnWidthMode.auto,
              ),
              TableColumn(
                'Producted by',
                'producted_by',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Weight', 'weight'),
              TableColumn(
                'Date time',
                'created_at',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
            ],
          ),
          TableType(
            value: 'today',
            name: 'Today',
            cellSetting: CellSetting(
              dateTime: DateTimeRnderData.time(),
            ),
            columns: [
              TableColumn(
                '#',
                'id',
                columnWidthMode: ColumnWidthMode.auto,
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
              TableColumn(
                'Date time',
                'created_at',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
            ],
            avaliableModels: (model) {
              model = model as UnitModel;
              var currentDate = DateTime.now();
              return model.createdAt.year == currentDate.year &&
                  model.createdAt.month == currentDate.month &&
                  model.createdAt.day == currentDate.day;
            },
          ),
          TableType(
            value: 'this-week',
            name: 'Week',
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
            ],
            avaliableModels: (model) {
              model = model as UnitModel;
              var thisWeek = DateRange.thisWeek();
              return model.createdAt.millisecondsSinceEpoch >=
                      thisWeek.from.millisecondsSinceEpoch &&
                  model.createdAt.millisecondsSinceEpoch <=
                      thisWeek.to.millisecondsSinceEpoch;
            },
          ),
          TableType(
            value: 'this-month',
            name: 'This month',
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
            ],
            avaliableModels: (model) {
              model = model as UnitModel;
              var currentDate = DateTime.now();
              return model.createdAt.year == currentDate.year &&
                  model.createdAt.month == currentDate.month;
            },
          ),
          TableType(
            value: 'this-year',
            name: 'This year',
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
            ],
            avaliableModels: (model) =>
                (model as UnitModel).createdAt.year == DateTime.now().year,
          ),
        ],
        modelsStream: UnitModel.stream(),
        title: 'Units ({currentType}):',
        onRenderCell: (cell, rowIndex) {
          if (cell.colName == 'status') {
            return Text(
              cell.value,
              style: TextStyle(
                color: cell.value == 'Waiting'
                    ? UIColors.warning
                    : cell.value == 'Ended'
                        ? UIColors.danger
                        : UIColors.success,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            );
          }
          return null;
        },
      ),
    );
  }
}
