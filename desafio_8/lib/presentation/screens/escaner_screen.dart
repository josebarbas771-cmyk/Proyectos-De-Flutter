import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/services/asistencia_service.dart';
import '../../data/services/notification_service.dart';

class EscanerScreen extends StatefulWidget {
  const EscanerScreen({super.key});

  @override
  State<EscanerScreen> createState() => _EscanerScreenState();
}

class _EscanerScreenState extends State<EscanerScreen> {
  String? _resultado;
  bool _fueNuevo = true;
  bool _activo = true;

  final MobileScannerController _ctrl = MobileScannerController();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _procesarCodigo(String codigo) async {
    if (!_activo) return;

    setState(() {
      _activo = false;
    });
    _ctrl.stop();
    final bool nuevo = await registrarAsistencia(codigo);

    if (nuevo) {
      setState(() {
        _fueNuevo = true;
        _resultado = '$codigo — asistencia registrada';
      });
    } else {
      setState(() {
        _fueNuevo = false;
        _resultado = '$codigo ya estaba registrado hoy';
      });
      NotificationService.mostrar(
        titulo: 'Asistencia ya registrada',
        cuerpo: '$codigo ya fue registrado hoy',
        payload: codigo,
      );
    }
  }

  void _escanearDeNuevo() {
    setState(() {
      _resultado = null;
      _activo = true;
    });
    _ctrl.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _ctrl.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _ctrl,
              onDetect: (BarcodeCapture capture) {
                if (capture.barcodes.isNotEmpty) {
                  final codigo = capture.barcodes.first.rawValue;
                  if (codigo != null) _procesarCodigo(codigo);
                }
              },
            ),
          ),
          if (_resultado != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _fueNuevo ? Colors.green.shade50 : Colors.orange.shade50,
              child: Column(
                children: [
                  Icon(
                    _fueNuevo ? Icons.check_circle : Icons.warning,
                    color: _fueNuevo ? Colors.green : Colors.orange,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _resultado!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _escanearDeNuevo,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear otro código'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
