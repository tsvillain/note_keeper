import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/presentation/pages/home/home_view_model.dart';
import 'package:note_keeper/presentation/pages/home/widgets/note_preview.dart';
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
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: _viewModel.showDelete
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endDocked,
      floatingActionButton: _viewModel.showDelete
          ? DragTarget<NoteModel>(
              onAccept: (v) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                              "Do you want to delete selected note?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  _viewModel.deleteNote(v.docId!);
                                  Navigator.pop(context);
                                },
                                child: const Text("YES")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("NO")),
                          ],
                        ));
                print("Accepted:: ${v.toJson()}");
              },
              onLeave: (v) {
                // TODO
                // show snackbar alert "Drop the Note in Delete Section to Delete!"
              },
              builder: (_, data, ___) {
                return FloatingActionButton.extended(
                  onPressed: null,
                  label: const Text("Drag here to Delete"),
                  backgroundColor:
                      data.isNotEmpty ? Colors.redAccent : Colors.grey,
                );
              },
            )
          : FloatingActionButton(
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.editNote);
              },
              tooltip: "Add new note",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add_outlined),
            ),
      body: SafeArea(
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Padding(
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
                            crossAxisCount:
                                _viewModel.crossAxisCountTwo ? 2 : 1,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            axisDirection: AxisDirection.down,
                            children: _viewModel.getNotes.map((note) {
                              final preview = NotePreview(
                                  note: note, key: Key(note.docId ?? ""));
                              return Draggable<NoteModel>(
                                  onDragStarted: () {
                                    _viewModel.toggleShowDelete();
                                  },
                                  onDraggableCanceled: (_, __) {
                                    _viewModel.toggleShowDelete(v: false);
                                  },
                                  onDragEnd: (_) {
                                    _viewModel.toggleShowDelete(v: false);
                                  },
                                  feedback: preview,
                                  data: note,
                                  child: preview);
                            }).toList(),
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
                                    onPressed: _viewModel.toggleCrossAxisCount,
                                    icon:
                                        const Icon(Icons.view_column_outlined)),
                                const CircleAvatar(
                                    child: Icon(Icons.person_outline)),
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
