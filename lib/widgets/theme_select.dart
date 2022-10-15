import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal/providers/theme_provider.dart';

class ThemeSelectWidget extends ConsumerWidget {
  final Color color;
  const ThemeSelectWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(colorProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        ref.read(colorProvider.notifier).update((state) => color);
        ref.read(tempColorProvider.notifier).update((state) => color);
      },
      onHover: (isHovered) {
        if (isHovered) {
          ref.read(colorProvider.notifier).update(
                (state) => color,
              );
        } else {
          ref
              .read(colorProvider.notifier)
              .update((state) => ref.read(tempColorProvider));
        }
      },
      onFocusChange: (hasFocus) {
        if (!hasFocus) {}
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: currentColor == color ? 1.5 : 1,
          child: Icon(
            currentColor == color ? Icons.circle : Icons.circle_outlined,
            color: color,
            size: 12,
          ),
        ),
      ),
    );
  }
}
