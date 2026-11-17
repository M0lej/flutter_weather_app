import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon? icon;
  final Widget child;
  
  const CustomButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Row(spacing: 10, children: [if (icon != null) icon!, child]),
    );
  }
}
