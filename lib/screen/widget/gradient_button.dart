import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String label;
  final IconData? icon;

  final Gradient gradient;
  final EdgeInsetsGeometry padding;

  final BorderRadiusGeometry borderRadius;

  final List<BoxShadow>? boxShadow;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF5C9CFF), Color(0xFF4B7BFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}