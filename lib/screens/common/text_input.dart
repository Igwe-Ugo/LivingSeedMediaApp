import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CommonTextInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  IconData? icon;
  bool isPassword;
  bool isEmail;
  bool isPhone;
  bool obscureText;
  bool isTitleNecessary;
  bool isNumber;
  Function validator;
  int? maxLine;
  int? maxLength;
  bool isIcon;
  CommonTextInput(
      {super.key,
      required this.label,
      required this.controller,
      this.icon,
      this.maxLine,
      this.isEmail = false,
      this.isPassword = false,
      this.isPhone = false,
      this.isTitleNecessary = false,
      this.isNumber = false,
      required this.validator,
      this.maxLength,
      this.isIcon = true,
      this.obscureText = true});

  @override
  State<CommonTextInput> createState() => _CommonTextInputState();
}

class _CommonTextInputState extends State<CommonTextInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !widget.isTitleNecessary
            ? Text(
                widget.label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            : SizedBox.shrink(),
        const SizedBox(height: 7),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Theme.of(context).disabledColor.withOpacity(0.15),
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? widget.obscureText : false,
            maxLines: widget.maxLine,
            maxLength: widget.maxLength,
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : widget.isPhone
                    ? TextInputType.phone
                    : widget.isNumber
                        ? TextInputType.number
                        : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).disabledColor.withOpacity(0.15),
              prefixIcon: widget.isIcon ? Icon(widget.icon, size: 17) : null,
              hintText: 'Enter ${widget.label}',
              hintStyle: TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      child: Icon(
                        widget.obscureText ? Iconsax.eye : Iconsax.eye_slash,
                        size: 17,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
