import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/screens/login_screen/password_obscurer.dart';
import '../constant/theme.dart';

// const kTextFieldDecoration = InputDecoration(
//     hintText: 'Enter a value',
//     hintStyle: TextStyle(color: Colors.grey),
//     contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
//       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
//       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//     ));

class CustomLoginTextField extends StatelessWidget {
  const CustomLoginTextField({
    Key? key,
    this.enabled,
    this.prefixIcon,
    this.validator,
    this.textEditingController,
    this.isPassword = false,
    this.hintText,
    this.labelText,
    this.autovalidateMode,
    this.keyboardType,
    this.onSaved,
    this.onChanged,
    this.textInputFormatter,
  }) : super(key: key);
  final bool? enabled;
  final bool? isPassword;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? textInputFormatter;
  final String? hintText, labelText;
  final Icon? prefixIcon;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: false,
      controller: textEditingController,
      inputFormatters: textInputFormatter,
      decoration: kTextFieldDecoration.copyWith(
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText,
          suffixIcon: const SizedBox(height: 0)),
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}

class CustomPasswordField extends StatelessWidget {
  const CustomPasswordField(
      {Key? key,
      this.prefixIcon,
      this.controller,
      this.validator,
      this.textEditingController,
      this.hintText,
      this.labelText,
      this.autovalidateMode,
      this.keyboardType,
      this.onSaved,
      this.onChanged})
      : super(key: key);
  final PassObscurerController? controller;
  final TextEditingController? textEditingController;
  final String? hintText, labelText;
  final Icon? prefixIcon;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GetX<PassObscurerController>(
      builder: (_) => TextFormField(
        autovalidateMode: autovalidateMode,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: controller!.hidePassword.value,
        controller: textEditingController,
        decoration: kTextFieldDecoration.copyWith(
            prefixIcon: prefixIcon,
            hintText: hintText,
            labelText: labelText,
            suffixIcon: InkWell(
                child: controller!.hidePassword.value
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                onTap: () => controller!.obscureTextSwitch())),
        onSaved: onSaved,
        onChanged: onChanged,
      ),
    );
  }
}
