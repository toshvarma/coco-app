import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/text_styles.dart';

enum ButtonType {
  primary,
  secondary,
  text,
  gradient,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool iconRight;
  final bool isFullWidth;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.iconRight = false,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(context);
      case ButtonType.secondary:
        return _buildSecondaryButton(context);
      case ButtonType.text:
        return _buildTextButton(context);
      case ButtonType.gradient:
        return _buildGradientButton(context);
    }
  }

  Widget _buildPrimaryButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(context),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary,
            cs.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final textWidget = Text(text, style: AppTextStyles.button);

    if (icon == null) return textWidget;

    final iconWidget = Icon(icon, size: 20);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconRight
          ? [textWidget, const SizedBox(width: 8), iconWidget]
          : [iconWidget, const SizedBox(width: 8), textWidget],
    );
  }
}
