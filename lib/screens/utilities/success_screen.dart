import 'package:fast_crypt/common/widgets.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String? messsage;
  final VoidCallback? onReturn;
  const SuccessScreen({Key? key, this.messsage, this.onReturn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.done_all,
            color: Colors.blue,
            size: 60,
          ),
          const HorizontalSpace(25),
          Text(
            messsage ?? 'The operation was successfull',
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
          if (onReturn != null) const HorizontalSpace(),
          if (onReturn != null)
            MyButton(onTap: onReturn, child: const Text('Return'))
        ],
      ),
    );
  }
}
