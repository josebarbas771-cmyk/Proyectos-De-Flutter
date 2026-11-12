import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_notifier.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¡Hola, ${authNotifier.usuario ?? 'invitado'}!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
          
              FilledButton.icon(
                onPressed: () => context.go('/posts'),
                icon: const Icon(Icons.article),
                label: const Text('Ver posts (context.go)'),
              ),
              const SizedBox(height: 12),
            
              OutlinedButton.icon(
                onPressed: () => context.push('/posts/1'),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Abrir post 1 (context.push)'),
              ),
              const SizedBox(height: 12),
            
              OutlinedButton.icon(
                onPressed: () => context.go('/posts?search=qui'),
                icon: const Icon(Icons.search),
                label: const Text('Buscar "qui" (/posts?search=qui)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
