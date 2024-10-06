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
      backgroundColor: const Color.fromARGB(255, 1, 23, 34),
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: const Color.fromARGB(255, 0, 7, 10),
        title: const Text(
          "QR Code Scanner and Generator",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/qrimage.jpg"),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(221, 0, 0, 0))),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Scanner())),
                child: Text(
                  "Scan QR Code",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(221, 0, 0, 0))),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Generator())),
                child: const Text(
                  "Generate QR Code",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
