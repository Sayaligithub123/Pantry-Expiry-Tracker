import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'manual_entry.dart';

class BarcodeScannerScreen extends StatefulWidget {
  static const routeName = '/scanner';

  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (scanned) return;
    final barcode = capture.barcodes.first.rawValue;
    if (barcode == null) return;

    scanned = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Barcode Detected"),
        content: Text(barcode),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              scanned = false;
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("Use"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ManualEntryScreen(initialBarcode: barcode),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}
