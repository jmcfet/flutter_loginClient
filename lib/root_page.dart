import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'package:alice/alice.dart';


class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final AuthASP auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();

    setState(() {
      authStatus =  AuthStatus.notSignedIn;
    });

  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Flutter Login',
          auth: widget.auth,
          onSignedIn: () => _updateAuthStatus(AuthStatus.signedIn),
        //  alice:widget.alice
        );
      case AuthStatus.signedIn:
        return new HomePage(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
        );
    }
  }
}