import 'package:fast_crypt/common/colors.dart';
import 'package:fast_crypt/common/fonts.dart';
import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  final double width;
  const HorizontalSpace([this.width = 10, Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

class VerticalSpace extends StatelessWidget {
  final double height;
  const VerticalSpace([this.height = 10, Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

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

class TitleValue extends StatelessWidget {
  final String title;
  final String value;
  const TitleValue({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          "$title:",
          style: boldTextStyle,
        ),
        const HorizontalSpace(),
        Text(
          value,
          // style: semiBoldTextStyle,
        )
      ],
    );
  }
}
