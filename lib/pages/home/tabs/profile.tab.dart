import 'package:factory_system_lite/models/worker.model.dart';
import 'package:factory_system_lite/views/dialogs.view.dart';
import 'package:factory_system_lite/views/network_image.view.dart';
import 'package:factory_system_lite/views/text_edit.view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../pkgs/size_config.pkg.dart';
import '../../../src/theme.dart';
import '../../../views/button.view.dart';
import '../../../views/my_grid.view.dart';
import '../controller.dart';

class ProfileTab extends StatefulWidget {
  final HomeController controller;
  const ProfileTab(this.controller, {Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Positioned.fill(
                    bottom: 75,
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(148, 0, 0, 0),
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: NetworkImageView(
                        widget.controller.authService.currentWorker!
                            .backgroundimgUrl,
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 5,
                    child: CirclerButton.icon(
                      size: 30,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icons.photo_camera_outlined,
                      onPressed: () => widget.controller.editImg('Background'),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    height: 100,
                    width: 100,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: UIThemeColors.pageBackground,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x68000000),
                            blurRadius: 5,
                            offset: Offset(1, 2),
                          )
                        ],
                      ),
                      child: NetworkImageView(
                        widget.controller.authService.currentWorker!
                            .profileImgUrl,
                        width: 100,
                        height: 100,
                        borderRadius: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35,
                    right: MediaQuery.of(context).size.width / 2 - 55,
                    child: CirclerButton.icon(
                      size: 30,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icons.photo_camera_outlined,
                      onPressed: () => widget.controller.editImg('Profile'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.controller.authService.currentWorker!.username,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UIThemeColors.text1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            ButtonView.text(
              onPressed: () {},
              text: 'Edit Profile',
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
      ),
    );
  }
}
