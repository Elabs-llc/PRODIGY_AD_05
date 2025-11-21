import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../data/models/qr_code_model.dart';
import '../../providers/qr_provider.dart';
import '../../widgets/qr/qr_detail_dialog.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<QRCodeModel> _filteredCodes = [];
  bool _showFavoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchQRCodes(String query) async {
    if (query.isEmpty && !_showFavoritesOnly) {
      setState(() => _filteredCodes = []);
      return;
    }

    final notifier = ref.read(qrProvider.notifier);

    if (_showFavoritesOnly) {
      final favorites = await notifier.getFavorites();
      setState(() {
        _filteredCodes = query.isEmpty
            ? favorites
            : favorites
                .where((code) =>
                    code.data.toLowerCase().contains(query.toLowerCase()))
                .toList();
      });
    } else {
      final results = await notifier.searchQRCodes(query);
      setState(() => _filteredCodes = results);
    }
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all QR code history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(qrProvider.notifier).clearHistory();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('History cleared')),
        );
        setState(() => _filteredCodes = []);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrState = ref.watch(qrProvider);
    final theme = Theme.of(context);

    final displayedCodes = _filteredCodes.isEmpty && _searchController.text.isEmpty && !_showFavoritesOnly
        ? qrState.qrCodes
        : _filteredCodes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() => _showFavoritesOnly = !_showFavoritesOnly);
              _searchQRCodes(_searchController.text);
            },
            tooltip: 'Show favorites only',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: displayedCodes.isEmpty ? null : _clearHistory,
            tooltip: 'Clear history',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search QR codes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchQRCodes('');
                        },
                      )
                    : null,
              ),
              onChanged: _searchQRCodes,
            ),
          ),

          // List
          Expanded(
            child: qrState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : qrState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(qrState.error!),
                          ],
                        ),
                      )
                    : displayedCodes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _showFavoritesOnly ? Icons.favorite_border : Icons.qr_code_2,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _showFavoritesOnly
                                      ? 'No favorites yet'
                                      : _searchController.text.isNotEmpty
                                          ? 'No results found'
                                          : 'No QR codes yet',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _showFavoritesOnly
                                      ? 'Mark QR codes as favorites to see them here'
                                      : 'Scan or generate your first QR code',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayedCodes.length,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              final qrCode = displayedCodes[index];
                              return _QRCodeHistoryItem(
                                qrCode: qrCode,
                                onTap: () => _showQRDetail(qrCode),
                                onFavoriteToggle: () {
                                  ref.read(qrProvider.notifier).toggleFavorite(qrCode);
                                },
                                onDelete: () async {
                                  final success = await ref
                                      .read(qrProvider.notifier)
                                      .deleteQRCode(qrCode.id);
                                  if (success) {
                                    _searchQRCodes(_searchController.text);
                                  }
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  void _showQRDetail(QRCodeModel qrCode) {
    showDialog(
      context: context,
      builder: (context) => QRDetailDialog(qrCode: qrCode),
    );
  }
}

class _QRCodeHistoryItem extends StatelessWidget {
  final QRCodeModel qrCode;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const _QRCodeHistoryItem({
    required this.qrCode,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  qrCode.type.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (qrCode.title != null)
                      Text(
                        qrCode.title!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      qrCode.data,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(qrCode.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: Icon(
                  qrCode.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: qrCode.isFavorite ? Colors.red : null,
                ),
                onPressed: onFavoriteToggle,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
