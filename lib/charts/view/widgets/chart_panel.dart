import 'package:flutter/material.dart';

/// Decorative frame around chart widgets (gradient border, soft shadow).
class ChartPanel extends StatelessWidget {
  const ChartPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(12, 16, 12, 8),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surfaceContainerHighest.withValues(alpha: 0.65),
              scheme.surface.withValues(alpha: 0.98),
            ],
          ),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: child,
      ),
    );
  }
}
