import 'package:apartment_managage/presentation/a_features/guest_access/blocs/guest_access/guest_access_bloc.dart';
import 'package:apartment_managage/presentation/a_features/guest_access/screens/widgets/guest_access_card.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestAccessListScreen extends StatefulWidget {
  const GuestAccessListScreen({super.key});

  @override
  State<GuestAccessListScreen> createState() => _GuestAccessListScreenState();
}

class _GuestAccessListScreenState extends State<GuestAccessListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GuestAccessBloc>().add(GuestAccessEventStarted());
  }

  @override
  Widget build(BuildContext context) {
    const sizebox = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách khách"),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<GuestAccessBloc, GuestAccessState>(
          listener: (context, state) {
            if (state.status == GuestAccessStatus.error) {
              showSnackBarError(context, 'Xảy ra lỗi');
            }
          },
          builder: (context, state) {
            bool isLoading = state.status == GuestAccessStatus.loading ||
                state.status == GuestAccessStatus.initial;
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.list.isEmpty) {
              return const SizedBox(
                height: 600,
                child: Center(
                  child: Text('Không có khách nào đăng ký thăm hôm nay'),
                ),
              );
            }
            if (state.status == GuestAccessStatus.error) {
              return const Center(
                child: Text('Xảy ra lỗi'),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final item = state.list[index];
                // print(item);
                return GuestAccessCard(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}
