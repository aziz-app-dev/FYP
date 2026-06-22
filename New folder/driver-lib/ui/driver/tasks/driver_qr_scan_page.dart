import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DriverQrScanPage extends StatefulWidget {
  const DriverQrScanPage({super.key});

  @override
  State<DriverQrScanPage> createState() => _DriverQrScanPageState();
}

class _DriverQrScanPageState extends State<DriverQrScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.trim().isEmpty) return;

    final code = _extractCode(raw);
    if (code == null) return;

    _handled = true;
    _controller.stop();
    Navigator.of(context).pop(code);
  }

  String? _extractCode(String raw) {
    final upper = raw.trim().toUpperCase();
    if (upper.startsWith('ORD-')) return upper;
    final match = RegExp(r'ORD-[A-Z0-9]+').firstMatch(upper);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Delivery QR')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Text(
              'Scan the customer order QR before marking delivery complete.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
