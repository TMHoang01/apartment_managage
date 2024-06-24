import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/services/services_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/a_features/service/screens/services/widgets/service_card.dart';
import 'package:apartment_managage/router.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ cung cấp'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       navService.pushNamed(context, RouterAdmin.serviceAdd);
        //     },
        //   ),
        // ],
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return RefreshIndicator(
              onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
                    context.read<ServicesBloc>().add(ServicesStarted());
                  }),
              child: _handleSate(state));
        },
      ),
    );
  }

  Widget _handleSate(ServicesState state) {
    return switch (state) {
      ServicesLoaded(services: final services) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return ServiceCardWidget(service: service);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ServicesFailure(message: final message) => Center(child: Text(message)),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
