import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatefulWidget {
  final ScrollController controller;
  const Loading({super.key, required this.controller});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listController = widget.controller;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: listController,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: const Center(
          child: LoadingAnimation(),
        ),
      ),
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  final Color? colorIcon;
  const LoadingAnimation({
    Key? key,
    this.colorIcon,
  }) : super(key: key);

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )
      ..forward()
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorIcon = widget.colorIcon;
    return Center(
      child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: SvgPicture.asset(
            'assets/svg/loading.svg',
            colorFilter:
                ColorFilter.mode(colorIcon ?? Colors.grey, BlendMode.srcIn),
          )),
    );
  }
}
