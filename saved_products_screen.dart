import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global.dart';

class SavedProductsScreen extends StatefulWidget {
  static const routeName = '/saved-products';

  const SavedProductsScreen({super.key});

  @override
  State<SavedProductsScreen> createState() => _SavedProductsScreenState();
}

class _SavedProductsScreenState extends State<SavedProductsScreen> {
  bool _loading = true;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (globalUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      setState(() => _loading = false);
      return;
    }

    final url =
        Uri.parse("http://localhost:5000/api/products/list/$globalUserId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _products = data;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load products")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }
  }

  Color _getColorForExpiry(String expiryIso) {
    final expiry = DateTime.parse(expiryIso);
    final now = DateTime.now();
    final daysLeft = expiry.difference(now).inDays;

    if (daysLeft < 0) {
      return Colors.red.shade300; // expired
    } else if (daysLeft <= 3) {
      return Colors.orange.shade300; // very soon
    } else if (daysLeft <= 7) {
      return Colors.yellow.shade300; // within a week
    } else {
      return Colors.green.shade300; // safe
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text("No products yet"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _products.length,
                  itemBuilder: (ctx, i) {
                    final item = _products[i];
                    final name = item["name"] ?? "";
                    final barcode = item["barcode"] ?? "";
                    final expiryIso = item["expiryDate"];
                    final expiryDate = DateTime.parse(expiryIso);

                    final color = _getColorForExpiry(expiryIso);

                    return Card(
                      color: color,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: Text(name),
                        subtitle: Text(
                          "Expiry: ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}"
                          "${barcode.isNotEmpty ? "\nBarcode: $barcode" : ""}",
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
