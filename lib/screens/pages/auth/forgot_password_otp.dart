// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/custom_route.dart';

class ForgotPasswordOTP extends StatefulWidget {
  const ForgotPasswordOTP({super.key});

  @override
  State<ForgotPasswordOTP> createState() => _ForgotPasswordOTPState();
}

class _ForgotPasswordOTPState extends State<ForgotPasswordOTP> {
  bool hideOtp = true;
  String otpCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .go(LivingSeedAppRouter.loginPath);
                        },
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          size: 17,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'A 4-digit code was sent to',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const Text(
                'nwamadi****mail.com',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 70),
                child: SizedBox(), //_getOtpEditor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          hideOtp = !hideOtp;
                        });
                      },
                      icon: Icon(
                        hideOtp
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Did\'nt get a code?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Resend',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context)
                      .go(LivingSeedAppRouter.forgotPasswordPath),
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
                        'Continue',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: Colors.black),
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }

  /* OtpTextField get _getOtpEditor {
    return OtpTextField(
      obscureText: hideOtp,
      numberOfFields: 4,
      enabledBorderColor: Theme.of(context).primaryColor,
      disabledBorderColor: Colors.grey,
      showFieldAsBox: true,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      onSubmit: (String verificationCode) {
        _checkOtpEmpty(verificationCode);
      },
    );
  } */
}
