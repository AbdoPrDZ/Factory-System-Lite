import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../src/assets.dart';
import '../../src/theme.dart';
import '../page.dart' as page;
import 'controller.dart';

class LoadingPage extends page.Page<LoadingController> {
  LoadingPage({Key? key}) : super(LoadingController(), key: key);

  @override
  Widget buildBody(BuildContext context) {
    controller.loading();
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        SvgPicture.asset(
          Assets.logo,
          color: UIThemeColors.text1,
          width: 130,
          height: 130,
        ),
        const Gap(10),
        Text(
          'Factory System',
          style: TextStyle(color: UIThemeColors.text1, fontSize: 24),
        ),
        const Gap(20),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CircularProgressIndicator(
            color: UIThemeColors.primary,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
