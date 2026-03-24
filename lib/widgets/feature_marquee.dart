import 'dart:async';
import 'package:flutter/material.dart';

class FeatureMarquee extends StatefulWidget {
  final List<Widget> children;
  final double speed;
  final bool reverse;

  const FeatureMarquee({
    super.key,
    required this.children,
    this.speed = 50.0,
    this.reverse = false,
  });

  @override
  State<FeatureMarquee> createState() => _FeatureMarqueeState();
}

class _FeatureMarqueeState extends State<FeatureMarquee> {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_scrollController.hasClients) return;

      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.offset;
      double delta = widget.speed * 0.05;

      if (widget.reverse) {
        double newScroll = currentScroll - delta;
        if (newScroll <= 0) {
          _scrollController.jumpTo(maxScroll);
        } else {
          _scrollController.jumpTo(newScroll);
        }
      } else {
        double newScroll = currentScroll + delta;
        if (newScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(newScroll);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripleChildren = [
      ...widget.children,
      ...widget.children,
      ...widget.children
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tripleChildren.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) => tripleChildren[index],
      ),
    );
  }
}
