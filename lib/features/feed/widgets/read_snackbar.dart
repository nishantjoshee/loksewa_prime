import 'package:flutter/material.dart';
import '../read_providers.dart';

void showReadSnackBar({
  required BuildContext context,
  required bool wasRead,
  required String entryId,
  required ReadEntriesNotifier notifier,
  required bool isNp,
}) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: _SnackContent(wasRead: wasRead, isNp: isNp, colors: colors),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colors.surface,
        action: SnackBarAction(
          label: isNp ? 'पूर्ववत' : 'Undo',
          textColor: colors.primary,
          onPressed: () {
            if (wasRead) {
              notifier.markRead(entryId);
            } else {
              notifier.unmarkRead(entryId);
            }
          },
        ),
      ),
    );
}

class _SnackContent extends StatefulWidget {
  final bool wasRead;
  final bool isNp;
  final ColorScheme colors;

  const _SnackContent({
    required this.wasRead,
    required this.isNp,
    required this.colors,
  });

  @override
  State<_SnackContent> createState() => _SnackContentState();
}

class _SnackContentState extends State<_SnackContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - _controller.value;
    final theme = Theme.of(context);
    final colors = widget.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              widget.wasRead
                  ? Icons.radio_button_unchecked
                  : Icons.check_circle,
              size: 18,
              color: colors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.wasRead
                    ? (widget.isNp
                          ? 'नपढिएको चिन्ह लगाइयो'
                          : 'Marked as unread')
                    : (widget.isNp
                          ? 'पढिसकिएको चिन्ह लगाइयो'
                          : 'Marked as read'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            color: colors.primary,
            backgroundColor: colors.primary.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}
