import 'package:fast_crypt/common/fonts.dart';
import 'package:fast_crypt/common/widgets.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? messsage;
  final String? description;

  final VoidCallback? onReturn;
  const ErrorScreen({Key? key, this.messsage, this.description, this.onReturn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber,
              color: Colors.red,
              size: 70,
            ),
            const HorizontalSpace(25),
            Text(
              messsage ?? 'An Error Occurred',
              style: bigTextStyle.copyWith(color: Colors.red),
            ),
            HorizontalSpace(20),
            Text(
              description ?? 'Please try again or contact the app developer',
            ),
            if (onReturn != null) const HorizontalSpace(),
            if (onReturn != null)
              MyButton(
                  danger: true, onTap: onReturn, child: const Text('Return'))
          ],
        ),
      ),
    );
  }
}
