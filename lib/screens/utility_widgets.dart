import 'package:fast_crypt/common/colors.dart';
import 'package:fast_crypt/common/fonts.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final bool danger;
  final Color? color;
  final EdgeInsets? padding;
  const MyButton(
      {Key? key,
      this.color,
      this.onTap,
      required this.child,
      this.padding,
      this.danger = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
        decoration: BoxDecoration(
          border: Border.all(
            color: danger
                ? Colors.red
                : color != null
                    ? color!
                    : primaryColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DefaultTextStyle.merge(
          child: child,
          style: danger
              ? buttonTextStyle.copyWith(color: Colors.red)
              : buttonTextStyle,
        ),
      ),
    );
  }
}
