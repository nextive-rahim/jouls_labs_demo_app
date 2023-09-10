import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/db_helper.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_routes.dart';

String? email;
String? token;
String? profileImage;
String? userName;

class LoginViewController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DBHelper dbHelper = DBHelper();
  var userC;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['https://mail.google.com/']);
  Future<GoogleSignInAccount?> signIn() async {
    if (await googleSignIn.isSignedIn()) {
      return googleSignIn.currentUser;
    } else {
      return await googleSignIn.signIn();
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      //SIGNING IN WITH GOOGLE
      final GoogleSignInAccount? googleSignInAccount = await signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      //CREATING CREDENTIAL FOR FIREBASE
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      //SIGNING IN WITH CREDENTIAL & MAKING A USER IN FIREBASE  AND GETTING USER CLASS
      final userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      //CHECKING IS ON
      assert(!user!.isAnonymous);

      final User? currentUser = _auth.currentUser;
      assert(currentUser!.uid == user!.uid);

      if (user != null) {
        email = user.email;
        token = googleSignInAuthentication.accessToken;
        profileImage = user.photoURL;
        userName = user.displayName;
        userC = user;

        Get.toNamed(Routes.home);
      }
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> refreshToken() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signInSilently();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    //SIGNING IN WITH CREDENTIAL & MAKING A USER IN FIREBASE  AND GETTING USER CLASS
    final userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    email = user!.email;
    token = googleSignInAuthentication.accessToken;
    userC = user;
    //IdTokenResult tokenResult = await user.getIdTokenResult();
    // bool data = DateTime.now().isBefore(tokenResult.expirationTime!);
    // print(tokenResult.expirationTime);
    // print(token);
    return googleSignInAuthentication.accessToken; // New refreshed token
  }

  checkSignIn() async {
    if (await googleSignIn.isSignedIn()) {
      refreshToken().then((value) {
        Get.toNamed(Routes.home);
      });
    } else {
      signInWithGoogle();
    }
  }
}
