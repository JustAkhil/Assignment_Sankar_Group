import 'dart:async';

import 'package:assignment_sankar_group/models/task_model.dart';
import 'package:assignment_sankar_group/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRepository {
  FirebaseRepository._();

  static FirebaseRepository getInstance() => FirebaseRepository._();
  static final fireAuth = FirebaseAuth.instance;
  static final fireStore = FirebaseFirestore.instance;
  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_TASKS = "tasks";
  static const String PREFS_USER_ID_KEY = "userId";

  Future<void> createUser({
    required UserModel user,
    required String pass,
  }) async {
    try {
      UserCredential userCred = await fireAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: pass,
      );
      if (userCred.user != null) {
        await fireStore
            .collection(COLLECTION_USERS)
            .doc(userCred.user!.uid)
            .set(user.toDoc())
            .catchError((error) {
              throw Exception("Failed to add user: $error");
            });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        throw "Email already exists";
      } else if (e.code == 'invalid-email') {
        throw "Invalid Email";
      } else {
        throw e.message ?? "Signup failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> loginUser({required String email, required String pass}) async {
    try {
      UserCredential userCred = await fireAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (userCred.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PREFS_USER_ID_KEY, userCred.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw "Invalid email or password";
      } else if (e.code == 'invalid-email') {
        throw "Invalid email format";
      } else if (e.code == 'user-disabled') {
        throw "Account disabled";
      } else if (e.code == 'too-many-requests') {
        throw "Too many attempts. Try later";
      } else {
        throw "Login failed. Try again";
      }
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTask() {
    String uid = fireAuth.currentUser!.uid;

    return fireStore
        .collection(COLLECTION_USERS)
        .doc(uid)
        .collection(COLLECTION_TASKS)
        .snapshots();
  }

  Future<void> addTask({required TaskModel task}) async {
    String taskId = DateTime.now().millisecondsSinceEpoch.toString();
    String uid = fireAuth.currentUser!.uid;
    await fireStore
        .collection(COLLECTION_USERS)
        .doc(uid)
        .collection(COLLECTION_TASKS)
        .doc(taskId)
        .set(task.toDoc());
  }

  Future<void> deleteTask({required String taskId}) async {
    String uid = fireAuth.currentUser!.uid;
    await fireStore
        .collection(COLLECTION_USERS)
        .doc(uid)
        .collection(COLLECTION_TASKS)
        .doc(taskId)
        .delete();
  }

  Future<void> updateTask({
    required TaskModel task,
    required String taskId,
  }) async {
    String uid = fireAuth.currentUser!.uid;
    await fireStore
        .collection(COLLECTION_USERS)
        .doc(uid)
        .collection(COLLECTION_TASKS)
        .doc(taskId)
        .update(task.toDoc());
  }
}
