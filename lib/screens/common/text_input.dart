import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CommonTextInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  bool isPassword;
  bool isEmail;
  bool isPhone;
  bool obscureText;
  CommonTextInput(
      {super.key,
      required this.label,
      required this.controller,
      required this.icon,
      this.isEmail = false,
      this.isPassword = false,
      this.isPhone = false,
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
        Text(
          widget.label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : widget.isPhone
                    ? TextInputType.phone
                    : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).disabledColor.withOpacity(0.15),
              prefixIcon: Icon(widget.icon, size: 17),
              hintText: 'Enter ${widget.label}',
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
