import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';

class LivingSeedResetForgottenPassword extends StatefulWidget {
  const LivingSeedResetForgottenPassword({super.key});

  @override
  State<LivingSeedResetForgottenPassword> createState() =>
      _LivingSeedResetForgottenPasswordState();
}

class _LivingSeedResetForgottenPasswordState
    extends State<LivingSeedResetForgottenPassword> {
  bool _obscureText = true;
  final resetForgottenPasswordForm = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Form(
              key: resetForgottenPasswordForm,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'New password',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
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
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        } else if (passwordController.text.length < 8) {
                          return "Password length should not be less than 8 characters";
                        }
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
                    height: 7,
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
                      controller: passwordConfirmController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        } else if (passwordConfirmController.text.length < 8) {
                          return "Password length should not be less than 8 characters";
                        }
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
                ],
              ),
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Change your mind?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      GoRouter.of(context).go(LivingSeedAppRouter.loginPath),
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(10, 50),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Text(
                      'Change password',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }
}
