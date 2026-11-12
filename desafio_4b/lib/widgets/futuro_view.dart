import 'package:flutter/material.dart';

class FuturoView<T> extends StatefulWidget {
  final Future<T> Function() cargar;
  final Widget Function(BuildContext context, T datos) builder;

  const FuturoView({super.key, required this.cargar, required this.builder});

  @override
  State<FuturoView<T>> createState() => _FuturoViewState<T>();
}

class _FuturoViewState<T> extends State<FuturoView<T>>
    with AutomaticKeepAliveClientMixin {
  late Future<T> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.cargar();
  }

  void _reintentar() {
    setState(() {
      _future = widget.cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<T>(
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _reintentar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        return widget.builder(context, snapshot.data as T);
      },
    );
  }
}
