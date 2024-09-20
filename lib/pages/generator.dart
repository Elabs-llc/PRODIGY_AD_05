import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Generator"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (urlController.text.isNotEmpty)
                QrImageView(
                  data: urlController.text,
                  size: 200.0,
                ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: const TextStyle(),
                  decoration: InputDecoration(
                      label: const Text("Enter your text"),
                      hintText: "Enter text here...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() {}),
                child: const Text("Generate QR Code"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
