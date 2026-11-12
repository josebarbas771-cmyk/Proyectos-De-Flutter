import 'package:flutter/material.dart';

import '../auth/auth_notifier.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: tema.colorScheme.primaryContainer,
              child: Icon(Icons.person,
                  size: 56, color: tema.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 16),
            Text(authNotifier.usuario ?? '', style: tema.textTheme.titleLarge),
            const SizedBox(height: 24),
            FilledButton.icon(
          
              onPressed: authNotifier.logout,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
