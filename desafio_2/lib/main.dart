import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const TarjetaScreen(),
    );
  }
}

class TarjetaScreen extends StatefulWidget {
  const TarjetaScreen({super.key});
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {
  bool _fondoOscuro = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _fondoOscuro ? Colors.grey.shade900 : Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Mi tarjeta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pinimg.com/236x/45/4e/c3/454ec37ed0340614d36c8e1d9c0478dd.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              'Fabrizio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _fondoOscuro ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estudiante de Desarrollo de Aplicaciones Móviles',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fondo oscuro',
                  style: TextStyle(
                    color: _fondoOscuro ? Colors.white : Colors.black,
                  ),
                ),
                Switch(
                  value: _fondoOscuro,
                  onChanged: (val) => setState(() => _fondoOscuro = val),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Hola!')),
                );
              },
              child: const Text('Saludar'),
            ),
          ],
        ),
      ),
    );
  }
}
