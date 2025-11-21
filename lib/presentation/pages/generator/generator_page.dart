import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/logging/app_logger.dart';
import '../../../core/utils/qr_validator.dart';
import '../../../data/models/qr_code_model.dart';
import '../../providers/qr_provider.dart';

class GeneratorPage extends ConsumerStatefulWidget {
  const GeneratorPage({super.key});

  @override
  ConsumerState<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends ConsumerState<GeneratorPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  String? _generatedData;
  Color _qrColor = Colors.black;
  Color _backgroundColor = Colors.white;

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _generateQRCode() {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      _showSnackBar('Please enter some text', isError: true);
      return;
    }

    // Validate
    final validation = QRValidator.validate(text);

    if (!validation.isValid) {
      _showSnackBar(validation.message ?? 'Invalid data', isError: true);
      return;
    }

    if (validation.severity == ValidationSeverity.warning) {
      _showSnackBar(validation.message!, isWarning: true);
    }

    setState(() {
      _generatedData = text;
    });

    // Save to history
    final qrCode = QRCodeModel.fromGenerated(
      text,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      color: _qrColor.value,
      customization: {
        'backgroundColor': _backgroundColor.value,
      },
    );

    ref.read(qrProvider.notifier).saveQRCode(qrCode);

    _showSnackBar('QR Code generated successfully');
  }

  Future<void> _shareQRCode() async {
    if (_generatedData == null) return;

    try {
      final image = await _captureQRCode();
      if (image == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/qr_code.png');
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: _generatedData,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to share QR code', e, stackTrace);
      _showSnackBar('Failed to share QR code', isError: true);
    }
  }

  Future<void> _saveQRCode() async {
    if (_generatedData == null) return;

    try {
      final image = await _captureQRCode();
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/qr_code_$timestamp.png');
      await file.writeAsBytes(image);

      _showSnackBar('QR Code saved to ${file.path}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save QR code', e, stackTrace);
      _showSnackBar('Failed to save QR code', isError: true);
    }
  }

  Future<Uint8List?> _captureQRCode() async {
    try {
      final RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to capture QR code', e, stackTrace);
      return null;
    }
  }

  void _copyToClipboard() {
    if (_generatedData == null) return;
    Clipboard.setData(ClipboardData(text: _generatedData!));
    _showSnackBar('Copied to clipboard');
  }

  void _showSnackBar(String message, {bool isError = false, bool isWarning = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Colors.red
            : isWarning
                ? Colors.orange
                : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (Optional)',
                hintText: 'Enter a title for this QR code',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),

            // Data input
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter text, URL, or other data',
                prefixIcon: Icon(Icons.qr_code),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Color customization
            Text(
              'Customization',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ColorPicker(
                    label: 'QR Color',
                    color: _qrColor,
                    onColorChanged: (color) {
                      setState(() => _qrColor = color);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ColorPicker(
                    label: 'Background',
                    color: _backgroundColor,
                    onColorChanged: (color) {
                      setState(() => _backgroundColor = color);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Generate button
            ElevatedButton.icon(
              onPressed: _generateQRCode,
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Generate QR Code'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            // Generated QR Code
            if (_generatedData != null) ...[
              const SizedBox(height: 32),
              Text(
                'Generated QR Code',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: RepaintBoundary(
                    key: _qrKey,
                    child: QrImageView(
                      data: _generatedData!,
                      version: QrVersions.auto,
                      size: 280,
                      backgroundColor: _backgroundColor,
                      foregroundColor: _qrColor,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareQRCode,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveQRCode,
                  icon: const Icon(Icons.download),
                  label: const Text('Save to Device'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _ColorPicker({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            final isSelected = c == color;
            return GestureDetector(
              onTap: () => onColorChanged(c),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
