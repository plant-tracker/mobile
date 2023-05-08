import 'package:flutter/material.dart';
import 'package:plant_tracker/models/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/providers/notification.dart';
import 'package:plant_tracker/widgets/notification_card.dart';

class NotificationList extends ConsumerWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(currentUserNotificationsProvider);

    return notificationsAsyncValue.when(
      data: (notifications) {
        if (notifications == null || notifications.isEmpty) {
          return const Center(
            child: Text('You have no notifications.'),
          );
        }
        return SizedBox(
  height: 500,
  child: ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                notification: notification,
                onDelete: () {
                  ref.read(deleteNotificationProvider(notification.id));
                },
              );
            },
          )
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Center(
        child: Text('Error loading notifications'),
      ),
    );
  }
}
