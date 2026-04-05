import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'glass_container.dart';

class FAQAccordion extends StatefulWidget {
  final String question;
  final String answer;

  const FAQAccordion({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQAccordion> createState() => _FAQAccordionState();
}

class _FAQAccordionState extends State<FAQAccordion> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withAlpha(20),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: GlassContainer(
              radius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              borderWidth: _isHovered ? 1.5 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.question,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: _isHovered ? Colors.cyanAccent : Colors.white,
                            fontFamily: 'Outfit',
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _isHovered ? Colors.cyanAccent : Colors.white70,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    child: SizedBox(
                      width: double.infinity,
                      child: _isExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                widget.answer,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withAlpha(180),
                                  height: 1.6,
                                  letterSpacing: 0.2,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms)
                                  .slideY(begin: 0.1, end: 0),
                            )
                          : const SizedBox.shrink(),
                    ),
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
