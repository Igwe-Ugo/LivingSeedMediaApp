// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widget.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({super.key});

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
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
                              .go(LivingSeedAppRouter.signUpPath);
                        },
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          size: 17,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Verify Account',
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
                'nwama****mail.com',
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
                padding: const EdgeInsets.symmetric(horizontal: 130),
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
                    //TimeCounter(seconds: _seconds),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Did\'nt get a code?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: null, //_seconds > 0 ? null : () => _resendOtp(),
                  child: Text('Resend',
                      style: TextStyle(
                          //color: _seconds > 0 ? Theme.of(context).dividerColor : Theme.of(context).primaryColorDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go(LivingSeedAppRouter.homePath);
                  }, // _verifyOtp(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context)
                        .primaryColor, //_isOtpEmpty == false ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
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

  /* OtpTextField get _getOtpEditor{
    return OtpTextField(
      obscureText: hideOtp,
      numberOfFields: 4,
      cursorColor: Theme.of(context).primaryColor,
      borderColor: Colors.grey,
      focusedBorderColor: Theme.of(context).primaryColor,
      showFieldAsBox: true, 
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      onSubmit: (String verificationCode){
        _checkOtpEmpty(verificationCode);
      },
    );
  } */
}
