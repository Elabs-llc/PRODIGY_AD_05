import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  _GeneratorState createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  var code = '';
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate QR Code"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(35),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextFormField(
                      controller: title,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: ' Code ',
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.indigo,
                  onPressed: () {
                    setState(() {
                      code = title.text;
                    });
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                code == ''
                    ? Text('')
                    : BarcodeWidget(
                        barcode: Barcode.qrCode(
                          errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                        ),
                        data: code,
                        width: 200,
                        height: 200,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
