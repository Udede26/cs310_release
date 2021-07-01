import 'package:flutter/material.dart';
import 'package:flutter_app/text_field_container.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/colors.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: AppColors.mainColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: AppColors.mainColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RoundedPasswordFieldAgain extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordFieldAgain({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password Again",
          icon: Icon(
            Icons.lock,
            color: AppColors.mainColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: AppColors.mainColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}