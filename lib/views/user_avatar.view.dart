import 'package:flutter/material.dart';

import '../models/worker.model.dart';
import '../src/theme.dart';

class UserAvatarView extends StatelessWidget {
  final String workerImgUrl;
  final bool isOnline, isGroup;
  final double size;
  final EdgeInsets margin;
  const UserAvatarView({
    required this.workerImgUrl,
    this.isOnline = true,
    this.isGroup = false,
    this.size = 65,
    this.margin = const EdgeInsets.symmetric(vertical: 5),
    Key? key,
  }) : super(key: key);

  factory UserAvatarView.worker(
    WorkerModel worker, {
    bool isOnline = true,
    double size = 65,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
  }) {
    return UserAvatarView(
      workerImgUrl: worker.profileImgUrl,
      isOnline: isOnline,
      isGroup: false,
      size: size,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SizedBox(
        width: size + 5,
        child: Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: UIColors.grey,
                border: Border.all(color: UIColors.grey, width: 2),
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: NetworkImage(workerImgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isGroup)
              Positioned(
                right: 0,
                child: Container(
                  width: size * 0.4,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    color: UIColors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.group,
                    color: UIThemeColors.pageBackground,
                    size: 12,
                  ),
                ),
              ),
            if (isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: size * 0.4,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    color: UIColors.success,
                    border: Border.all(
                        color: UIThemeColors.pageBackground, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
