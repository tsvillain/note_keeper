import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/data/models/app_error.dart';
import 'package:note_keeper/presentation/pages/authentication/register/register_view_model.dart';
import 'package:note_keeper/presentation/pages/authentication/widgets/text_field.dart';
import 'package:routemaster/routemaster.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static const String routeName = "/register";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> with RegisterView {
  late final RegisterViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _viewModel = ref.read(RegisterViewModel.provider);
    _viewModel.attachView(this);
    super.initState();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      await _viewModel.createUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(RegisterViewModel.provider);
    return Scaffold(
      body: SafeArea(
          child: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.loose(const Size.fromWidth(300)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text("Welcome to Note Keeper",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ),
                              ),
                            ),
                            NameTextField(controller: _viewModel.nameContoller),
                            EmailTextField(
                                controller: _viewModel.emailContoller),
                            PasswordTextField(
                                controller: _viewModel.passwordContoller),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: _signUp,
                                child: const Text('Join'),
                              ),
                            ),
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                  text: 'Already have an account? ',
                                  children: [
                                    TextSpan(
                                      text: 'LogIn',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Routemaster.of(context)
                                            .push(AppRoutes.login),
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }

  @override
  void showError(AppError error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.message)));
  }
}
