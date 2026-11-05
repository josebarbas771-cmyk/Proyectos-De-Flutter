import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
String _dos(int n) => n < 10 ? '0$n' : '$n';
String fechaDeHoy() {
  final ahora = DateTime.now();
  return '${ahora.year}-${_dos(ahora.month)}-${_dos(ahora.day)}';

String horaActual() {
  final ahora = DateTime.now();
  return '${_dos(ahora.hour)}:${_dos(ahora.minute)}';
}
Future<bool> registrarAsistencia(String nombre) async {
  final String hoy = fechaDeHoy();

  final existentes = await db
      .collection('asistencias')
      .where('nombre', isEqualTo: nombre)
      .where('fecha', isEqualTo: hoy)
      .get();

  if (existentes.docs.isEmpty) {
    await db.collection('asistencias').add({
      'nombre': nombre,
      'fecha': hoy,
      'hora': horaActual(),
    });
    return true;
  }

  return false;
}
Future<void> limpiarAsistenciasDeHoy() async {
  final consulta = await db
      .collection('asistencias')
      .where('fecha', isEqualTo: fechaDeHoy())
      .get();

  for (var doc in consulta.docs) {
    await db.collection('asistencias').doc(doc.id).delete();
  }
}
