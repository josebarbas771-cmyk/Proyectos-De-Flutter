import 'package:flutter/material.dart';
import '../../data/local/local_database.dart';
import '../../domain/entities/tarea.dart';
import 'configuracion_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final LocalDatabase _db = LocalDatabase();
  final TextEditingController _ctrl = TextEditingController();
  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final lista = await _db.obtenerTodas();
    setState(() {
      _tareas = lista;
    });
  }

  Future<void> _agregar() async {
    final String titulo = _ctrl.text.trim();
    if (titulo.isEmpty) return;

    await _db.insertar(
      Tarea(titulo: titulo, fecha: DateTime.now().toString()),
    );
    _ctrl.clear();
    _cargar();
  }

  Future<void> _toggle(Tarea tarea) async {
    await _db.actualizar(tarea.copyWith(completada: !tarea.completada));
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfiguracionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
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
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tareas.isEmpty
                ? const Center(child: Text('Todavía no hay tareas'))
                : ListView.builder(
                    itemCount: _tareas.length,
                    itemBuilder: (context, index) {
                      final Tarea tarea = _tareas[index];

                      return Dismissible(
                        key: Key('${tarea.id}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final int id = tarea.id!;
                          setState(() {
                            _tareas.removeAt(index);
                          });
                          _db.eliminar(id);
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: (bool? valor) {
                              _toggle(tarea);
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
