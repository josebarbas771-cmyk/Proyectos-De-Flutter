import 'package:flutter/material.dart';

import '../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text('${user.id}')),
        title: Text(user.name),
        subtitle: Text(
          '@${user.username}\n'
          '${user.email}\n'
          '${user.address.city} (${user.address.zipcode})',
        ),
        isThreeLine: true,
      ),
    );
  }
}
