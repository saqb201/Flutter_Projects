import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final bool disabled;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    required this.disabled,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(_pressed ? 0.7 : 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.disabled
            ? null
            : () {
                setState(() => _pressed = true);
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() => _pressed = false);
                  widget.onTap();
                });
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
