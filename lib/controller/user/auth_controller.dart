import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

class AuthController extends GetxController {
  var phoneNumber = ''.obs;
  var smsCode = ''.obs;
  var isLoading = false.obs;
  var resend = true.obs;
  var count = 30.obs;
  var verificationId = ''.obs;
  final phoneNumberController = TextEditingController().obs;
  final otpController = TextEditingController().obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    startCountdown();
  }

  void sendOtpCode() {
    if (phoneNumber.isNotEmpty) {
      verifyPhoneNumber(phoneNumber.value);
    } else {
      _showErrorSnackbar("Numéro de téléphone non valide.");
    }
  }

  void verifyPhoneNumber(String phoneNumber) async {
    isLoading.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorSnackbar(e.message ?? "Une erreur est survenue.");
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          _showSuccessSnackbar("Vérifiez vos SMS.");
          Get.toNamed(Routes.verificationOtp);
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );
    } catch (e) {
      _showErrorSnackbar("Une erreur est survenue lors de la vérification: $e");
    } finally {}
  }

  Future<void> signInWithOTP(String verificationId, String smsCode) async {
    isLoading.value = true;
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await _signInWithCredential(credential);
    } catch (e) {
      _showErrorSnackbar("Code incorrect ou expiré.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _registerNewUser(userCredential);
        _showSuccessSnackbar("Bienvenue sur Radar !");
        Get.offAllNamed(Routes.userCompleteRegistration);
      } else {
        _showSuccessSnackbar("Ravi de vous revoir !");
        if (rxUserController.currentUser.value!.profileComplete == false) {
          Get.offAllNamed(Routes.userCompleteRegistration);
        } else {
          Get.offAllNamed(Routes.mainMap);
        }
      }
    } catch (e) {
      _showErrorSnackbar("Échec de la connexion: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _registerNewUser(UserCredential userCredential) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'Id': userCredential.user?.uid,
        'Avatar':
            'https://firebasestorage.googleapis.com/v0/b/radar-2024.appspot.com/o/default%2Favatar.png?alt=media&token=7aa4a52d-83c3-45ec-ae93-c9566a484b75',
        'Tel': userCredential.user?.phoneNumber,
        'Date inscription': DateTime.now(),
        'Type de compte': "Starter",
        'Statut': 0,
        'profileComplete': false,
        'fcmToken': '',
      });

      // Abonnement de 5 publications
      rxOfferSubscriptionController.addSubscription(
        name: 'Offre Starter',
        price: 0,
        numberOfPublication: 5,
        numberOfDay: 90,
      );
    } catch (e) {
      _showErrorSnackbar(
          "Erreur lors de l'enregistrement de l'utilisateur: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onResendSmsCode() {
    if (count.value == 0 && resend.value) {
      resend.value = false;
      sendOtpCode();
      startCountdown();
    }
  }

  void startCountdown() {
    if (!resend.value) {
      Future.delayed(const Duration(seconds: 1), () {
        if (count.value > 0) {
          count.value--;
          startCountdown();
        } else {
          resend.value = true;
          count.value = 30;
        }
      });
    }
  }

  Future<void> disconnect() async {
    phoneNumber.value = '';
    smsCode.value = '';
    phoneNumberController.value.clear();
    isLoading.value = false;
    resend.value = true;
    count.value = 30;

    await _auth.signOut();
    Get.offAllNamed(Routes.home);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar("Erreur", message);
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar("Succès", message);
  }
}
