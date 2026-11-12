import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/post_service.dart';
import '../../domain/entities/post.dart';

class PostsScreen extends StatefulWidget {
  final String search;

  const PostsScreen({super.key, this.search = ''});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _future;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _future = PostService().fetchPosts();
    _controller = TextEditingController(text: widget.search);
  }

  @override
  void didUpdateWidget(covariant PostsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.search != widget.search &&
        _controller.text != widget.search) {
      _controller.text = widget.search;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _buscar(String texto) {
    final q = texto.trim();
    if (q.isEmpty) {
      context.go('/posts');
    } else {
      context.go(Uri(path: '/posts', queryParameters: {'search': q}).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: _buscar,
              decoration: InputDecoration(
                hintText: 'Buscar por título…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.search.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.go('/posts');
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${snapshot.error}', textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => setState(() {
                              _future = PostService().fetchPosts();
                            }),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final q = widget.search.toLowerCase();
                final posts = (snapshot.data ?? [])
                    .where((p) => p.titulo.toLowerCase().contains(q))
                    .toList();

                if (posts.isEmpty) {
                  return Center(
                    child: Text('Sin resultados para "${widget.search}"'),
                  );
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    final post = posts[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(post.titulo,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(post.cuerpo,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
            
                      onTap: () => context.push('/posts/${post.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
