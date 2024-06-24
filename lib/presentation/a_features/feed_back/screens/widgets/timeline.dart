import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:timelines/timelines.dart';

class TimelineProcessFeedBack extends StatelessWidget {
  FeedBackStatus status;
  TimelineProcessFeedBack({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    const inProgressColor = Color(0xffbabdc0);
    const todoColor = Colors.green;
    const data = FeedBackStatus.values;
    final statusIndex = FeedBackStatus.values.indexOf(status);
    Size size = MediaQuery.of(context).size;
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        // center
        nodePosition: 0,
        direction: Axis.horizontal,
        connectorTheme: const ConnectorThemeData(
          space: 30.0,
          thickness: 3.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      builder: TimelineTileBuilder.connected(
        contentsBuilder: (_, index) => Container(
          margin: const EdgeInsets.only(left: 5.0, right: 10.0),
          height: 40.0,
          child: Text(
            '${data[index].toName()}',
            textAlign: TextAlign.center,
          ),
        ),
        connectorBuilder: (_, index, __) {
          // if (index == 0) {
          //   return const SolidLineConnector(
          //     color: Color(0xffbabdc0),
          //   );
          // }

          if (index < statusIndex) {
            return const SolidLineConnector(
              thickness: 2,
              color: Color(0xffbabdc0),
            );
          } else {
            return const DashedLineConnector(
              thickness: 2,
              gap: 2,
              dash: 2,
              color: Color(0xffbabdc0),
            );
          }
        },
        indicatorBuilder: (_, index) {
          if (index <= statusIndex) {
            return const DotIndicator(
                color: todoColor,
                size: 26,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15.0,
                ));
          } else if (index == statusIndex + 1) {
            return const OutlinedDotIndicator(
              borderWidth: 2.0,
              size: 26,
              color: inProgressColor,
              child: Icon(
                Icons.rotate_right_outlined,
                color: inProgressColor,
                size: 15.0,
              ),
            );
          } else {
            return const OutlinedDotIndicator(
              borderWidth: 2.0,
              size: 26,
              color: inProgressColor,
            );
          }
        },
        itemExtentBuilder: (_, __) => size.width / 4,
        itemCount: data.length,
      ),
    );
  }
}
