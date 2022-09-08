import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/client.model.dart';
import '../../../models/order.model.dart';
import '../../../pkgs/route.pkg.dart';
import '../../../src/pages_info.dart';
import '../../../src/theme.dart';
import '../../../views/table.view.dart';
import '../controller.dart';

class ClientsTab extends StatelessWidget {
  final HomeController controller;
  const ClientsTab(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: StreamTableView.textTitle(
        'Clients:',
        columns: [
          TableColumn(
            '#',
            'id',
            columnWidthMode: ColumnWidthMode.fitByColumnName,
          ),
          TableColumn(
            'Fullname',
            'fullname',
            columnWidthMode: ColumnWidthMode.fitByCellValue,
          ),
          TableColumn(
            'phone',
            'phone',
            columnWidthMode: ColumnWidthMode.fitByCellValue,
          ),
        ],
        modelsStream: ClientModel.stream(),
        cellSetting: CellSetting(
          dateTime: DateTimeRnderData.date(),
        ),
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
          RoutePkg.to(PagesInfo.client, arguments: model as ClientModel);
        },
      ),
    );
  }
}
