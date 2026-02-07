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
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
        ),
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