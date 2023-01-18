import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/utils/messenger.dart';
import 'package:note_keeper/presentation/pages/profile/profile.dart';
import 'package:routemaster/routemaster.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const String routeName = "/profile";

  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with ProfileView {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(ProfileViewModel.provider);
    _viewModel.attachView(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(AppState.auth).user;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).replace(AppRoutes.home),
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
        title: const Text("My Profile"),
        actions: [
          IconButton(
              onPressed: () => Routemaster.of(context).push(AppRoutes.setting),
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 13),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(user!.name,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400)),
                                  Text(user.email,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () => Messenger.showSnackbar(
                                      'Not yet Implemented'),
                                  child: const Text("Edit Profile")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text("Log Out"),
                    leading: const Icon(Icons.logout),
                    onTap: () async {
                      await _viewModel.logout();
                    },
                  )
                ],
              ),
      ),
    );
  }
}
