import 'package:flutter/material.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        // Tự động tinh chỉnh độ cong viền và padding theo kích thước màn hình
        final double horizontalMargin = screenWidth > 600 ? 24 : 12;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8),
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

