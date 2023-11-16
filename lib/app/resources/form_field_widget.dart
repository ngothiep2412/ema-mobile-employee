import 'package:flutter/material.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';

// ignore: must_be_immutable
class FormFieldWidget extends StatelessWidget {
  FormFieldWidget(
      {super.key,
      this.focusNode,
      this.icon,
      this.errorText = "",
      this.labelText,
      this.controllerEditting,
      required this.setValueFunc,
      this.textInputType = TextInputType.text,
      this.isObscureText = false,
      this.isEnabled = true,
      this.initValue,
      this.padding = 0,
      this.suffixIcon,
      this.enableInteractiveSelection = true,
      this.styleInput = const TextStyle(color: Colors.black),
      this.radiusBorder = 0,
      this.maxLine = 1,
      this.paddingVerti = 0,
      this.fillColor = Colors.white,
      this.directLTR = true});
  final FocusNode? focusNode;
  final Icon? icon;
  final Widget? suffixIcon;
  String? errorText;
  final String? labelText;
  final TextEditingController? controllerEditting;
  final Function setValueFunc;
  final TextInputType textInputType;
  final bool isObscureText;
  final bool? isEnabled;
  final String? initValue;
  final double? padding;
  final bool? enableInteractiveSelection;
  final TextStyle? styleInput;
  final double? radiusBorder;
  final int? maxLine;
  final double? paddingVerti;
  final Color? fillColor;
  final bool directLTR;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: directLTR ? TextDirection.ltr : TextDirection.rtl,
      cursorColor: Colors.white,
      style: styleInput,
      enableInteractiveSelection: enableInteractiveSelection,
      initialValue: initValue,
      enabled: isEnabled,
      obscureText: isObscureText,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white, fontSize: UtilsReponsive.height(18, context)),
        fillColor: fillColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: padding!, vertical: paddingVerti!),
        errorText: errorText != "" ? errorText : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBorder ?? 20),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(radiusBorder ?? 20),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(radiusBorder ?? 20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(radiusBorder ?? 20),
        ),
        // labelText: labelText,
        labelText: labelText,
        hintTextDirection: TextDirection.ltr,
        hintMaxLines: 3,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
      ),
      keyboardType: textInputType,
      controller: controllerEditting,
      onChanged: (value) {
        setValueFunc(value);
      },
      maxLines: maxLine,
    );
  }
}
