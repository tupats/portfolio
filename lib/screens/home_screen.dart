import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal/projects.dart';
import 'package:personal/providers/mouse_position_provider.dart';
import 'package:personal/providers/project_provider.dart';
import 'package:personal/providers/theme_provider.dart';
import 'package:personal/themes.dart';
import 'package:personal/widgets/pointer.dart';
import 'package:personal/widgets/theme_select.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Listener(
      onPointerHover: (event) {
        ref
            .read(mousePositionProvider.notifier)
            .update((state) => event.position);
      },
      onPointerMove: (event) {
        ref
            .read(mousePositionProvider.notifier)
            .update((state) => event.position);
      },
      onPointerDown: (event) {},
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              AnimatedBackground(),
              const ThemeSelectorBackground(),
              const ThemeSelectorList(),
              const ProjectList(),
              const PointerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBackground extends ConsumerWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointer = ref.watch(pointerProvider);
    final size = MediaQuery.of(context).size;
    print('$size, $pointer');
    print(Alignment(pointer.dx / size.width, pointer.dy / size.height));
    return ClipPath(
      clipper: _BackgroundClipper(pointer),
      child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 1,
                center: Alignment(
                    pointer.dx / size.width, pointer.dy / size.height),
                colors: [Colors.grey, Colors.white])),
      ),
    );
  }
}

class _BackgroundClipper extends CustomClipper<Path> {
  final Offset pointer;
  _BackgroundClipper(this.pointer);
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.cubicTo(
        0, size.height, pointer.dx, pointer.dy, size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class ThemeSelectorBackground extends StatelessWidget {
  const ThemeSelectorBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _MyClipper(),
      child: Container(
        color: Theme.of(context).bottomAppBarColor,
      ),
    );
  }
}

class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final startPoint = size.width - 172;
    const height = 32.0;
    const curve = height / 2;
    path.lineTo(startPoint, 0);
    path.cubicTo(
      startPoint,
      0,
      startPoint + curve,
      curve / 4,
      startPoint + curve,
      height / 2,
    );
    path.cubicTo(
      startPoint + curve,
      height / 2,
      startPoint + curve,
      height,
      startPoint + curve + curve,
      height,
    );

    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class ProjectList extends ConsumerWidget {
  const ProjectList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: projects
            .map((project) => ProjectSelectButton(
                  project: project,
                ))
            .toList(),
      ),
    );
  }
}

class ProjectSelectButton extends ConsumerStatefulWidget {
  const ProjectSelectButton({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProjectSelectButtonState();
}

class _ProjectSelectButtonState extends ConsumerState<ProjectSelectButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final containerSize = MediaQuery.of(context).size.height / 10;
    final color = ref.watch(colorProvider);
    ref.listen(
      projectProvider,
      (previous, next) {
        if (selected != (next == widget.project)) {
          setState(() {
            selected = !selected;
          });
        }
      },
    );
    return InkWell(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(64),
        topLeft: Radius.circular(64),
      ),
      onTap: () {
        ref.read(projectProvider.notifier).update((state) => widget.project);
      },
      child: AnimatedScale(
        alignment: Alignment.bottomCenter,
        duration: const Duration(milliseconds: 100),
        scale: selected ? 1.5 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(64),
              topLeft: Radius.circular(64),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
            top: 16.0,
          ),
          child: Icon(
            widget.project.icon,
          ),
        ),
      ),
    );
  }
}

class ThemeSelectorList extends ConsumerWidget {
  const ThemeSelectorList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topRight,
      child: CustomPaint(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...Themes.availableColors
                .map((color) => ThemeSelectWidget(color: color))
                .toList(),
            IconButton(
                onPressed: () {
                  ref.read(themeModeProvider.notifier).update((state) =>
                      state == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light);
                },
                icon: const Icon(Icons.sunny))
          ],
        ),
      ),
    );
  }
}
