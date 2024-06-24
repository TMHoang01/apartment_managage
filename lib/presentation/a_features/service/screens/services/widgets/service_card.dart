import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;
  const ServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return SizedBox(
      height: size.height * 0.36,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: InkWell(
          onTap: () => _onNavigateDetail(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(children: [
                  CustomImageView(
                    url: service.image ?? '',
                    width: double.infinity,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -6,
                    child: CustomCircleButton(
                      icon: Icons.edit,
                      iconSize: 24,
                      onPressed: () => navService.pushNamed(
                          context, RouterAdmin.serviceEdit,
                          args: service),
                    ),
                  ),
                ]),
              ),
              const Divider(thickness: 0.4),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${service.title}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${service.description}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'Đánh giá: ${service.rating}',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Đơn đặt: ${service.bookingCount}',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onNavigateDetail(BuildContext context) {
    navService.pushNamed(context, RouterAdmin.serviceDetail, args: service);
  }
}
