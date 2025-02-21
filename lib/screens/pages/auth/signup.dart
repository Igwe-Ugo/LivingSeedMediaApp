import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

class LivingSeedSignUp extends StatefulWidget {
  const LivingSeedSignUp({super.key});

  @override
  State<LivingSeedSignUp> createState() => _LivingSeedSignUpState();
}

class _LivingSeedSignUpState extends State<LivingSeedSignUp> {
  final _formKey = GlobalKey<FormState>();
  final bool _obscureText = true;
  bool agreeToTerms = false;
  bool male = false;
  bool female = false;
  bool isLoading = false;
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final telephoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CommonTextInput(
                    label: 'Fullname',
                    controller: fullnameController,
                    icon: Icons.person_outline),
                CommonTextInput(
                    label: 'Email',
                    controller: emailController,
                    icon: Icons.email_outlined,
                    isEmail: true),
                CommonTextInput(
                    label: 'Password',
                    controller: passwordController,
                    icon: Iconsax.password_check,
                    isPassword: true),
                CommonTextInput(
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    icon: Iconsax.password_check,
                    obscureText: _obscureText,
                    isPassword: true),
                CommonTextInput(
                    label: 'Telephone',
                    controller: telephoneController,
                    icon: Icons.phone_android_outlined,
                    isPhone: true),
                const SizedBox(height: 15),

                // Gender Selection
                _buildGenderSelection(),
                const SizedBox(
                  height: 20,
                ),
                // Terms and Conditions
                _buildTermsAndConditions(),

                const SizedBox(height: 15),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _signUpUser,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(10, 50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    'OR CONTINUE WITH',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context).dividerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(10, 50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/devicon_google.svg'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Google',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColorDark),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () => GoRouter.of(context)
                          .go(LivingSeedAppRouter.loginPath),
                      child: Text('Sign In',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Select Gender:    ',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        Checkbox(
          value: male,
          onChanged: (value) {
            setState(() {
              male = value!;
              female = !value;
            });
          },
        ),
        const Text('Male'),
        Checkbox(
          value: female,
          onChanged: (value) {
            setState(() {
              female = value!;
              male = !value;
            });
          },
        ),
        const Text('Female'),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          onChanged: (value) {
            setState(() {
              agreeToTerms = value!;
            });
          },
        ),
        const Text('I agree to the Terms and Conditions'),
      ],
    );
  }

  void _signUpUser() async {
    RegExp regExp = RegExp(
        "^[a-zA-Z0-9.a-zA-Z0-9.!#%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }
    if (passwordController.text != confirmPasswordController.text) {
      showMessage(
          'Password must be the same with your confirmed password', context);
      return;
    }
    if (!regExp.hasMatch(emailController.text)) {
      showMessage('Please put in a correct email Address', context);
      return;
    }

    Users newUser = Users(
      fullname: fullnameController.text,
      emailAddress: emailController.text,
      password: passwordController.text,
      telephone: telephoneController.text,
      gender: male ? "Male" : "Female",
      role: "Regular",
      userImage: 'assets/images/avatar.png',
      dateOfBirth: '',
      cart: [],
      bookPurchased: [],
      downloads: [],
    );

    bool success = await Provider.of<UsersAuthProvider>(context, listen: false)
        .signup(newUser);
    if (success) {
      GoRouter.of(context).go(LivingSeedAppRouter.homePath, extra: newUser);
    } else {
      showMessage('User already exists, please register a new user', context);
      return;
    }
  }
}
