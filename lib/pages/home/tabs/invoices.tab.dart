import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/invoice.model.dart';
import '../../../pkgs/route.pkg.dart';
import '../../../src/pages_info.dart';
import '../../../src/theme.dart';
import '../../../utils/date_range.dart';
import '../../../views/multi_type_table.view.dart';
import '../../../views/table.view.dart';
import '../controller.dart';

class InvoicesTab extends StatelessWidget {
  final HomeController controller;
  const InvoicesTab(this.controller, {Key? key}) : super(key: key);

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
                columnWidthMode: ColumnWidthMode.fitByColumnName,
              ),
              TableColumn(
                'Client',
                'client',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn(
                'Invoiced by',
                'invoiced_by',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Total weight', 'total_weight'),
              TableColumn('Units count', 'units_count'),
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
                'Invoiced by',
                'invoiced_by',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Total weight', 'total_weight'),
              TableColumn('Units count', 'units_count'),
            ],
            avaliableModels: (model) {
              model = model as InvoiceModel;
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
                'Invoiced by',
                'invoiced_by',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Total weight', 'total_weight'),
              TableColumn('Units count', 'units_count'),
            ],
            avaliableModels: (model) {
              model = model as InvoiceModel;
              var thisWeek = DateRange.thisWeek();
              return model.createdAt.millisecondsSinceEpoch <=
                      thisWeek.from.millisecondsSinceEpoch &&
                  model.createdAt.millisecondsSinceEpoch >=
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
                'Invoiced by',
                'invoiced_by',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Total weight', 'total_weight'),
              TableColumn('Units count', 'units_count'),
            ],
            avaliableModels: (model) {
              model = model as InvoiceModel;
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
                'Invoiced by',
                'invoiced_by',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Total weight', 'total_weight'),
              TableColumn('Units count', 'units_count'),
            ],
            avaliableModels: (model) =>
                (model as InvoiceModel).createdAt.year == DateTime.now().year,
          ),
        ],
        modelsStream: InvoiceModel.stream(),
        title: 'Invoices ({currentType}):',
        onCellTap: (cell, model) {
          RoutePkg.to(PagesInfo.invoice, arguments: model as InvoiceModel);
        },
      ),
    );
  }
}
