import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/presentation/pages/authentication/login/login_view_model.dart';
import 'package:note_keeper/presentation/pages/authentication/widgets/text_field.dart';
import 'package:routemaster/routemaster.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with LoginView {
  late final LoginViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _viewModel = ref.read(LoginViewModel.provider);
    _viewModel.attachView(this);
    super.initState();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      await _viewModel.createSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(LoginViewModel.provider);
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
                                  child: Text("Welcome Back! to Note Keeper",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                ),
                              ),
                            ),
                            EmailTextField(
                                controller: _viewModel.emailContoller),
                            PasswordTextField(
                                controller: _viewModel.passwordContoller),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () {
                                  //*Bix fix. Material app was not reading the Appsate.auth change in [user]
                                  //The parenthesis from the call below was missing and the call was not triggering. Whoops.
                                  _signIn();
                                },
                                child: const Text('Sign In?'),
                              ),
                            ),
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                  text: 'Don\'t have an account? ',
                                  children: [
                                    TextSpan(
                                      text: 'Join Now',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Routemaster.of(context)
                                            .push(AppRoutes.register),
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
}
