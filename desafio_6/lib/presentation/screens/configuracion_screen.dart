import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('preferencias');

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, caja, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Modo oscuro'),
                subtitle: const Text('Cambia el tema de toda la app'),
                value: caja.get('modoOscuro', defaultValue: false),
                onChanged: (bool nuevoValor) {
                  box.put('modoOscuro', nuevoValor);
                },
              ),
              SwitchListTile(
                title: const Text('Notificaciones'),
                subtitle: const Text('Recibir avisos de la app'),
                value: caja.get('notificaciones', defaultValue: true),
                onChanged: (bool nuevoValor) {
                  box.put('notificaciones', nuevoValor);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
