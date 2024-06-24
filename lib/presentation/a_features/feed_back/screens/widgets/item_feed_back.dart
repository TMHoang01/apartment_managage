import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class ItemFeedBack extends StatelessWidget {
  final FeedBackModel item;

  ItemFeedBack(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = switch (item.status ?? FeedBackStatus.pending) {
      FeedBackStatus.pending => Colors.orange,
      FeedBackStatus.approved => Colors.blue,
      FeedBackStatus.completed => Colors.green,
      FeedBackStatus.reviewed => Colors.green,
      _ => Colors.orange,
    };
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      height: 180,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () => navService.pushNamed(
            context,
            RouterAdmin.feedbackDetail,
            args: item,
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                width: size.width,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                ),
                child: Text(
                  'Phản ánh ${item.type?.toName() ?? ''}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        item.content ?? '',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      'Ngày tạo: ${TextFormat.formatDate(item.createdAt ?? DateTime.now(), formatType: 'dd/MM/yyyy hh:mm')}',
                    ),
                    Text(
                      'Người tạo: ${item.userName ?? ''}',
                    ),
                    Row(
                      children: [
                        const Text('Trạng thái:  '),
                        _buildStatus(
                            item.status ?? FeedBackStatus.pending, color),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildStatus(FeedBackStatus status, Color color) {
    return Text(
      status.toName(),
      style: TextStyle(
        color: color,
      ),
    );
  }
}
