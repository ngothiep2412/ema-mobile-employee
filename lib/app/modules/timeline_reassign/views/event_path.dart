import 'package:flutter/material.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';

class EventPath extends StatelessWidget {
  final childWidget;
  const EventPath({Key? key, required this.childWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.formatFontSize(10.0, context)),
      margin: EdgeInsets.only(
          top: UtilsReponsive.formatFontSize(30.0, context),
          bottom: UtilsReponsive.formatFontSize(30.0, context),
          left: UtilsReponsive.formatFontSize(20.0, context),
          right: UtilsReponsive.formatFontSize(20.0, context)),
      child: childWidget,
    );
  }
}
