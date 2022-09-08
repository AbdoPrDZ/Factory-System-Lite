import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../../models/client.model.dart';
import '../../models/order.model.dart';
import '../../modes/order_status.mode.dart';
import '../../pkgs/route.pkg.dart';
import '../../src/pages_info.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/items/details.item.view.dart';
import '../../views/table.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class ClientPage extends page.Page<ClietnController> {
  ClientPage({Key? key}) : super(ClietnController(), key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Client Details'),
      backgroundColor: UIThemeColors.primary,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    ClientModel client = Get.arguments;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Flex(
          direction: Axis.vertical,
          children: [
            const Gap(20),
            Text(
              'Client Detials #${client.id}',
              style: TextStyle(
                color: UIThemeColors.text1,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            DetialsItemView('Id', client.id),
            DetialsItemView('Client Name', client.fullname),
            DetialsItemView(
              'Client Phone',
              client.phone,
              subWidgets: [
                const Spacer(),
                ButtonView(
                  width: 35,
                  height: 35,
                  onPressed: () {
                    urlLauncher.launch("tel://${client.phone}");
                  },
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Icon(
                    Icons.call,
                    color: UIThemeColors.primary,
                    size: 25,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 265,
              child: StreamTableView.textTitle(
                'Orders:',
                margin: const EdgeInsets.symmetric(vertical: 15),
                modelsStream: OrderModel.stream(),
                columns: [
                  TableColumn(
                    '#',
                    'id',
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
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
                avaliableModels: (model) =>
                    (model as OrderModel).client!.id == client.id,
                onCellTap: (cell, model) {
                  RoutePkg.to(
                    PagesInfo.order,
                    arguments: model as OrderModel,
                  );
                },
              ),
            ),
            ButtonView(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              onPressed: () {
                RoutePkg.to(
                  PagesInfo.addEditClient,
                  arguments: {'action': 'Edit', 'client': client},
                );
              },
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit, size: 20),
                  Gap(5),
                  Text(
                    'Edit Client',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
