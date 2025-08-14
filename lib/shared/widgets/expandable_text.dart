import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final List<InlineSpan> textSpans;

  const ExpandableText({super.key, required this.textSpans});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _isOverflow = false;
  double _maxHeight = 0;

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final textSpan = TextSpan(children: widget.textSpans);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: null,
        )..layout(maxWidth: constraints.maxWidth);

        final fullHeight = textPainter.height;
        final lineHeight = textPainter.preferredLineHeight;
        _maxHeight = lineHeight * 3;

        final isOverflow = fullHeight > _maxHeight;
        if (_isOverflow != isOverflow) {
          // only setState outside build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isOverflow = isOverflow;
              });
            }
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints: _expanded
                    ? const BoxConstraints()
                    : BoxConstraints(maxHeight: _maxHeight),
                child: Text.rich(
                  textSpan,
                  softWrap: true,
                ),
              ),
            ),
            if (_isOverflow)
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _expanded ? intl.less : intl.more,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
