import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/favorites_provider.dart';
import '../providers/image_provider.dart';
import '../providers/gemini_provider.dart';
import 'package:flutter/foundation.dart';
import 'result_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(favoritesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: folders.every((f) => f.items.isEmpty) && folders.length == 1
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
                      Icons.star_border_rounded,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '즐겨찾기가 비어 있습니다.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '일본어 분석 결과에서 별표(★)를 눌러\n폴더별로 번역 단어들을 모아보세요!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: folders.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final folder = folders[index];
                if (folder.items.isEmpty && folder.id != 'default') {
                  // Only show non-empty folders, or the default folder always
                  return const SizedBox.shrink();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                    ),
                  ),
                  child: ExpansionTile(
                    leading: Text(
                      folder.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      folder.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '항목 ${folder.items.length}개',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    shape: const Border(),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    children: folder.items.isEmpty
                        ? [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text('이 폴더에 저장된 항목이 없습니다.'),
                              ),
                            )
                          ]
                        : folder.items.map((item) {
                            return Dismissible(
                              key: Key(item.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              onDismissed: (direction) {
                                ref.read(favoritesProvider.notifier).removeFromFolder(folder.id, item.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${folder.name}에서 삭제되었습니다.'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                                title: Text(
                                  item.result.translation,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  item.result.originalText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                                onTap: () {
                                  ref.read(imageProvider.notifier).clear();
                                  ref.read(imageProvider.notifier).setImage(XFile(item.imagePath));
                                  ref.read(geminiNotifierProvider.notifier).setLoadedResult(item.result);
                                  
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ResultScreen(),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
