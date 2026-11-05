import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modoOscuro = false;

  void _cambiarModo(bool valor) {
    setState(() => _modoOscuro = valor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        modoOscuro: _modoOscuro,
        onCambiarModo: _cambiarModo,
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) onCambiarModo;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.onCambiarModo,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final List<Widget> pantallas = [
      const InicioScreen(),
      const TareasScreen(),
      const PerfilScreen(),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
        backgroundColor: cs.primaryContainer,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Fabrizio',
                    style: TextStyle(color: cs.onPrimary, fontSize: 16),
                  ),
                  Text(
                    'tu@email.com',
                    style: TextStyle(color: cs.onPrimary, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _seccion == 0,
              selectedTileColor: cs.primaryContainer,
              onTap: () {
                setState(() => _seccion = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              selected: _seccion == 1,
              selectedTileColor: cs.primaryContainer,
              onTap: () {
                setState(() => _seccion = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 2,
              selectedTileColor: cs.primaryContainer,
              onTap: () {
                setState(() => _seccion = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfiguracionScreen(
                      modoOscuroInicial: widget.modoOscuro,
                      onCambiarModo: widget.onCambiarModo,
                    ),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
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
      floatingActionButton: _seccion == 1
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nueva tarea')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bienvenido a tu app de tareas',
                  style: TextStyle(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _estadistica(cs, '3', 'Tareas'),
              _estadistica(cs, '2', 'Pendientes'),
              _estadistica(cs, '31', 'Completadas'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _estadistica(ColorScheme cs, String numero, String etiqueta) {
    return Column(
      children: [
        Text(
          numero,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        Text(etiqueta, style: TextStyle(color: cs.onSurface)),
      ],
    );
  }
}
class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final List<String> tareas = [
      'Estudiar matematicas',
      'Practicar widgets',
      'Entregar el desafío',
      'Subir tarea',
      'Leer documentación',
    ];

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.primary,
            child: Text(
              '${index + 1}',
              style: TextStyle(color: cs.onPrimary),
            ),
          ),
          title: Text(
            tareas[index],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Descripción de la tarea ${index + 1}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        );
      },
    );
  }
}
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            'Andrada',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('Fabrizioandrada@gmail.com', style: TextStyle(color: cs.onSurface)),
        ],
      ),
    );
  }
}
class ConfiguracionScreen extends StatefulWidget {
  final bool modoOscuroInicial;
  final Function(bool) onCambiarModo;

  const ConfiguracionScreen({
    super.key,
    required this.modoOscuroInicial,
    required this.onCambiarModo,
  });
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  late bool _oscuro;

  @override
  void initState() {
    super.initState();
    _oscuro = widget.modoOscuroInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambia entre tema claro y oscuro'),
            value: _oscuro,
            onChanged: (bool nuevoValor) {
              setState(() => _oscuro = nuevoValor);
              widget.onCambiarModo(nuevoValor);
            },
          ),
        ],
      ),
    );
  }
}