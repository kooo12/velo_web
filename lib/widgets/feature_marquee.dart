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

class _FeatureMarqueeState extends State<FeatureMarquee>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Initial duration, will be updated
    )..addListener(_updateScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _updateScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final double scrollValue =
        widget.reverse ? (1.0 - _animationController.value) : _animationController.value;
    _scrollController.jumpTo(scrollValue * maxScroll);
  }

  void _startScrolling() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    // Calculate duration based on speed and total distance
    final double durationInSeconds = maxScroll / widget.speed;
    _animationController.duration =
        Duration(milliseconds: (durationInSeconds * 1000).toInt());
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  late List<Widget> _cachedChildren;
  
  @override
  void didUpdateWidget(FeatureMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children != widget.children) {
      _cachedChildren = [
        ...widget.children,
        ...widget.children,
        ...widget.children,
      ];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cachedChildren = [
      ...widget.children,
      ...widget.children,
      ...widget.children,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _cachedChildren.length,
          separatorBuilder: (_, __) => const SizedBox(width: 24),
          itemBuilder: (context, index) => _cachedChildren[index],
          cacheExtent: 1000, // Pre-render some items for smoother scrolling
        ),
      ),
    );
  }
}
