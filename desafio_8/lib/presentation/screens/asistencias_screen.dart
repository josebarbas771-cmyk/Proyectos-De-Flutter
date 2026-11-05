import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/asistencia_service.dart';

class AsistenciasScreen extends StatelessWidget {
  const AsistenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistencias de hoy')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('asistencias')
                  .where('fecha', isEqualTo: fechaDeHoy())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Todavía no hay asistencias hoy'),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(child: Text('${i + 1}')),
                      title: Text(data['nombre']),
                      subtitle: Text('Hora: ${data['hora']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await limpiarAsistenciasDeHoy();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro del día eliminado')),
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('Limpiar registro del día'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
