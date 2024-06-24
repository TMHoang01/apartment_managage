import 'package:apartment_managage/presentation/blocs/auth/auth/auth_bloc.dart';
import 'package:apartment_managage/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen2 extends StatefulWidget {
  const SettingScreen2({super.key});

  @override
  State<SettingScreen2> createState() => _SettingScreen2State();
}

class _SettingScreen2State extends State<SettingScreen2>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              '$selectedIndex',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex++;
              });
            },
            child: const Text('Go to Setting'),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // if (state is UnAuthenticated) {
              //   Navigator.pushNamedAndRemoveUntil(
              //       context, AppRouter.signIn, (route) => false);
              // }
              navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
                child: const Text('Logout'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                        title: "Dark Mode",
                        icon: Icons.dark_mode_outlined,
                        trailing: Switch(
                            value: _isDark,
                            onChanged: (value) {
                              setState(() {
                                _isDark = value;
                              });
                            })),
                    const _CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    const _CustomListTile(
                        title: "Security Status",
                        icon: CupertinoIcons.lock_shield),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Organization",
                  children: [
                    _CustomListTile(
                        title: "Profile", icon: Icons.person_outline_rounded),
                    _CustomListTile(
                        title: "Messaging", icon: Icons.message_outlined),
                    _CustomListTile(
                        title: "Calling", icon: Icons.phone_outlined),
                    _CustomListTile(
                        title: "People", icon: Icons.contacts_outlined),
                    _CustomListTile(
                        title: "Calendar", icon: Icons.calendar_today_rounded)
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    const _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                    const _CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
                    _CustomListTile(
                      title: "Sign out",
                      icon: Icons.exit_to_app_rounded,
                      onTap: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function? onTap;
  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
