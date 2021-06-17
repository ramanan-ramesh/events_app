import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:events_app/repositories/user_repository.dart';
import 'package:events_app/screens/home_screen.dart';
import 'package:events_app/screens/login/login_screen.dart';
import 'package:events_app/screens/no_connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'blocs/authentication_bloc/authentication_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<ConnectivityResult> connectivityStream;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivityStream = Connectivity().onConnectivityChanged;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Events App Demo',
      theme: ThemeData(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.yellow,
          cardColor: Colors.yellow[200],
          splashColor: Colors.pink,
          buttonColor: Colors.red[900],
          textTheme: TextTheme(
            subtitle2: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          )),
      home: StreamBuilder(
        stream: connectivityStream,
        builder: (context, snapshot) {
          var connectivityResult =
              (snapshot as AsyncSnapshot<ConnectivityResult>).data;
          if (connectivityResult == ConnectivityResult.none) {
            return NoConnectionScreen();
          }
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationFailure) {
                return LoginScreen(
                  userRepository: widget._userRepository,
                );
              }

              if (state is AuthenticationSuccess) {
                return HomeScreen(
                  user: state.firebaseUser,
                );
              }

              return Scaffold(
                appBar: AppBar(),
                body: Container(
                  child: Center(child: Text("Loading")),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
