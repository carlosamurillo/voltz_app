import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/auth/user_data_model.dart';

class AuthViewModel extends ChangeNotifier {
  late UserSignStatus userStatus;
  late UserData signedUserData;

  void init() {
    userStatus = UserSignStatus.none;
    signedUserData = UserData.initial();
    verifiySignedInUser();
  }

  Future<void> verifiySignedInUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      verifyUserRegister(user.uid);
    } else {
      userStatus = UserSignStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> verifyUserRegister(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      signedUserData = UserData.fromJson(userDoc.data() as Map<String, dynamic>);
      print("*luis  autenticado, enviar a usuario al overview");
      userStatus = UserSignStatus.authenticated;
    } else {
      print("*luis  no autenticado, indicar al usuario que puede registrarse ");
      userStatus = UserSignStatus.pendingToRegister;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    userStatus = UserSignStatus.unauthenticated;
    notifyListeners();
  }
}

enum UserSignStatus { authenticated, pendingToRegister, anonymous, unauthenticated, none }
