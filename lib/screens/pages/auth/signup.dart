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
  bool _obscureText = true;
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
                _buildTextField(
                    'Fullname', fullnameController, Icons.person_outline),
                _buildTextField('Email', emailController, Icons.email_outlined,
                    isEmail: true),
                _buildTextField(
                    'Password', passwordController, Icons.lock_outline,
                    isPassword: true),
                _buildTextField('Confirm Password', confirmPasswordController,
                    Icons.lock_outline,
                    isPassword: true),
                _buildTextField('Telephone', telephoneController,
                    Icons.phone_android_outlined,
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

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isPassword = false, bool isEmail = false, bool isPhone = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 7),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).disabledColor.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _obscureText : false,
            keyboardType: isEmail
                ? TextInputType.emailAddress
                : isPhone
                    ? TextInputType.phone
                    : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).disabledColor.withOpacity(0.15),
              prefixIcon: Icon(icon, size: 17),
              hintText: 'Enter $label',
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Iconsax.eye : Iconsax.eye_slash,
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
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
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
      GoRouter.of(context).go(LivingSeedAppRouter.homePath);
    }
  }
}
