import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/post_service.dart';
import '../../domain/entities/post.dart';

class DetailScreen extends StatelessWidget {
  final int postId;

  const DetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post #$postId')),
      body: FutureBuilder<Post>(
        future: PostService().fetchPost(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          final post = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(post.titulo,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Usuario ${post.usuarioId}',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 16),
              Text(post.cuerpo, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ],
          );
        },
      ),
    );
  }
}
