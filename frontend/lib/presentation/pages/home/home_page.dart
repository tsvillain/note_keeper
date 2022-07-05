import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/presentation/pages/home/home_view_model.dart';
import 'package:routemaster/routemaster.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with HomeView {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(HomeViewModel.provider);
    _viewModel.attachView(this);
    _viewModel.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(HomeViewModel.provider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.editNote);
        },
        tooltip: "Add new note",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_outlined),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _viewModel.notesListScrollController,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    const SizedBox(height: 8),
                    StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      axisDirection: AxisDirection.down,
                      children: _viewModel.getNotes
                          .map((e) => GestureDetector(
                                onTap: () {
                                  Routemaster.of(context)
                                      .push("${AppRoutes.editNote}/${e.docId}");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: e.title.isNotEmpty,
                                        child: Text(e.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ),
                                      Visibility(
                                          visible: e.title.isNotEmpty,
                                          child: const SizedBox(height: 12)),
                                      Text(e.content,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                top: _viewModel.showAppBar ? 0 : -200,
                curve: Curves.ease,
                child: Container(
                  height: kToolbarHeight - 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.menu_rounded)),
                          const Text("Search your note")
                        ],
                      ),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.view_column_outlined)),
                          const CircleAvatar(child: Icon(Icons.person_outline)),
                          const SizedBox(width: 8),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
