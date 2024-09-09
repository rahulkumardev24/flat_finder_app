import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key,
    this.borderRadius = 11.0,
    this.focusedColor = Colors.green,
    this.enabledColor = Colors.grey,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    required this.label,
    required this.textController

  });

  final double borderRadius;
  final Color focusedColor;
  final Color enabledColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String label;
  final TextEditingController textController;


  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      controller: widget.textController,
      decoration: InputDecoration(
          label: Text(widget.label),
          focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.focusedColor,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.enabledColor
              )
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon
      ),
    );
  }
}