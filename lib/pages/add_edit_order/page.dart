import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../models/client.model.dart';
import '../../models/order.model.dart';
import '../../pkgs/route.pkg.dart';
import '../../src/pages_info.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/dropdown.view.dart';
import '../../views/items/thread.item.view.dart';
import '../../views/text_edit.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class AddEditOrderPage extends page.Page<AddEditOrderController> {
  AddEditOrderPage({Key? key}) : super(AddEditOrderController(), key: key);

  @override
  void initState() {
    super.initState();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('${controller.action.value} Order'),
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
              '${controller.action.value == 'Edit' ? 'Edit' : 'Create'} Order',
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
                    value: controller.clientId.value,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    items: [
                      const DropdownMenuItem(
                        value: -1,
                        child: Text('Client'),
                      ),
                      for (int index = 0;
                          index < controller.clients.length;
                          index++)
                        DropdownMenuItem(
                          value: controller.clients[index].id,
                          child: Text(controller.clients[index].fullname),
                        )
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.clientId.value = value;
                        controller.update();
                      }
                    },
                    label: 'Client',
                  ),
                ),
                ButtonView.text(
                  onPressed: () async {
                    await RoutePkg.to(PagesInfo.addEditClient);
                    controller.clients.value =
                        await ClientModel.allFromFirebase();
                    controller.update();
                  },
                  text: 'Create',
                  height: 50,
                  margin: const EdgeInsets.only(left: 5, top: 25),
                ),
              ],
            ),
            DropDownView<int>(
              value: controller.clothTypeId.value,
              margin: const EdgeInsets.symmetric(vertical: 5),
              items: [
                const DropdownMenuItem(
                  value: -1,
                  child: Text('Cloth Type'),
                ),
                for (int index = 0;
                    index < controller.clothTypes.length;
                    index++)
                  DropdownMenuItem(
                    value: controller.clothTypes[index].id,
                    child: Text(controller.clothTypes[index].name),
                  )
              ],
              onChanged: (value) {
                if (value != null) controller.clothTypeId.value = value;
                controller.update();
              },
              label: 'Cloth type',
            ),
            const Gap(5),
            Text(
              'Threads:',
              style: TextStyle(
                color: UIThemeColors.text2,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: TextEditView(
                        controller: controller.threadTypeController,
                        hint: 'Type',
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                    Flexible(
                      child: TextEditView(
                        controller: controller.threadColorController,
                        hint: 'Color',
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                    Flexible(
                      child: TextEditView(
                        controller: controller.threadCountController,
                        hint: 'Count',
                        entryType: TextInputType.number,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                    Flexible(
                      child: TextEditView(
                        controller: controller.threadWeightController,
                        hint: 'Weight',
                        entryType: TextInputType.number,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                  ],
                ),
                ButtonView.text(
                  onPressed: controller.addThread,
                  text: 'add',
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ],
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: UIColors.grey,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.builder(
                itemCount: controller.threads.length,
                itemBuilder: (context, index) => ThreadItemView(
                  thread: controller.threads[index],
                  onDelete: controller.onThreadDelete,
                ),
              ),
            ),
            ButtonView.text(
              margin: const EdgeInsets.symmetric(vertical: 10),
              onPressed: controller.action.value == 'Edit'
                  ? controller.editOrder
                  : controller.addOrder,
              text: '${controller.action.value} order',
            )
          ],
        ),
      ),
    );
  }
}
