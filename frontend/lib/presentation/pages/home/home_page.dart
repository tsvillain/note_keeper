import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/core/utils/messenger.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/presentation/pages/home/home_view_model.dart';
import 'package:note_keeper/presentation/pages/home/widgets/custom_search_bar.dart';
import 'package:note_keeper/presentation/pages/widgets/note_preview.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(HomeViewModel.provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Keeper"),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                // log("Accepted:: ${v.toJson()}");
              },
              onLeave: (v) {
                // log("Drop the Note");
                Messenger.showSnackbar(
                    "Drop the Note in Delete Section to Delete!");
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
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  const CustomSearchBar(),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      Messenger.showSnackbar("Hello");
                      Routemaster.of(context).push(AppRoutes.editNote);
                    },
                    tooltip: "Add new note",
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.add_outlined),
                  ),
                ],
              ),
            ),
      body: SafeArea(
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  controller: _viewModel.notesListScrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: _viewModel.crossAxisCountTwo ? 2 : 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    axisDirection: AxisDirection.down,
                    children: _viewModel.getNotes.map((note) {
                      final preview =
                          NotePreview(note: note, key: Key(note.docId ?? ""));
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
                ),
              ),
      ),
    );
  }
}
