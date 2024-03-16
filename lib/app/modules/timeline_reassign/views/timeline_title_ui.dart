import 'package:flutter/material.dart';
import 'package:hrea_mobile_employee/app/modules/timeline_reassign/views/event_path.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineTileUI extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final bool isActive;
  final eventChild;

  const TimeLineTileUI(
      {Key? key, required this.isFirst, required this.isLast, required this.isPast, required this.eventChild, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: Colors.blueAccent,
        ),
        indicatorStyle: IndicatorStyle(
            width: 40.0,
            color: Colors.blueAccent,
            iconStyle: IconStyle(iconData: isActive ? Icons.check_circle : Icons.highlight_remove_rounded, color: Colors.white)),
        endChild: EventPath(
          childWidget: eventChild,
        ),
      ),
    );
  }
}
