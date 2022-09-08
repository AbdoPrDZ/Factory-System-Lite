import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../pkgs/route.pkg.dart';
import '../../src/assets.dart';
import '../../src/consts.dart';
import '../../src/pages_info.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class StartPage extends page.Page<StartController> {
  StartPage({Key? key}) : super(StartController(), key: key);

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          SvgPicture.asset(
            Assets.logo,
            width: 100,
            height: 100,
            color: UIThemeColors.text1,
          ),
          const Gap(10),
          Text(
            Consts.appName,
            style: TextStyle(
              color: UIThemeColors.text1,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(40),
          ButtonView.text(
            onPressed: () {
              RoutePkg.to(PagesInfo.signup);
            },
            text: 'Signup',
          ),
          ButtonView.text(
            onPressed: () {
              RoutePkg.to(PagesInfo.login);
            },
            text: 'Login',
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
