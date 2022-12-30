import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';
import 'package:swapxchange/enum/online_status.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/tokens.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';
import 'package:swapxchange/ui/auth/login.dart';
import 'package:swapxchange/utils/firebase_collections.dart';
import 'package:swapxchange/utils/prefs_app_user.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class AuthRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection = _firestore.collection(FirebaseCollection.USERS_COLLECTION);

  User? getCurrentUser() => _auth.currentUser ?? null;

  static void refreshMe({
    required Function(AppUser? appUser) onSuccess,
    required Function(dynamic er) onError,
  }) async {
    //Register/Update on the server
    await ApiClient.request().get('users/me').then((res) {
      try {
        AppUser appUser = AppUser.fromMap(res.data["data"]["user"]);
        return appUser;
      } catch (e) {
        onError(e);
      }
    }).catchError((error) {
      onError(catchErrors(error));
    });
  }

  static void getUserDetails({
    required userId,
    required Function(AppUser? appUser) onSuccess,
    required Function(dynamic er) onError,
  }) async {
    //Register/Update on the server
    await ApiClient.request().get('/users/user/$userId').then((res) {
      try {
        AppUser appUser = AppUser.fromMap(res.data["data"]["user"]);
        return appUser;
      } catch (e) {
        onError(e);
      }
    }).catchError((error) {
      onError(catchErrors(error));
    });
  }

  static Future<AppUser?> findByUserId({required userId}) async {
    final res = await ApiClient.request().get('/users/user/$userId');
    if (res.statusCode == 200) {
      try {
        return AppUser.fromMap(res.data["data"]["user"]);
      } catch (e) {
        return null;
      }
    }
  }

  void facebookSignIn({
    required Function(User user) loginSuccess,
    required Function() onProgress,
    required Function() onCancelled,
    required Function() onFailed,
  }) async {
    try {
      final LoginResult facebookLoginResult = await FacebookAuth.instance.login();
      switch (facebookLoginResult.status) {
        case LoginStatus.success:
          AccessToken facebookAccessToken = facebookLoginResult.accessToken!;
          // Create a credential from the access token
          AuthCredential authCredential = FacebookAuthProvider.credential(facebookAccessToken.token);
          final User fbUser = (await _auth.signInWithCredential(authCredential)).user!;
          loginSuccess(fbUser);
          break;
        case LoginStatus.cancelled:
          onCancelled();
          break;
        case LoginStatus.failed:
          onFailed();
          break;
        case LoginStatus.operationInProgress:
          onProgress();
          break;
      }
    } catch (e) {
      onFailed();
    }
  }

  void phoneNumberSignIn({
    required String phoneNumber,
    required Function(User user) loginSuccess,
    required Function(String verificationId) onCodeSent,
    required Function(String code) onCodeAutoRetrievalTimeout,
    required Function(String er) onFailed,
  }) {
    /// The below functions are the callbacks, separated so as to make code more readable
    void verificationCompleted(AuthCredential phoneAuthCredential) async {
      final signIn = await _auth.signInWithCredential(phoneAuthCredential);

      final User user = signIn.user!;
      loginSuccess(user);
    }

    void verificationFailed(FirebaseAuthException error) {
      onFailed(error.message!);
      print(error);
    }

    void codeSent(String verificationId, code) => onCodeSent(verificationId);

    void codeAutoRetrievalTimeout(String verificationId) => onCodeAutoRetrievalTimeout(verificationId);

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  Future<User?> verifyOTP({required String otpCode, required String verificationId}) async {
    String smsCode = otpCode;

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    final phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    try {
      final authSignIn = await _auth.signInWithCredential(phoneAuthCredential);
      return authSignIn.user!;
    } catch (e) {
      return null;
    }
  }

  //Update user & return new Appuser data
  void addDataToDb({
    required User firebaseUser,
    required Function(AppUser? appUser, Tokens? tokens) onSuccess,
    required Function(dynamic er) onError,
  }) async {
    Tokens? tokens;
    AppUser? appUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      mobileNumber: firebaseUser.phoneNumber,
      name: firebaseUser.displayName,
      profilePhoto: firebaseUser.photoURL,
    );

    final userMap = appUser.toMap();
    userMap.removeWhere((key, value) => value == null || value == "");
    // if (appUser.mobileNumber == null) userMap.remove('mobile_number');

    //Register/Update on the server
    await ApiClient.request().post('/auth', data: userMap).then((res) {
      try {
        if (res.data != null) {
          appUser = AppUser.fromMap(res.data["data"]["user"]);
          tokens = Tokens.fromMap(res.data["data"]["tokens"]);
          if (tokens != null) UserPrefs.setTokens(tokens: tokens!);
        }
      } catch (e) {
        onError(catchErrors(e));
        return;
      }
    }).catchError((error) {
      onError(catchErrors(error));
      return;
    });

    //Stop execution if user isn't found
    if (appUser == null) {
      onError("Error occurred");
      return;
    }
    // Register/update on firebase
    try {
      await _userCollection
          .doc(firebaseUser.uid)
          .set(appUser!.toMap())
          .then(
            (value) => onSuccess(appUser, tokens),
          )
          .catchError((error) => onError(error))
          .timeout(Duration(seconds: 20));
    } catch (e) {
      onError(e);
    }
  }

  //Update Address & return new Appuser data
  void updateAddress({
    required String address,
    required address_lat,
    required address_long,
    required String state,
    required Function(AppUser? appUser) onSuccess,
    required Function(dynamic er) onError,
  }) async {
    AppUser appUser = AppUser();
    //Register/Update on the server
    await ApiClient.request().patch('/users/address', data: {
      "address": address,
      "address_lat": address_lat,
      "address_long": address_long,
      "state": state,
    }).then((res) {
      try {
        appUser = AppUser.fromMap(res.data["data"]["user"]);
        //Update on firebase
        try {
          _userCollection.doc(appUser.uid).set(appUser.toMap()).then((value) => {onSuccess(appUser)}).catchError((error) => onError(error)).timeout(Duration(seconds: 5));
        } catch (e) {
          onError(e);
        }
      } catch (e) {
        onError(e);
      }
    }).catchError((error) {
      onError(catchErrors(error));
    });
  }

  void updateUserDetails({
    required AppUser appUser,
    required Function(AppUser? appUser) onSuccess,
    required Function(dynamic er) onError,
  }) async {
    AppUser? u;

    final userMap = appUser.toMap();
    userMap.removeWhere((key, value) => value == null || key == "user_id" || key == "user_level" || key == "created_at" || key == "updated_at");
    //Update on the server
    await ApiClient.request().patch('/users/me', data: userMap).then((res) {
      try {
        u = AppUser.fromMap(res.data["data"]["user"]);
      } catch (e) {
        print(e);
        onSuccess(null);
      }
    }).catchError((error) {
      onError(catchErrors(error));
      return;
    });

    //Update on firebase
    if (u != null) _userCollection.doc(getCurrentUser()!.uid).update(u!.toMap()).then((value) => onSuccess(u)).catchError(onError);
  }

  void signOut() async {
    try {
      // Reset data...
      CoinsController.to.resetBal();
      Get.find<BottomMenuController>().onChangeMenu(BottomMenuItem.HOME);
      //Sign out
      await PrefsAppUser().signOut(); //prefs clear
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    } catch (e) {
      print(e);
    }

    Get.offAll(() => Login());
  }

  void setOnlineStatus({required String uid, required OnlineStatus userState}) {
    _userCollection.doc(uid).update({
      "online_status": EnumToString.convertToString(userState).toLowerCase(),
      "last_login": DateTime.now(),
    });
  }

  //for online/offline presence
  static Stream<DocumentSnapshot> getUserStream({required String uid}) => _userCollection.doc(uid).snapshots();
}
