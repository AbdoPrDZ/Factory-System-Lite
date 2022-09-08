import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/text_edit.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class AddEditClientPage extends page.Page<AddEditClientController> {
  AddEditClientPage({Key? key}) : super(AddEditClientController(), key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Add Client'),
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
              '${controller.action.value == 'Edit' ? 'Edit' : 'Create'} Client',
              style: TextStyle(
                color: UIThemeColors.text1,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            TextEditView(
              controller: controller.fullnameController,
              label: 'Fullname',
            ),
            TextEditView(
              controller: controller.phoneController,
              label: 'Phone',
              entryType: TextInputType.phone,
            ),
            ButtonView.text(
              margin: const EdgeInsets.symmetric(vertical: 10),
              onPressed: controller.action.value == 'Edit'
                  ? controller.editClient
                  : controller.addClient,
              text: '${controller.action.value} order',
            )
          ],
        ),
      ),
    );
  }
}
