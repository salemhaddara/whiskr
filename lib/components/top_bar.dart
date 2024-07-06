// ignore_for_file: camel_case_types, must_be_immutable,file_names

import 'package:flutter/material.dart';
import 'package:whiskr/components/text400normal.dart';

class topBar extends StatelessWidget {
  Size size;
  Color? backColor;
  String? text;
  final VoidCallback? onBack;

  topBar({
    super.key,
    required this.size,
    this.text,
    this.backColor,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor ?? Colors.transparent,
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        child: Container(
          width: size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24))),
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            if (onBack != null)
              BackButton(
                onPressed: onBack,
              ),
            text400normal(
              text: text ?? '',
              fontsize: 20,
              color: Colors.black,
            )
          ]),
        ),
      ),
    );
  }
}
