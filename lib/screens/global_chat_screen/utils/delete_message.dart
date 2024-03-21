import 'package:flutter/material.dart';

import '../../../main.dart';

void deleteMessage(BuildContext context, String id) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              fireStore.collection('globalChats').doc(id).update({
                'isDeleted': true,
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message deleted'),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
