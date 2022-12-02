import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:routemaster/routemaster.dart';

final _isAuthenticateProvider =
    Provider<bool>((ref) => ref.watch(AppState.auth).isAuthenticated);
final _isAuthLoading =
    Provider<bool>((ref) => ref.watch(AppState.auth).isLoading);

final globalScaffold = GlobalKey<ScaffoldMessengerState>();

class NoteKeeper extends ConsumerStatefulWidget {
  const NoteKeeper({Key? key}) : super(key: key);

  @override
  ConsumerState<NoteKeeper> createState() => _NoteKeeperState();
}

class _NoteKeeperState extends ConsumerState<NoteKeeper> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_isAuthLoading);
    if (isLoading) {
      return Container();
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: globalScaffold,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final isAuthenticated = ref.watch(_isAuthenticateProvider);
        return isAuthenticated ? routeLoggedIn : routeLoggedOut;
      }),
    );
  }
}
