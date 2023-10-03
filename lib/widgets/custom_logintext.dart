import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
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

class CustomPasswordField extends StatefulWidget {
  CustomPasswordField({
    this.onChanged,
    this.hint,
  });

  Function(String?)? onChanged;
  String? hint;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool isObscured = true;

  Icon visibility = Icon(Icons.visibility);
  Icon invisibility = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      obscureText: isObscured,
      hint: widget.hint,
      onFieldChanged: widget.onChanged,
      suffixIcon: IconButton(
          onPressed: () {
            isObscured = !isObscured;
            setState(() {});
          },
          icon: isObscured ? visibility : invisibility),
    );
  }
}
