// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';
import '../../models/models.dart';

class LivingSeedSignIn extends StatefulWidget {
  const LivingSeedSignIn({super.key});

  @override
  State<LivingSeedSignIn> createState() => _LivingSeedSignInState();
}

class _LivingSeedSignInState extends State<LivingSeedSignIn> {
  final bool _obscureText = true;
  final loginFormField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/livingseed.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Form(
                key: loginFormField,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hello!',
                          style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonTextInput(
                          label: 'Email',
                          controller: emailController,
                          icon: Icons.email_outlined,
                          isEmail: true),
                      CommonTextInput(
                          label: 'Password',
                          controller: passwordController,
                          icon: Iconsax.password_check,
                          obscureText: _obscureText,
                          isPassword: true),
                      const SizedBox(
                        height: 7,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => GoRouter.of(context)
                              .go(LivingSeedAppRouter.forgotPasswordOtpPath),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          RegExp regExp = RegExp(
                              "^[a-zA-Z0-9.a-zA-Z0-9.!#%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!regExp.hasMatch(emailController.text)) {
                            showMessage('Please put in a correct email Address',
                                context);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          Users? authenticatedUser =
                              await Provider.of<UsersAuthProvider>(context,
                                      listen: false)
                                  .signIn(emailController.text,
                                      passwordController.text);
                          if (authenticatedUser != null) {
                            GoRouter.of(context)
                                .go(LivingSeedAppRouter.homePath);
                          } else {
                            setState(() {
                              errorMessage = 'Invalid EmailAddress or password';
                              showMessage(errorMessage, context);
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(10, 50),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: isLoading == false
                                ? Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  )
                                : LoadingAnimationWidget.halfTriangleDot(
                                    color: Colors.white, size: 20),
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
                              SvgPicture.asset(
                                  'assets/icons/devicon_google.svg'),
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
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            onPressed: () => GoRouter.of(context)
                                .go(LivingSeedAppRouter.signUpPath),
                            child: Text('Sign up',
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
            )
          ],
        ),
      ),
    );
  }
}
