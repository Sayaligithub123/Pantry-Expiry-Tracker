import 'package:flutter/material.dart';
import 'barcode.dart';
import 'manual_entry.dart';
import 'saved_products_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Pantry')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _HomeCard(
              icon: Icons.qr_code_scanner,
              title: "Scan Barcode",
              subtitle: "Use camera to scan product",
              onTap: () {
                Navigator.pushNamed(context, BarcodeScannerScreen.routeName);
              },
            ),
            _HomeCard(
              icon: Icons.edit_note,
              title: "Manual Entry",
              subtitle: "Add product manually",
              onTap: () {
                Navigator.pushNamed(context, ManualEntryScreen.routeName);
              },
            ),
            _HomeCard(
              icon: Icons.list_alt,
              title: "Saved Products",
              subtitle: "View and track your items",
              onTap: () {
                Navigator.pushNamed(context, SavedProductsScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 36),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
