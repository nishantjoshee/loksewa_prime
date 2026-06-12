import 'package:flutter/material.dart';
import '../../data/models/current_affair.dart';

class EntryCard extends StatelessWidget {
  final CurrentAffair entry;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final String language;
  final bool isRead;

  const EntryCard({
    super.key,
    required this.entry,
    this.onTap,
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
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
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
                        if (isBookmarked)
                          Icon(
                            Icons.bookmark,
                            size: 18,
                            color: colors.primary,
                            semanticLabel: language == 'np'
                                ? 'बुकमार्क गरिएको'
                                : 'Bookmarked',
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(entry.date, style: metadataStyle),
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
