import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ddd_sample/domain/auth/i_auth_facade.dart';
import 'package:ddd_sample/domain/core/errors.dart';
import 'package:ddd_sample/injection.dart';
import 'package:firebase_core/firebase_core.dart';

extension FirebaseFirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance.collection('users').doc(user.uid);
  }
}
