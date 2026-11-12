import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/user.dart';
import 'services/user_service.dart';
import 'widgets/futuro_view.dart';
import 'widgets/user_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON desde cero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
const String kJsonEjemplo = '''
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "city": "Gwenborough",
    "zipcode": "92998-3874"
  }
}
''';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = UserService();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('JSON desde cero'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'JSON local'),
              Tab(text: 'Usuario 1'),
              Tab(text: 'Lista'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const _JsonLocalTab(),
            FuturoView<User>(
              cargar: () => service.fetchUser(1),
              builder: (context, user) => ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [UserCard(user: user)],
              ),
            ),
            FuturoView<List<User>>(
              cargar: service.fetchUsers,
              builder: (context, users) => ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: users.length,
                itemBuilder: (context, i) => UserCard(user: users[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JsonLocalTab extends StatelessWidget {
  const _JsonLocalTab();

  @override
  Widget build(BuildContext context) {
    // 1) String → Map   2) Map → User
    final Map<String, dynamic> mapa =
        jsonDecode(kJsonEjemplo) as Map<String, dynamic>;
    final User user = User.fromJson(mapa);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('JSON original', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            kJsonEjemplo.trim(),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        Text('Objeto User resultante',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        UserCard(user: user),
      ],
    );
  }
}
