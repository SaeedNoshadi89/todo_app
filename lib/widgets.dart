import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';

class TodoRadioButton extends StatelessWidget {
  final bool isChecked;
  final Color color;

  const TodoRadioButton(
      {super.key, required this.isChecked, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: 16.0,
      height: 16.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: color,
      ),
      child: isChecked
          ? Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: themeData.colorScheme.surface),
        ),
      )
          : null,
    );
  }
}

class TodoCheckBox extends StatelessWidget {
  final bool isChecked;
  final Function() onTap;

  const TodoCheckBox({super.key, required this.isChecked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: !isChecked
              ? Border.all(
            color: secondaryTextColor,
          )
              : null,
          color: isChecked ? primaryColor : null,
        ),
        child: isChecked
            ? Icon(
          CupertinoIcons.check_mark,
          size: 18.0,
          color: themeData.colorScheme.onPrimary,
        )
            : null,
      ),
    );
  }
}
