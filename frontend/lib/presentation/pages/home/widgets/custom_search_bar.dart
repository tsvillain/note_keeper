import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Container(
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
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                  onTap: () {
                    Routemaster.of(context).push(AppRoutes.search);
                  },
                  child: const Hero(
                      tag: 'search', child: Text("Search your note")))
            ],
          ),
          const SizedBox(width: 40),
          Row(
            children: [
              IconButton(
                  onPressed: viewModel.toggleCrossAxisCount,
                  icon: viewModel.crossAxisCountTwo
                      ? const FaIcon(FontAwesomeIcons.gripVertical)
                      : const FaIcon(FontAwesomeIcons.gripLines)),
              GestureDetector(
                  onTap: () => Routemaster.of(context).push(AppRoutes.setting),
                  child: const CircleAvatar(child: Icon(Icons.person_outline))),
              const SizedBox(width: 8),
            ],
          )
        ],
      ),
    );
  }
}
