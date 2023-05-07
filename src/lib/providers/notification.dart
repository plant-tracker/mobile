import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod/riverpod.dart';

import 'package:plant_tracker/models/notification.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final notificationProvider = Provider<FlutterLocalNotificationsPlugin>((ref) {
  final plugin = FlutterLocalNotificationsPlugin();
  final initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  plugin.initialize(initializationSettings);
  return plugin;
});

final notificationStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot<NotificationData>>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final notificationsCollection = firestore
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .withConverter<NotificationData>(
        fromFirestore: (snapshot, _) =>
            NotificationData.fromFirestore(snapshot),
        toFirestore: (notification, _) => notification.toMap(),
      );

  return notificationsCollection
      .orderBy('createdAt', descending: true)
      .snapshots();
});

final notificationHandlerProvider = Provider<Function>((ref) {
  return (QuerySnapshot<NotificationData> snapshot) async {
    final notificationPlugin = ref.read(notificationProvider);
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        final notification = change.doc.data();
        if (notification != null) {
          final title = notification.title;
          final body = notification.body;
          final androidDetails = AndroidNotificationDetails(
              "plant_tracker", "Plant Tracker",
              channelDescription:
                  "Notifications related to your plant tracking activities",
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
          final platformDetails = NotificationDetails(
            android: androidDetails,
          );
          await notificationPlugin.show(
            0,
            title,
            body,
            platformDetails,
          );
        }
      }
    }
  };
});

final currentUserNotificationsProvider =
    StreamProvider.autoDispose<List<NotificationData>>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final notificationsCollection = firestore
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .withConverter<NotificationData>(
        fromFirestore: (snapshot, _) =>
            NotificationData.fromFirestore(snapshot),
        toFirestore: (notification, _) => notification.toMap(),
      );

  return notificationsCollection
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

final deleteNotificationProvider = FutureProvider.autoDispose
    .family<void, String>((ref, notificationId) async {
  final auth = FirebaseAuth.instance;
  final firestore = ref.read(firebaseFirestoreProvider);
  final user = auth.currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }
  final notificationRef = firestore
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .doc(notificationId);
  await notificationRef.delete();
});
