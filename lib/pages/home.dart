import 'package:flutter/material.dart';
import 'package:prodigy_ad_03/pages/generator.dart';
import 'package:prodigy_ad_03/pages/scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner and Generator"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Scanner())),
              child: const Text("Scan QR Code"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Generator())),
              child: const Text("Generate QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
