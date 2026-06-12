import 'package:flutter/material.dart';
import '../ui_strings.dart';
import '../../data/models/current_affair.dart';

class EntryCard extends StatelessWidget {
  final CurrentAffair entry;
  final VoidCallback? onTap;
  final bool isBookmarked;

  const EntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final chipStyle = textTheme.labelSmall?.copyWith(
      color: colors.onPrimaryContainer,
    );
    final subtitleStyle = textTheme.bodyMedium?.copyWith(
      color: colors.onSurface.withValues(alpha: 0.6),
    );
    final metadataStyle = textTheme.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Semantics(
      label: '${entry.titleNp}. ${entry.titleEn}',
      hint: isBookmarked ? UiStrings.bookmarkedLabelNp : '',
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
                          label: '${UiStrings.tagsNp}: ${entry.category}',
                          child: Text(entry.category, style: chipStyle),
                        ),
                      ),
                      const Spacer(),
                      if (isBookmarked)
                        Icon(
                          Icons.bookmark,
                          size: 18,
                          color: colors.primary,
                          semanticLabel: UiStrings.bookmarkedLabelNp,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(entry.titleNp, style: textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(entry.titleEn, style: subtitleStyle),
                  const SizedBox(height: 10),
                  Text(
                    entry.summaryNp,
                    style: textTheme.bodyMedium,
                    maxLines: 3,
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
                      const Spacer(),
                      Icon(
                        Icons.source,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(entry.source, style: metadataStyle),
                    ],
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
