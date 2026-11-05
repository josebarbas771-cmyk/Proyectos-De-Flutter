import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
class Tarea {
  final String titulo;
  final bool completada;

  const Tarea({required this.titulo, this.completada = false});

  Tarea copyWith({bool? completada}) {
    return Tarea(
      titulo: titulo,
      completada: completada ?? this.completada,
    );
  }
}
class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  int get completadas => tareas.where((t) => t.completada).length;
  int get pendientes => tareas.length - completadas;
}
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  void agregar(String titulo) {
    state = TasksState(
      tareas: [...state.tareas, Tarea(titulo: titulo)],
    );
  }

  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(tareas: nuevas);
  }

  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];
    nuevas[indice] = nuevas[indice].copyWith(
      completada: !nuevas[indice].completada,
    );
    state = TasksState(tareas: nuevas);
  }
}
final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _seccion = 0;
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    final List<Widget> pantallas = [
      const InicioScreen(),
      const TareasScreen(),
      const PerfilScreen(),
    ];

    final List<String> titulos = [
      'Inicio',
      'Tareas — ${state.pendientes} pendientes',
      'Perfil',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titulos[_seccion])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Andrada',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Fabrizioandrada@gmail.com',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              selected: _seccion == 0,
              onTap: () {
                setState(() => _seccion = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.task_alt),
              title: Text('Mis Tareas'),
              selected: _seccion == 1,
              onTap: () {
                setState(() => _seccion = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              selected: _seccion == 2,
              onTap: () {
                setState(() => _seccion = 2);
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: pantallas[_seccion],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int indice) {
          setState(() => _seccion = indice);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Tareas pendientes', style: TextStyle(fontSize: 18)),
          Text(
            '${state.pendientes}',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          Text(
            'de ${state.tareas.length} en total',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _ctrl = TextEditingController();
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _agregar() {
    final String texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    ref.read(tasksProvider.notifier).agregar(texto);
    _ctrl.clear();
  }

 
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: InputDecoration(
                    labelText: 'Nueva tarea',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _agregar,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.tareas.length,
            itemBuilder: (ctx, i) {
              final tarea = state.tareas[i];
              return ListTile(
                leading: Checkbox(
                  value: tarea.completada,
                  onChanged: (bool? valor) {
                    ref.read(tasksProvider.notifier).toggleCompletada(i);
                  },
                ),
                title: Text(
                  tarea.titulo,
                  style: TextStyle(
                    decoration: tarea.completada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(tasksProvider.notifier).eliminar(i);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Fabrizio',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text('tu@email.com', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
