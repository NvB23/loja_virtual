import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> dataUser = {};
  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadCurrentUser();
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  void singUp(
      {required Map<String, dynamic> dataUser,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail,
      required VoidCallback onFailEmail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: dataUser['email'], password: pass)
        .then((user) async {
      UserCredential credential = user;
      firebaseUser = credential.user;

      loadCurrentUser();

      await _saveUserData(dataUser);

      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      if (error.code == 'email-already-in-use') {
        onFailEmail();
      }
      onFail();

      isLoading = false;
      notifyListeners();
    });
  }

  void signUpsignInWithGoogle(
      {Map<String, dynamic>? dataUser,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        onFail();
        isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      firebaseUser = authResult.user;

      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .get();

      if (currentUser.exists) {
        dataUser = currentUser.data();
      }

      dataUser!['email'] = firebaseUser!.email;
      dataUser['name'] = firebaseUser!.displayName;

      await _saveUserData(dataUser);

      isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (error) {
      onFail();

      isLoading = false;
      notifyListeners();
    }
  }

  void singIn(
      {required String email,
      required String password,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      firebaseUser = user.user;

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void recovePass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  void signOut() async {
    await _auth.signOut();
    dataUser = {};
    firebaseUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> dataUser) async {
    this.dataUser = dataUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set(dataUser);
  }

  Future<Null> loadCurrentUser({VoidCallback? onUserLoaded}) async {
    firebaseUser ??= _auth.currentUser;
    if (firebaseUser != null) {
      if (dataUser['name'] == null) {
        DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(firebaseUser!.uid)
            .get();

        dataUser = docUser.data()!;
      }
    }
    onUserLoaded?.call();
    notifyListeners();
  }
}
