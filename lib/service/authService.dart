import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<String?> registration({
    required bool isOrganizer,
    required String fullName,
    required String email,
    required String password,
  }) async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;


      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        "isOrganizer": isOrganizer,
        'name': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(), 
      });
      return "User Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
  Future<String?> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

        if (!userDoc.exists) {

          await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
            "isOrganizer": true,
            'name': user.displayName ?? 'No Name',
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return "Google Sign-In Success";
    } catch (e) {
      print('Error signing in with Google: $e');
      return 'Error signing in with Google';
    }
  }
  // Future<UserCredential> signInWithGoogle() async {
  //      final GoogleSignIn googleSignIn = GoogleSignIn(
  //     clientId: '986741810915-7kdotp3n4peckt44clbkusb9m1frt16n.apps.googleusercontent.com', // Replace with your actual client ID
  //   );
  //      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   //
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print(user.uid);

      return user.uid;
    } else {
      print('No user is currently logged in');
      return null;
    }
  }



  Future<String> FirebaseSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
       return 'User signed out successfully';
    } catch (e) {
       return 'Error signing out: $e';
    }
  }
}