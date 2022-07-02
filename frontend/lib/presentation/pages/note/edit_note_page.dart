import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/presentation/pages/note/edit_note_view_model.dart';
import 'package:note_keeper/presentation/pages/note/widgets/text_fields.dart';
import 'package:routemaster/routemaster.dart';

class EditNotePage extends ConsumerStatefulWidget {
  static const String routeName = "/editNotePage";
  final String? noteId;

  const EditNotePage({Key? key, required this.noteId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditNotePageState();
}

class _EditNotePageState extends ConsumerState<EditNotePage> with EditNoteView {
  late final EditNoteViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(EditNoteViewModel.provider);
    _viewModel.attachView(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.initAfterLoad(noteID: widget.noteId);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(EditNoteViewModel.provider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            if (!_viewModel.isLoading) {
              await _viewModel
                  .saveNote()
                  .then((_) => Routemaster.of(context).pop());
            } else {
              Routemaster.of(context).pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TitleTextField(
                        controller: _viewModel.titleTextEditingController),
                    Expanded(
                      child: RichContentTextField(
                        controller: _viewModel.richContentTextEditingController,
                        focus: _viewModel.isNewNote,
                        write: true,
                      ),
                    ),
                    QuillToolbar.basic(
                      controller: _viewModel.richContentTextEditingController,
                      multiRowsDisplay: false,
                      showAlignmentButtons: false,
                      showBackgroundColorButton: false,
                      showCameraButton: false,
                      showImageButton: false,
                      showVideoButton: false,
                      showClearFormat: false,
                      showDirection: false,
                      showJustifyAlignment: false,
                      showRightAlignment: false,
                      showLeftAlignment: false,
                      showCenterAlignment: false,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
