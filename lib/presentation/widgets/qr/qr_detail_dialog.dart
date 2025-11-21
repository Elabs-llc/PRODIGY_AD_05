import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../data/models/qr_code_model.dart';

class QRDetailDialog extends StatelessWidget {
  final QRCodeModel qrCode;

  const QRDetailDialog({
    super.key,
    required this.qrCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: qrCode.data,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: qrCode.customization != null
                      ? Color(qrCode.customization!['backgroundColor'] ?? 0xFFFFFFFF)
                      : Colors.white,
                  foregroundColor: qrCode.color != null
                      ? Color(qrCode.color!)
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Type
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(qrCode.type.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    qrCode.type.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              if (qrCode.title != null) ...[
                const SizedBox(height: 12),
                Text(
                  qrCode.title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 16),

              // Data
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: SelectableText(
                  qrCode.data,
                  style: theme.textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 16),

              // Metadata
              _InfoRow(
                icon: Icons.access_time,
                label: 'Created',
                value: dateFormat.format(qrCode.createdAt),
              ),

              if (qrCode.scannedAt != null)
                _InfoRow(
                  icon: Icons.qr_code_scanner,
                  label: 'Scanned',
                  value: dateFormat.format(qrCode.scannedAt!),
                ),

              _InfoRow(
                icon: Icons.source,
                label: 'Source',
                value: qrCode.isGenerated ? 'Generated' : 'Scanned',
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: qrCode.data));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Share.share(qrCode.data);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),

              if (qrCode.type == QRCodeType.url) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(qrCode.data);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open Link'),
                  ),
                ),
              ],

              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
