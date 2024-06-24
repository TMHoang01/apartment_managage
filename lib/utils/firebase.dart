import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';

FirebaseAuth firebaseAuth = sl<FirebaseAuth>();
FirebaseFirestore firestore = sl<FirebaseFirestore>();
FirebaseStorage storage = sl<FirebaseStorage>();

// Collection refs
CollectionReference usersRef = firestore.collection('users');
CollectionReference categoryRef = firestore.collection("categories");
CollectionReference productRef = firestore.collection('products');
CollectionReference cartRef = firestore.collection('carts');
CollectionReference orderRef = firestore.collection('orders');
CollectionReference inforContactRef = firestore.collection('inforContacts');
CollectionReference serviceRef = firestore.collection('services');
CollectionReference feedBackRef = firestore.collection('feedbacks');

late UserModel? userCurrent;

FirebaseMessaging fMessaging = sl<FirebaseMessaging>();

Future<void> geFireBaseMessaging() async {
  // await fMessaging.requestPermission();
  NotificationSettings settings = await fMessaging.requestPermission(
      // alert: true,
      // announcement: false,
      // badge: true,
      // carPlay: false,
      // criticalAlert: false,
      // provisional: false,
      // sound: true,
      );

  logger.d('User granted permission: ${settings.authorizationStatus}');

  await fMessaging.getToken().then((value) {
    if (value != null) {
      logger.d('Token: $value');
    }
  });
}
