import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/presentation/pages/home/home_view_model.dart';
import 'package:routemaster/routemaster.dart';

class CustomSearchBar extends ConsumerWidget {
  const CustomSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(HomeViewModel.provider);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: viewModel.showAppBar ? 0 : MediaQuery.of(context).size.height + 200,
      curve: Curves.ease,
      child: Container(
        height: kToolbarHeight - 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: const [
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
                SizedBox(width: 20),
                Text("Search your note")
              ],
            ),
            const SizedBox(width: 40),
            Row(
              children: [
                IconButton(
                    onPressed: viewModel.toggleCrossAxisCount,
                    icon: const Icon(Icons.view_column_outlined)),
                GestureDetector(
                    onTap: () =>
                        Routemaster.of(context).push(AppRoutes.setting),
                    child:
                        const CircleAvatar(child: Icon(Icons.person_outline))),
                const SizedBox(width: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}
