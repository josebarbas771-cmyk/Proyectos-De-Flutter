import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
Future<String?> registrar(String email, String password) async {
  try {
    await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return null;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este email ya está registrado.';
      case 'invalid-email':
        return 'El formato del email no es válido.';
      default:
        return 'Error al registrarse: ${e.message}';
    }
  }
}
Future<String?> iniciarSesion(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return null;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'user-disabled':
        return 'Esta cuenta fue deshabilitada.';
      default:
        return 'Error al iniciar sesión.';
    }
  }
}

Future<void> cerrarSesion() async => await auth.signOut();

Future<void> agregarTarea(String titulo) async {
  try {
    final docRef = await db.collection('tareas').add({
      'titulo': titulo,
      'completada': false,
      'prioridad': 'normal',
      'fechaCreacion': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
    print('Tarea creada con ID: ${docRef.id}');
  } catch (e) {
    print('Error al crear tarea: $e');
  }
}
Future<void> actualizarTarea(String docId, bool completada) async {
  await db.collection('tareas').doc(docId).update({
    'completada': completada,
    'fechaCompletado': completada ? FieldValue.serverTimestamp() : null,
  });
}
Future<void> eliminarTarea(String docId) async {
  await db.collection('tareas').doc(docId).delete();
}
