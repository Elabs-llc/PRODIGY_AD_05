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
  TextEditingController status = TextEditingController();
  var code = '';
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 137, 212, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 7, 10),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Generate QR Code",
          style: TextStyle(color: Colors.white),
        ),
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
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: title,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Enter your text... ',
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  color: const Color.fromARGB(255, 1, 23, 34),
                  padding: EdgeInsets.all(10.0),
                  elevation: 10.0,
                  onPressed: () {
                    setState(() {
                      if (title.text.isEmpty) {
                        code = '';
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Please enter your text to generate QR code"),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        code = title.text;
                        status.text = "Scan QR Code to view the content";
                        title.clear();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("QR code generatored"),
                          backgroundColor:
                              const Color.fromARGB(255, 54, 244, 165),
                        ));
                      }
                    });
                  },
                  child: Text(
                    "Generate QR Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
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
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  controller: status,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
