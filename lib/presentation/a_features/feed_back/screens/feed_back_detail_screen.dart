import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/blocs/feed_back_detail/feed_back_detail_bloc.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/blocs/feed_backs/feed_backs_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';

import 'widgets/timeline.dart';

class FeedBackDetailScreen extends StatefulWidget {
  final FeedBackModel feedBack;
  const FeedBackDetailScreen({super.key, required this.feedBack});

  @override
  State<FeedBackDetailScreen> createState() => _FeedBackDetailScreenState();
}

class _FeedBackDetailScreenState extends State<FeedBackDetailScreen> {
  @override
  Widget build(BuildContext context) {
    FeedBackModel item = widget.feedBack;
    FeedBackStatus status = item.status ?? FeedBackStatus.pending;
    List<Employee> listHandlers = item.listHandlers != null
        ? List<Employee>.from(item.listHandlers!)
        : <Employee>[];
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    const sizebox1 = SizedBox(height: 3);
    return BlocProvider(
      create: (context) =>
          sl<FeedBackDetailBloc>()..add(FeedBackDetailStarted(feedBack: item)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phản ánh'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // time line
              SizedBox(
                width: size.width,
                height: 86,
                child: BlocBuilder<FeedBackDetailBloc, FeedBackDetailState>(
                  buildWhen: (previous, current) {
                    return current is FeedBackDetailLoaded;
                  },
                  builder: (context, state) {
                    status = state.feedBack?.status ?? FeedBackStatus.pending;
                    return TimelineProcessFeedBack(
                      status: status,
                    );
                  },
                ),
              ),
              // info
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nội dung phản ánh',
                        style: theme.textTheme.titleMedium,
                      ),
                      sizebox1,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text('Mã phản ánh: '),
                      //     Text(item.id ?? ""),
                      //   ],
                      // ),
                      _builTitle('Nguời tạo:', item.userName ?? ''),
                      _builTitle(
                          'Ngày tạo:',
                          TextFormat.formatDate(item.createdAt,
                              formatType: 'HH:MM dd/MM/yyyy')),
                      // _builTitle('Trạng thái:', item.status?.toName() ?? ''),

                      const SizedBox(height: 2),
                      const Text(
                        'Chi tiết: ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(item.content ?? ""),
                      const SizedBox(height: 2),
                      if (item.image != null)
                        CustomImageView(
                          url: item.image,
                          width: size.width,
                          height: 200,
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // list handler
              BlocConsumer<FeedBackDetailBloc, FeedBackDetailState>(
                listener: (context, state) {
                  if (state is FeedBackDetailUpdated) {
                    context
                        .read<FeedBacksBloc>()
                        .add(FeedBacksUpdateItem(state.feedBack));
                  } else if (state is FeedBackDetailFailure) {
                    showSnackBarError(context, state.message);
                  }
                },
                builder: (context, state) {
                  final status = state.feedBack?.status;
                  Widget listHandlerWidget = const SizedBox();
                  if (status != FeedBackStatus.pending) {
                    listHandlerWidget = Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Danh sách người xử lý:',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(width: 4),
                                    if (status == FeedBackStatus.approved)
                                      IconButton(
                                          onPressed: () async {
                                            navService
                                                .pushNamed(context,
                                                    RouterAdmin.employSelect,
                                                    args: state.feedBack
                                                            ?.listHandlers ??
                                                        <Employee>[])
                                                .then((value) {
                                              if (value != null &&
                                                  value is List &&
                                                  value.isNotEmpty) {
                                                setState(() {
                                                  listHandlers =
                                                      value as List<Employee>;
                                                });
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.add))
                                  ],
                                ),
                                sizebox1,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var user in listHandlers)
                                      _itemUserCard(
                                        user,
                                        status == FeedBackStatus.approved
                                            ? () {
                                                setState(() {
                                                  listHandlers.remove(user);
                                                });
                                              }
                                            : null,
                                      ),
                                  ],
                                ),
                                sizebox1,
                                sizebox1,
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      listHandlerWidget,
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),

              // rating and review
              BlocBuilder<FeedBackDetailBloc, FeedBackDetailState>(
                buildWhen: (previous, current) {
                  return current is FeedBackDetailLoaded;
                },
                builder: (context, state) {
                  final feedback = state.feedBack;
                  if (feedback?.status != FeedBackStatus.reviewed) {
                    return const SizedBox();
                  }
                  return Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đánh giá mức độ hài lòng',
                                style: theme.textTheme.titleMedium,
                              ),
                              const Text(
                                  'Vui lòng đánh để nâng cao chất lượng dịch vụ của chúng tôi'),
                            ],
                          ),
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: item.rating ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: kSecondaryColor,
                              size: 16,
                            ),
                            onRatingUpdate: (vaule) {},
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            margin: const EdgeInsets.all(0),
                            initialValue: item.review,
                            readOnly: true,
                            hintText: 'Đánh giá',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // button when
              BlocBuilder<FeedBackDetailBloc, FeedBackDetailState>(
                buildWhen: (previous, current) {
                  return current is FeedBackDetailLoaded ||
                      current is FeedBackDetailLoading;
                },
                builder: (context, state) {
                  status = state.feedBack?.status ?? FeedBackStatus.pending;
                  if (state is FeedBackDetailLoading) {
                    return const SizedBox();
                  }
                  if (status == FeedBackStatus.completed ||
                      status == FeedBackStatus.reviewed) {
                    return CustomButton(
                      title: 'Xử lý lại',
                      onPressed: () {
                        _dialogBuilder(context);
                      },
                    );
                  } else if (status != FeedBackStatus.approved) {
                    return const SizedBox();
                  }
                  return Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(16),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trạng thái',
                                style: theme.textTheme.titleMedium,
                              ),
                              sizebox1,
                              SelectWidget(
                                onChanged: () {
                                  setState(() {
                                    status = FeedBackStatus.approved;
                                  });
                                },
                                text: FeedBackStatus.approved.toName(),
                                isSelect: status == FeedBackStatus.approved,
                              ),
                              SelectWidget(
                                text: FeedBackStatus.completed.toName(),
                                color: Colors.green,
                                isSelect: status == FeedBackStatus.completed,
                                onChanged: () {
                                  setState(() {
                                    status = FeedBackStatus.completed;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<FeedBackDetailBloc, FeedBackDetailState>(
          builder: (context, state) {
            final feedback = state.feedBack;
            String title = switch (feedback?.status) {
              FeedBackStatus.pending => 'Tiếp nhận',
              _ => 'Lưu thay đổi'
            };

            void onPressed() {
              if (!isChangeFeedBack(status, listHandlers, feedback) &&
                  feedback?.status != FeedBackStatus.pending) {
                // showSnackBarInfo(context, 'message');
                logger.d('Không có thay đổi');
                return;
              }
              if (feedback?.status == FeedBackStatus.pending) {
                context.read<FeedBackDetailBloc>().add(
                    const FeedBackDetailChangeStatus(
                        status: FeedBackStatus.approved));
              } else {
                context.read<FeedBackDetailBloc>().add(
                      FeedBackDetailUpdateSubmit(
                        feedback!.copyWith(
                          status: status,
                          listHandlers: listHandlers,
                        ),
                      ),
                    );
              }
            }

            if (feedback?.status == FeedBackStatus.completed ||
                feedback?.status == FeedBackStatus.reviewed) {
              return const SizedBox();
            }
            bool isDisable = state is FeedBackDetailLoading;

            return CustomButton(
              // isDisable: isDisable,
              prefixWidget: state is FeedBackDetailLoading?
                  ? Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    )
                  : null,
              onPressed: isDisable ? null : onPressed,
              title: title,
            );
          },
        ),
      ),
    );
  }

  ListTile _itemUserCard(Employee user, Function? onPressed) {
    String name = user.username != null && user.username!.isNotEmpty
        ? user.username![0]
        : '';

    Widget secondary = CircleAvatar(
      radius: 24,
      child: Text(name.toUpperCase()),
    );

    if (user.avatar != null && user.avatar!.isNotEmpty) {
      secondary = CustomImageView(
        borderRadius: BorderRadius.circular(40),
        url: user.avatar,
        width: 50,
        height: 50,
      );
    }
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: secondary,
      title: Text('${user.username} '),
      subtitle: Text('${user.position?.name} '),
      trailing: onPressed != null
          ? IconButton(
              onPressed: () {
                onPressed();
              },
              icon: const Icon(Icons.close),
            )
          : null,
    );
  }

  Widget _builTitle(String title, String value) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }

  bool isChangeFeedBack(
      FeedBackStatus status, List<Employee> newList, FeedBackModel? fb) {
    // check list handler.listHandler feedback and list handler
    if (status != fb?.status) {
      return true;
    }
    final listHandlerOld = fb?.listHandlers ?? <Employee>[];
    if (listHandlerOld.length != newList.length) {
      return true;
    }
    bool isChange = false;
    final length = listHandlerOld.length > newList.length
        ? listHandlerOld.length
        : newList.length;
    for (var i = 0; i < length; i++) {
      if (newList[i].id != listHandlerOld[i].id) {
        isChange = true;
        break;
      }
    }

    return isChange;
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Thông báo'),
          content: const Text(
            'Bạn có xác nhận muốn xử lý lại phản ánh này?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Không'),
              onPressed: () {
                navService.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Đồng ý'),
              onPressed: () async {
                context.read<FeedBackDetailBloc>().add(
                      const FeedBackDetailChangeStatus(
                          status: FeedBackStatus.approved),
                    );
                navService.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
