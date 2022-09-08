import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/invoice.model.dart';
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

class OrderPage extends page.Page<OrderController> {
  OrderPage({Key? key}) : super(OrderController(), key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Order Details'),
      backgroundColor: UIThemeColors.primary,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    OrderModel order = Get.arguments;
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
        child: Flex(
          direction: Axis.vertical,
          children: [
            const Gap(20),
            Text(
              'Order Detials #${order.id}',
              style: TextStyle(
                color: UIThemeColors.text1,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            DetialsItemView('Id', order.id),
            DetialsItemView('Client Name', order.client?.fullname),
            DetialsItemView('Cloth Type', order.clothType?.name),
            DetialsItemView(
              'Status',
              order.status.mode,
              textColor: order.status == OrderStatus.waiting
                  ? UIColors.warning
                  : order.status == OrderStatus.inProgress
                      ? UIColors.success
                      : UIColors.danger,
            ),
            DetialsItemView(
              'Start Production',
              order.startProduct != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(order.startProduct!)
                  : null,
            ),
            DetialsItemView(
              'End Production',
              order.endProduct != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(order.endProduct!)
                  : null,
            ),
            DetialsItemView('Total Weight', order.totalWeight),
            DetialsItemView('Units Count', order.unitsCount),
            SizedBox(
              height: 250,
              child: StreamTableView.textTitle(
                'Invoices',
                margin: const EdgeInsets.symmetric(vertical: 15),
                modelsStream: InvoiceModel.stream(),
                columns: [
                  TableColumn(
                    '#',
                    'id',
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
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
                cellSetting: CellSetting(
                  dateTime: DateTimeRnderData.date(),
                ),
                avaliableModels: (model) =>
                    (model as InvoiceModel).order!.id == order.id,
                onCellTap: (cell, model) {
                  RoutePkg.to(
                    PagesInfo.invoice,
                    arguments: model as InvoiceModel,
                  );
                },
              ),
            ),
            ButtonView(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              onPressed: () {
                RoutePkg.to(
                  PagesInfo.addEditOrder,
                  arguments: {'action': 'Edit', 'order': order},
                );
              },
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit, size: 20),
                  Gap(5),
                  Text(
                    'Edit Order',
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
