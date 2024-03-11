import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/tab_view_controller.dart';

class TabViewView extends BaseView<TabViewController> {
  const TabViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.backgroundWhite,
        bottomNavigationBar: _bottomNav(context),
        body: Obx(() => controller.body.elementAt(controller.selectedIndex.value)));
  }

  Container _bottomNav(BuildContext context) {
    return Container(
      // color: Colors.grey[200],
      decoration: BoxDecoration(
          color: ColorsManager.backgroundContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: EdgeInsets.symmetric(vertical: UtilsReponsive.height(10, context), horizontal: UtilsReponsive.height(10, context)),
      child: Obx(
        () => GNav(
            gap: 15,
            padding: EdgeInsets.all(UtilsReponsive.width(10, context)),
            activeColor: ColorsManager.primary,
            iconSize: 24,
            tabBackgroundColor: ColorsManager.colorBottomNav, // selected tab background color
            tabs: [
              GButton(
                  icon: Icons.home,
                  text: 'Trang chủ',
                  iconColor: ColorsManager.primary,
                  onPressed: () {
                    controller.onTapped(0);
                  }),
              // GButton(
              //     icon: Icons.check_circle_outline,
              //     text: 'Chấm công',
              //     iconColor: ColorsManager.primary,
              //     onPressed: () {
              //       controller.onTapped(1);
              //     }),
              // GButton(
              //     icon: Icons.note_add_rounded,
              //     text: 'Đơn',
              //     iconColor: ColorsManager.primary,
              //     onPressed: () {
              //       controller.onTapped(1);
              //     }),
              GButton(
                  icon: CupertinoIcons.bubble_left_bubble_right_fill,
                  text: 'Chat',
                  iconColor: ColorsManager.primary,
                  onPressed: () {
                    controller.onTapped(1);
                  }),
              GButton(
                  icon: controller.checkAllNotiSeen.value == false ? Icons.notification_add_rounded : Icons.notifications,
                  text: 'Thông báo',
                  iconColor: controller.checkAllNotiSeen.value == false ? ColorsManager.red : ColorsManager.primary,
                  onPressed: () {
                    controller.onTapped(2);
                    // controller.checkNoti.value = false;
                  }),
              GButton(
                  icon: LineIcons.list,
                  text: 'Khác',
                  iconColor: ColorsManager.primary,
                  onPressed: () {
                    controller.onTapped(3);
                  })
            ]),
      ),
    );
  }
}
