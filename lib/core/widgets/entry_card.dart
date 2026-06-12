import 'package:flutter/material.dart';
import '../../data/models/current_affair.dart';

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
    final readLabel = language == 'np' ? 'पढिसकिएको' : 'Read';

    final chipStyle = textTheme.labelSmall?.copyWith(
      color: colors.onPrimaryContainer,
    );
    final metadataStyle = textTheme.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Opacity(
      opacity: isRead ? 0.6 : 1.0,
      child: Semantics(
        label: semanticTitle,
        hint: isBookmarked
            ? language == 'np'
                  ? 'बुकमार्क गरिएको'
                  : 'Bookmarked'
            : isRead
            ? readLabel
            : '',
        button: onTap != null,
        child: RepaintBoundary(
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Semantics(
                            label:
                                '${language == 'np' ? 'ट्यागहरू' : 'Tags'}: ${language == 'np' ? entry.category : entry.categoryEn}',
                            child: Text(
                              language == 'np'
                                  ? entry.category
                                  : entry.categoryEn,
                              style: chipStyle,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (onToggleRead != null)
                          Semantics(
                            label: isRead
                                ? language == 'np'
                                      ? 'नपढिएको चिन्ह लगाउनुहोस्'
                                      : 'Mark unread'
                                : language == 'np'
                                ? 'पढिसकिएको चिन्ह लगाउनुहोस्'
                                : 'Mark read',
                            button: true,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: onToggleRead,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
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
                          ),
                        if (onToggleBookmark != null)
                          Semantics(
                            label: isBookmarked
                                ? language == 'np'
                                      ? 'बुकमार्क हटाउनुहोस्'
                                      : 'Remove bookmark'
                                : language == 'np'
                                ? 'बुकमार्क गर्नुहोस्'
                                : 'Bookmark',
                            button: true,
                            child: InkWell(
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
                                      : colors.onSurface.withValues(alpha: 0.3),
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
          ),
        ),
      ),
    );
  }
}
