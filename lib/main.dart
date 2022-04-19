// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authdemo(),
    );
  }
}
class Authdemo extends StatelessWidget {

  //instance for firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signIn() async {

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken:gSA.idToken,
        accessToken:gSA.accessToken
    );
    final UserCredential authresult = await _auth.signInWithCredential(credential);
    final User user= authresult.user;
    print("username : ${user.displayName}");
    return user;
  }
  void signOut(){
      googleSignIn.signOut();
      print("Signout Sucessfully!!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Firebase Auth'
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: ()=>signIn().then((User user)=>print(user)).catchError((e)=>print(e)),
              child: const Text('Sign In'),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            ElevatedButton(
              onPressed: signOut,
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}


