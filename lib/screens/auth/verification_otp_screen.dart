import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:radar/utils/constants.dart';

class VerificationOtpScreen extends StatelessWidget {
  const VerificationOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return true; // Permettre le retour en arrière
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: gradient, // Définir le gradient dans vos constants
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/lock.svg',
                    width: Get.size.width * 0.5,
                  ),
                  const Text(
                    "Vérification OTP",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Vérifiez vos messages pour entrer le code OTP",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          primaryColor, // Définir `primaryColor` dans constants
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    controller: rxAuthController.otpController.value,
                    onChanged: (value) {
                      rxAuthController.smsCode.value = value;
                    },
                    autofocus: true,
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(() {
                      return TextButton(
                        onPressed: rxAuthController.resend.value
                            ? rxAuthController.onResendSmsCode
                            : null,
                        child: Text(
                          rxAuthController.resend.value
                              ? "Renvoyer le code OTP"
                              : "00:${rxAuthController.count.value.toString().padLeft(2, "0")}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: primaryColor, // Couleur du bouton
                            disabledBackgroundColor:
                                primaryColor.withOpacity(0.5),
                          ),
                          onPressed:
                              rxAuthController.smsCode.value.length < 6 ||
                                      rxAuthController.isLoading.value
                                  ? null
                                  : () {
                                      final String verificationId =
                                          rxAuthController.verificationId.value;
                                      rxAuthController.signInWithOTP(
                                        verificationId,
                                        rxAuthController.smsCode.value,
                                      );
                                    },
                          child: rxAuthController.isLoading.value
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Vérifier',
                                  style: TextStyle(fontSize: 20),
                                ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
