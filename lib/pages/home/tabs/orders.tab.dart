import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/order.model.dart';
import '../../../modes/order_status.mode.dart';
import '../../../pkgs/route.pkg.dart';
import '../../../src/pages_info.dart';
import '../../../src/theme.dart';
import '../../../views/multi_type_table.view.dart';
import '../../../views/table.view.dart';
import '../controller.dart';

class OrdersTab extends StatelessWidget {
  final HomeController controller;
  const OrdersTab(this.controller, {Key? key}) : super(key: key);

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
                'Cloth type',
                'cloth_type',
                columnWidthMode: ColumnWidthMode.fitByCellValue,
              ),
              TableColumn('Start product', 'start_product'),
              TableColumn('End product', 'end_product'),
              TableColumn('Status', 'status'),
              TableColumn('Units count', 'units'),
              TableColumn('Total weight', 'total_weight'),
            ],
          ),
          TableType(
            value: 'in-progress',
            name: 'In Progress',
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
              TableColumn('Units count', 'units_count'),
              TableColumn('Total weight', 'total_weight'),
            ],
            avaliableModels: (model) =>
                (model as OrderModel).status == OrderStatus.inProgress,
          ),
          TableType(
            value: 'waiting',
            name: 'Waiting',
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
            avaliableModels: (model) =>
                (model as OrderModel).status == OrderStatus.waiting,
          ),
          TableType(
            value: 'ended',
            name: 'Ended',
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
            avaliableModels: (model) =>
                (model as OrderModel).status == OrderStatus.ended,
          ),
        ],
        title: 'Orders ({currentType}):',
        modelsStream: OrderModel.stream(),
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
        onCellTap: (cell, model) {
          RoutePkg.to(PagesInfo.order, arguments: model as OrderModel);
        },
      ),
    );
  }
}
