import 'package:factory_system_lite/models/order.model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../pkgs/route.pkg.dart';
import '../../src/pages_info.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/dropdown.view.dart';
import '../../views/text_edit.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class AddUnitPage extends page.Page<AddUnitController> {
  AddUnitPage({Key? key}) : super(AddUnitController(), key: key);

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
            Text(
              'Add Unit',
              style: TextStyle(
                color: UIThemeColors.text1,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: DropDownView<int>(
                    value: controller.orderId.value,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    items: [
                      const DropdownMenuItem(
                        value: -1,
                        child: Text('Order'),
                      ),
                      for (int index = 0;
                          index < controller.orders.length;
                          index++)
                        DropdownMenuItem(
                          value: controller.orders[index].id,
                          child: Text(
                            "${controller.orders[index].client?.fullname} (${controller.orders[index].clothType?.name})",
                          ),
                        )
                    ],
                    onChanged: (value) {
                      controller.orderId(value);
                      controller.update();
                    },
                    label: 'Oreder',
                  ),
                ),
                ButtonView.text(
                  onPressed: () async {
                    await RoutePkg.to(PagesInfo.addEditOrder);
                    controller.getOrders();
                    controller.update();
                  },
                  text: 'Create',
                  height: 50,
                  margin: const EdgeInsets.only(left: 5, top: 25),
                ),
              ],
            ),
            const Gap(5),
            TextEditView(
              controller: controller.unitWeightController,
              label: 'Weight:',
              margin: const EdgeInsets.symmetric(horizontal: 5),
              entryType: TextInputType.number,
            ),
            const Gap(10),
            Row(
              children: [
                Checkbox(
                  value: controller.isLast.value,
                  side: const BorderSide(color: UIColors.grey),
                  activeColor: UIThemeColors.primary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.isLast.value = value;
                      controller.update();
                    }
                  },
                ),
                Text(
                  'Is last',
                  style: TextStyle(
                    color: UIThemeColors.text2,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            ButtonView.text(
              margin: const EdgeInsets.symmetric(vertical: 10),
              onPressed: controller.addUnit,
              text: 'Add Unit',
            )
          ],
        ),
      ),
    );
  }
}
