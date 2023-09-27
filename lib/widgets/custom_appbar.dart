import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constant/theme.dart';

enum AppbarType { home, page }

class CustomAppBar extends StatelessWidget {
  AppbarType? appbarType;
  VoidCallback? onLeadingPressed;
  IconButton? trailingButton;
  IconButton? leadingButton;
  String title;

  CustomAppBar({
    this.appbarType,
    this.trailingButton,
    this.onLeadingPressed,
    this.leadingButton,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: appbarType == AppbarType.home
          ? IconButton(
              onPressed: onLeadingPressed,
              icon: SvgPicture.asset(
                "assets/images/menu.svg",
                color: kSecondaryColor,
              ))
          : IconButton(
              onPressed: (() => Get.back()),
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
      backgroundColor: kPrimaryColor,
      title: Text(
        title,
        style: txt16,
      ),
    );
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     const SizedBox(
    //       height: 24,
    //     ),
    //     ListTile(
    //       tileColor: Colors.white,
    //       leading: leadingButton ??
    //           IconButton(
    //               onPressed: onLeadingPressed ?? Get.back,
    //               icon: const Icon(
    //                 Icons.chevron_left,
    //                 color: Colors.black,
    //               )),
    //       title: Text(
    //         title,
    //         style: defaultBold,
    //       ),
    //       trailing: trailingButton,
    //     ),
    //   ],
    // );
  }
}
