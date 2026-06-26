import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/history_provider.dart';
import '../providers/image_provider.dart';
import '../providers/gemini_provider.dart';
import '../providers/favorites_provider.dart';
import '../data/models/history_item.dart';
import 'package:flutter/foundation.dart';
import 'result_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatDateTime(DateTime dt) {
    // Simple custom formatting: "MM/DD HH:MM"
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyList = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('번역 기록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (historyList.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('전체 삭제'),
                    content: const Text('모든 번역 기록을 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(historyProvider.notifier).clearHistory();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.error,
                        ),
                        child: const Text('삭제'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                '전체 삭제',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
        ],
      ),
      body: historyList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.history_toggle_off_rounded,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '아직 번역 기록이 없습니다.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '카메라로 촬영하거나 갤러리에서 선택해\n가이드를 받아보세요!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: historyList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = historyList[index];

                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.bookmark_add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return true;
                    } else if (direction == DismissDirection.startToEnd) {
                      _showFolderSelectionBottomSheet(context, ref, item);
                      return false;
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      ref.read(historyProvider.notifier).deleteHistory(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('번역 기록이 삭제되었습니다.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Pre-populate loaders with history data
                        ref.read(imageProvider.notifier).clear();
                        ref.read(imageProvider.notifier).setImage(XFile(item.imagePath));
                        ref.read(geminiNotifierProvider.notifier).setLoadedResult(item.result);
                        
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ResultScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Image Thumbnail
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb
                                    ? Image.network(
                                        item.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image_rounded),
                                      )
                                    : Image.file(
                                        File(item.imagePath),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image_rounded),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Text Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.result.translation,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.result.originalText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Timestamp / Chevron
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatDateTime(item.timestamp),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 11,
                                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showFolderSelectionBottomSheet(
    BuildContext context,
    WidgetRef ref,
    HistoryItem item,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final folders = ref.watch(favoritesProvider);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '즐겨찾기 폴더 선택',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.create_new_folder_outlined),
                          color: colorScheme.primary,
                          tooltip: '새 폴더 추가',
                          onPressed: () => _showCreateFolderDialog(context, ref),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (folders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text('폴더가 없습니다.'),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            final isAdded = ref
                                .read(favoritesProvider.notifier)
                                .isItemInFolder(
                                  folder.id,
                                  item.result.originalText,
                                );

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: Text(
                                folder.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(
                                folder.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('항목 ${folder.items.length}개'),
                              trailing: Icon(
                                isAdded
                                    ? Icons.bookmark_added_rounded
                                    : Icons.bookmark_add_outlined,
                                color: isAdded
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                              ),
                              onTap: () {
                                ref
                                    .read(favoritesProvider.notifier)
                                    .toggleFavorite(
                                      folder.id,
                                      item.imagePath,
                                      item.result,
                                    );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isAdded
                                          ? '${folder.name}에서 제거되었습니다.'
                                          : '${folder.name}에 추가되었습니다.',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emojiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('새 폴더 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '폴더 이름',
                  hintText: '예: 맛집 메뉴, 필수 단어',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emojiController,
                decoration: const InputDecoration(
                  labelText: '대표 이모지 (선택)',
                  hintText: '예: 🍣, ⭐, 📁',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                final emoji = emojiController.text.trim();
                if (name.isNotEmpty) {
                  ref
                      .read(favoritesProvider.notifier)
                      .createFolder(name, emoji);
                  Navigator.pop(context);
                }
              },
              child: const Text('만들기'),
            ),
          ],
        );
      },
    );
  }
}
