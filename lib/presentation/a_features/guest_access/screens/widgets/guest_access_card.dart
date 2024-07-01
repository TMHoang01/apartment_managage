import 'package:apartment_managage/presentation/a_features/guest_access/blocs/guest_access/guest_access_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apartment_managage/domain/models/guest_access/guest_access.dart';

import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/text_format.dart';

class GuestAccessCard extends StatelessWidget {
  final GuestAccess item;
  const GuestAccessCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<GuestAccessBloc>()
            .add(GuestAccessEventDetailStated(item.id ?? ''));
        navService.pushNamed(context, AppRouter.guestAccessDetail);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
        child: Card(
          color: Colors.white,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const Icon(FontAwesomeIcons.clock),
                      const SizedBox(height: 8),
                      Text(
                        TextFormat.formatDate(item.expectedTime,
                            formatType: 'dd/TM'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   TextFormat.formatDate(item.expectedTime,
                      //       formatType: 'hh:mm'),
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LineTitle('Khách thăm', item.guestName ?? ''),
                      _LineTitle('Sđt', item.guestPhone ?? ''),
                      _LineTitle('CCCD', item.guestCccd ?? ''),
                      if (item.residentName != null) const SizedBox(height: 8),
                      if (item.residentName != null)
                        _LineTitle('Cư dân', item.residentName ?? ''),

                      // Text('Thời gian dự kiến: ${item.expectedTime}'),
                      const SizedBox(height: 10),

                      // Text(
                      //   'Mục đích: ${item.purpose}',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.statusColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            item.statusText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     padding: const EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //       color: item.statusColor,
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Center(
                //       child: Text(
                //         item.statusText,
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _LineTitle(String title, String value) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
