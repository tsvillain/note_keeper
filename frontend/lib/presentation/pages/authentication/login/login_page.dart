import 'package:appwrite/appwrite.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/presentation/pages/authentication/login/login_view_model.dart';
import 'package:note_keeper/presentation/pages/authentication/widgets/text_field.dart';
import 'package:note_keeper/presentation/pages/pages.dart';
import 'package:routemaster/routemaster.dart';

final _authProvider =
    Provider<Account>((ref) => Account(ref.read(BackendDependency.client)));

final _authServiceProvider = StateNotifierProvider<AuthService, AuthState>(
    (ref) => AuthService(ref.read(Repository.auth), ref));

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
      /// //!this was causing me (git @mandolf0) headaches upgrading / adopting
      //? threw a whole messs of errors   ------>
      await _viewModel.createSession();

      /// threw the following errors
      ///  Unhandled Exception: type 'Account' is not a subtype of type 'FutureOr<Account>' where
/* E/flutter ( 3707):   Account is from package:appwrite/models.dart
package:appwrite/models.dart:1
E/flutter ( 3707):   Account is from package:appwrite/appwrite.dart */
//perhaps you can move this to the view_model
      /* print(
        _viewModel.emailContoller.text,
      );
      await ref.read(_authProvider).createEmailSession(
          email: _viewModel.emailContoller.text,
          password: _viewModel.emailContoller.text);
      await ref.read(_authProvider).get().then(
          (value) => ref.read(_authServiceProvider.notifier).setUser(value));
      ref.read(_authServiceProvider.notifier).refresh(); */
      //navigate to home()

    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(LoginViewModel.provider);
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.open_in_browser),
          onPressed: () {
            ref
                .read(_authProvider)
                .createEmailSession(
                    email: 'somebody@me.com', password: 'longpasswordhere')
                .then((value) =>
                    Routemaster.of(context).push(HomePage.routeName));
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_search),
          onPressed: () {
            ref.read(_authProvider).get().then((value) async {
              AuthService authService;

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${value.email} ${value.name}')));
              ref.read(_authServiceProvider.notifier).setUser(value);
            });

            // final aw.Account user = await ref.read(_authProvider).get();
            //navigate to home page
            Routemaster.of(context).push(SettingPage.routeName);
          },
        ),
      ]),
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
                                          .headline5),
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
                                onPressed: () async {
                                  _signIn;

                                  /* Routemaster.of(context)
                                      .push(HomePage.routeName); */
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
