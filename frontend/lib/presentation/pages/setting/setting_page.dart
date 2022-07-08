import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/presentation/pages/setting/setting_view_model.dart';
import 'package:routemaster/routemaster.dart';

class SettingPage extends ConsumerStatefulWidget {
  static const String routeName = "/setting";
  const SettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingPage> with SettingView {
  late final SettingViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(SettingViewModel.provider);
    _viewModel.attachView(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(SettingViewModel.provider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).replace(AppRoutes.home);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.color_lens_outlined),
                        title: const Text("Theme"),
                        trailing: const Text("System default"),
                        onTap: () {
                          // TODO snack bar "Not yet implemented"
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    title: const Text("Log Out"),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      // TODO logout user
                    },
                  )
                ],
              ),
      ),
    );
  }
}
