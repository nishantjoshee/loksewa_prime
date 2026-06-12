import 'package:flutter/material.dart';
import '../../data/models/current_affair.dart';

Color _categoryColor(String category) {
  return switch (category) {
    'राजनीति' || 'Politics' => const Color(0xFF1565C0),
    'अर्थतन्त्र' || 'Economy' => const Color(0xFF00796B),
    'विज्ञान/प्रविधि' || 'Science/Tech' => const Color(0xFF6A1B9A),
    'खेलकुद' || 'Sports' => const Color(0xFFE65100),
    'अन्तर्राष्ट्रिय' || 'International' => const Color(0xFF2E7D32),
    'नेपाल' || 'Nepal' => const Color(0xFFC62828),
    _ => const Color(0xFF607D8B),
  };
}

class EntryCard extends StatelessWidget {
  final CurrentAffair entry;
  final VoidCallback? onTap;
  final VoidCallback? onToggleBookmark;
  final VoidCallback? onToggleRead;
  final bool isBookmarked;
  final String language;
  final bool isRead;

  const EntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onToggleBookmark,
    this.onToggleRead,
    this.isBookmarked = false,
    this.language = 'np',
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final title = language == 'np' ? entry.titleNp : entry.titleEn;
    final semanticTitle = '${entry.titleNp}. ${entry.titleEn}';

    final chipStyle = textTheme.labelSmall?.copyWith(
      color: colors.primary,
      fontWeight: FontWeight.w700,
    );
    final metadataStyle = textTheme.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Semantics(
      label: semanticTitle,
      button: onTap != null,
      child: RepaintBoundary(
        child: Card(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 4, color: _categoryColor(entry.category)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  language == 'np'
                                      ? entry.category
                                      : entry.categoryEn,
                                  style: chipStyle,
                                ),
                              ),
                              const Spacer(),
                              if (onToggleRead != null)
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: onToggleRead,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isRead
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          size: 14,
                                          color: isRead
                                              ? colors.primary
                                              : colors.onSurface.withValues(
                                                  alpha: 0.25,
                                                ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          isRead
                                              ? language == 'np'
                                                    ? 'पढियो'
                                                    : 'Read'
                                              : language == 'np'
                                              ? 'नपढिएको'
                                              : 'Unread',
                                          style: textTheme.labelSmall?.copyWith(
                                            fontSize: 9,
                                            color: isRead
                                                ? colors.primary
                                                : colors.onSurface.withValues(
                                                    alpha: 0.35,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (onToggleBookmark != null)
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: onToggleBookmark,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 16,
                                      color: isBookmarked
                                          ? colors.primary
                                          : colors.onSurface.withValues(
                                              alpha: 0.3,
                                            ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 11,
                                color: colors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Text(entry.date, style: metadataStyle),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.source_outlined,
                                size: 11,
                                color: colors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  entry.source,
                                  style: metadataStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
