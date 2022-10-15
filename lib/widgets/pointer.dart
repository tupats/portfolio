import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal/providers/mouse_position_provider.dart';
import 'package:personal/providers/theme_provider.dart';

class PointerWidget extends ConsumerStatefulWidget {
  const PointerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PointerWidgetState();
}

class _PointerWidgetState extends ConsumerState {
  Offset currentPosition = const Offset(0, 0);
  Offset deltaPosition = const Offset(0, 0);
  Offset position = const Offset(0, 0);
  double force = 0;

  @override
  void initState() {
    ref.listenManual(mousePositionProvider, (previous, next) {
      position = next;
    });
    calculateForce();
    super.initState();
  }

  void calculateForce() {
    force = ((position - currentPosition).distanceSquared.abs() * 0.000001)
        .clamp(0.1, 1);
    deltaPosition = (position - currentPosition);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          currentPosition += deltaPosition * force;
          ref.read(pointerProvider.notifier).update(
                (state) => currentPosition,
              );
          calculateForce();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = 100 * force;
    final color = ref.watch(colorProvider);
    return Positioned(
      left: currentPosition.dx - size / 2,
      top: currentPosition.dy - size / 2,
      child: IgnorePointer(
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color,
          ),
        ),
      ),
    );
  }
}
