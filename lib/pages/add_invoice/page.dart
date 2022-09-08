import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/order.model.dart';
import '../../models/unit.model.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/multi_type_table.view.dart';
import '../../views/table.view.dart';
import '../../views/text_edit.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class AddInvoicePage extends page.Page<AddInvoiceController> {
  AddInvoicePage({Key? key}) : super(AddInvoiceController(), key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Add Unit'),
      backgroundColor: UIThemeColors.primary,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: MultiTypeTableView(
                margin: const EdgeInsets.symmetric(vertical: 15),
                title: 'Units:',
                types: List.generate(
                  controller.orders.length,
                  (index) => TableType(
                    value: controller.orders[index].id,
                    name:
                        "${controller.orders[index].client!.fullname} (${controller.orders[index].clothType!.name})",
                    columns: [
                      TableColumn(
                        '',
                        'check-box',
                        columnWidthMode: ColumnWidthMode.fitByColumnName,
                      ),
                      TableColumn(
                        '#',
                        'id',
                        columnWidthMode: ColumnWidthMode.auto,
                      ),
                      TableColumn(
                        'Weight',
                        'weight',
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                      ),
                      TableColumn(
                        'Producted by',
                        'producted_by',
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                      ),
                      TableColumn(
                        'Date time',
                        'created_at',
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                      ),
                    ],
                    avaliableModels: (model) =>
                        controller.orders[index].id ==
                        (model as UnitModel).order?.id,
                  ),
                ),
                models: controller.orderUnits,
                onRenderCell: (cell, rowIndex) {
                  if (cell.colName == 'check-box') {
                    return Checkbox(
                      side: const BorderSide(color: UIColors.grey),
                      activeColor: UIThemeColors.primary,
                      value: controller.invoiceUnits
                          .contains(controller.orderUnits[rowIndex]),
                      onChanged: (value) {
                        if (value != null) {
                          if (value) {
                            controller.invoiceUnits.add(
                              controller.orderUnits[rowIndex],
                            );
                          } else {
                            controller.invoiceUnits.remove(
                              controller.orderUnits[rowIndex],
                            );
                          }
                          controller.update();
                        }
                      },
                    );
                  }
                },
                onTypeChange: (type) => controller.orderId.value = type.value,
              ),
            ),
            Text(
              'Units count: ${controller.invoiceUnits.length} unit',
              style: TextStyle(
                color: UIThemeColors.text3,
              ),
            ),
            Text(
              'Units weight: ${controller.totalInvoicedWeight} Kg',
              style: TextStyle(
                color: UIThemeColors.text3,
              ),
            ),
            const Gap(10),
            TextEditView(
              controller: controller.trasportNameController,
              label: 'Transport name:',
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            ),
            TextEditView(
              controller: controller.trasportPhoneController,
              label: 'Transport phone:',
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              entryType: TextInputType.phone,
            ),
            ButtonView.text(
              margin: const EdgeInsets.symmetric(vertical: 10),
              onPressed: controller.addInvoce,
              text: 'Add Invoice',
            )
          ],
        ),
      ),
    );
  }
}
