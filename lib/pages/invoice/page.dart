import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../../models/invoice.model.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/items/details.item.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class InvoicePage extends page.Page<InvoiceController> {
  InvoicePage({Key? key}) : super(InvoiceController(), key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Invoice Detials'),
      backgroundColor: UIThemeColors.primary,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    InvoiceModel invoice = Get.arguments;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Flex(
          direction: Axis.vertical,
          children: [
            const Gap(20),
            Text(
              'Invoice Detials #${invoice.id}',
              style: TextStyle(
                color: UIThemeColors.text1,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            DetialsItemView('Id', invoice.id.toString()),
            DetialsItemView('Client Name', invoice.order?.client?.fullname),
            DetialsItemView('Order Id', invoice.order?.id),
            DetialsItemView('Cloth Type', invoice.order?.clothType?.name),
            DetialsItemView('Total Weight', invoice.totalWeight),
            DetialsItemView('Units Count', invoice.unitsCount),
            DetialsItemView(
              'Invoiced at',
              DateFormat('yyyy-MM-dd HH:mm').format(invoice.createdAt),
            ),
            DetialsItemView(
              'Invoiced by',
              invoice.invoicedBy?.username,
            ),
            DetialsItemView(
              'Transport Name',
              invoice.transportName,
              subWidgets: [
                const Spacer(),
                ButtonView(
                  width: 35,
                  height: 35,
                  onPressed: () {
                    urlLauncher.launch("tel://${invoice.transportPhone}");
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
            // ButtonView(
            //   margin: const EdgeInsets.symmetric(horizontal: 10),
            //   width: double.infinity,
            //   onPressed: () {},
            //   child: Flex(
            //     direction: Axis.horizontal,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Icon(Icons.edit, size: 20),
            //       Gap(5),
            //       Text(
            //         'Edit Invoice',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
