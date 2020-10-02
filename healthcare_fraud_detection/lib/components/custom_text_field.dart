import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText,
    this.onFieldSubmitted,
    this.textInputAction,
    this.onSaved,
    this.controller,
    this.validator,
  });

  final String hintText;
  final Widget prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function onFieldSubmitted;
  final TextInputAction textInputAction;
  final Function onSaved;
  final TextEditingController controller;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Neumorphic(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        drawSurfaceAboveChild: true,
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25.0)),
          depth: 10,
          intensity: 1,
          // lightSource: LightSource.topLeft,
          shape: NeumorphicShape.concave,
        ),
        child: TextFormField(
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          controller: controller,
          validator: validator,
          obscureText: obscureText != null ? true : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
            hintText: hintText,
            errorBorder: InputBorder.none,
            prefixIcon: prefixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
