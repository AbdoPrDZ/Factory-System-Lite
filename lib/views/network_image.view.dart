import 'package:factory_system_lite/services/main.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_explorer/explorer_network_files.dart';

import '../src/theme.dart';

class NetworkImageView extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit = BoxFit.cover;
  final String url;

  const NetworkImageView(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExplorerNetworkImage(
      explorerNetworkFiles:
          Get.find<MainService>().storageDatabase.explorer!.networkFiles!,
      url: url,
      borderRadius: borderRadius,
      fit: fit,
      height: height,
      width: height,
    );
  }
}
