import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true;
  bool _obscureText2 = true;
  final double _textFieldFont = 17.0;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    } else if (_newPasswordController.text !=
        _confirmNewPasswordController.text) {
      return showMessage(
          'New Password must be matched with confirmed password', context);
    }

    bool success = await Provider.of<UsersAuthProvider>(context, listen: false)
        .changePassword(
            _newPasswordController.text, _oldPasswordController.text);
    if (success) {
      showMessage('Change of password was successful!', context);
      GoRouter.of(context).pop();
    } else {
      showMessage('Old password does not match with database!', context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () => _changePassword,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(10, 50),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
                child: Text('Change Password',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                        color: Colors.white))),
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          size: 17,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Enter old password',
                  style: TextStyle(
                    fontSize: _textFieldFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: _oldPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your old password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.15),
                      prefixIcon: const Icon(Icons.lock_outline, size: 17),
                      hintText: 'Old Password',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).disabledColor,
                        fontSize: 17,
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText ? Iconsax.eye : Iconsax.eye_slash,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Enter new password',
                  style: TextStyle(
                    fontSize: _textFieldFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    obscureText: _obscureText2,
                    controller: _newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 4) {
                        return 'Password must be at least 4 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.15),
                      prefixIcon: const Icon(Icons.lock_outline, size: 17),
                      hintText: 'New Password',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).disabledColor,
                        fontSize: 17,
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        child: Icon(
                          _obscureText2 ? Iconsax.eye : Iconsax.eye_slash,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Confirm new password',
                  style: TextStyle(
                    fontSize: _textFieldFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    obscureText: _obscureText2,
                    controller: _confirmNewPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.15),
                      prefixIcon: const Icon(Icons.lock_outline, size: 17),
                      hintText: 'Confirm Password',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).disabledColor,
                        fontSize: 17,
                      ),
                      errorStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        child: Icon(
                          _obscureText2 ? Iconsax.eye : Iconsax.eye_slash,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
