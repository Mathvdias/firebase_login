import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/app/app.dart';
import 'package:firebase_login/firebase_options.dart';

import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  runApp(App(authenticationRepository: authenticationRepository));
}
