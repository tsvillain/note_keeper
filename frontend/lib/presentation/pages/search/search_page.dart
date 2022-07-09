import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/presentation/pages/search/search_view_model.dart';
import 'package:note_keeper/presentation/pages/widgets/note_preview.dart';
import 'package:routemaster/routemaster.dart';

class SearchPage extends ConsumerStatefulWidget {
  static const String routeName = "/search";
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with SearchView {
  late final SearchViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(SearchViewModel.provider);
    _viewModel.attachView(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(SearchViewModel.provider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).replace(AppRoutes.home);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: Hero(
          tag: "search",
          child: TextFormField(
            controller: _viewModel.searchTextController,
            decoration: const InputDecoration(
              isDense: true,
              hintText: "Search your note",
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ),
      body: SafeArea(
          child: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : _viewModel.searchTextController.text.isEmpty
                  ? const Center(
                      child: Text("Type something to get results.."),
                    )
                  : _viewModel.getNotes.isEmpty
                      ? const Center(
                          child: Text("No notes found.."),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            controller: _viewModel.notesListScrollController,
                            child: StaggeredGrid.count(
                              crossAxisCount:
                                  _viewModel.crossAxisCountTwo ? 2 : 1,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              axisDirection: AxisDirection.down,
                              children: _viewModel.getNotes.map((note) {
                                return NotePreview(
                                    note: note, key: Key(note.docId ?? ""));
                              }).toList(),
                            ),
                          ),
                        )),
    );
  }
}
