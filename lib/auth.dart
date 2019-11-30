import 'dart:async';

import 'dart:convert';
import 'dart:io';
import 'globals.dart';
import 'Models/user.dart';
import 'Models/UserResponse.dart';
import 'package:http/http.dart' as http;
import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
abstract class BaseAuth {


  Future<UserResponse> signIn(String email, String password);
  Future<UserResponse> register(User user);
  ShowInspector();


}
/*
class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}
*/

class AuthASP  {
  AuthASP(this.alice);
  final Alice alice;

  Dio dio;

  Future<UserResponse> signIn(String email, String password) async {
    String targethost = '10.0.2.2';

    UserResponse resp = new UserResponse();
    var queryParameters = {
      'username': email,
      'password': password,

    };
    //we are using asp.net Identity for login/registration. the first time we
    //login we must obtain an OAuth token which we obtain by calling the Token endpoint
    //and pass in the email and password that the user registered with.
    try {

        var gettokenuri = new Uri(scheme: 'http',
            //      host: '10.0.2.2',
            port: 52175,
            host: targethost,
            path: '/Token');

        //the user name and password along with the grant type are passed the body as text.
        //and the contentype must be x-www-form-urlencoded
        var loginInfo = 'UserName=' + email + '&Password=' + password +
            '&grant_type=password';

        final response = await http
            .post(
              gettokenuri,
              headers: {"Content-Type": "application/x-www-form-urlencoded"},
              body: loginInfo
        );
        alice.onHttpResponse(response);
        if (response.statusCode == 200) {
          resp.error = '200';
          final json = jsonDecode(response.body);
          Globals.token = json['access_token'] as String;
        }
        else {
          //this call will fail if the security stamp for user is null
          resp.error = response.statusCode.toString() + ' ' + response.body;
          return resp;
        }

    }


    catch (e){
      resp.error = e.message;
    }
    return   resp ;

  }


  //this call is has anonymous access so no need for access token
  Future<UserResponse> register(User user) async {
    String targethost = '10.0.2.2';
    UserResponse resp = new UserResponse();
    String js;
    js = jsonEncode(user);

    //from the emulator 10.0.2.2 is mapped to 127.0.0.1  in windows

    var url1 = 'http://' + targethost + "/api/Account/Register";
    var url =  'http://10.0.2.2:52175/api/Account/Register';
    try {
      // final request = await client.p;
      final response = await http
          .post(url,

          headers: {"Content-Type": "application/json"},
          body: js)
          .then((response) {
        resp.error = '200';
        if ( response.statusCode != 200) {
          alice.onHttpResponse(response);
          resp.error = response.statusCode.toString() + ' ' + response.body;
        }
      });

    }  catch (e) {
      resp.error = e.message;
    }

    return resp;

  }
  Future<String> UserInfo() async {

    var url = new Uri(scheme: 'http',
      host: '10.0.2.2',
      port: 52175,

      path: '/api/Account/userinfo',
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    String authorization = 'Bearer ' + Globals.token;
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: authorization},
    );
    alice.onHttpResponse(response);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['Email'];
    }
    else {
      // resp.error = response.reasonPhrase;
      return 'error';
    }
  }
  ShowInspector(){
    alice.showInspector();
  }
}
