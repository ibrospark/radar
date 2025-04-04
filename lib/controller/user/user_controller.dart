import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/user_model.dart';

class UserController extends GetxController {
  final Rx<User?> firebaseUser = FirebaseAuth.instance.currentUser.obs;
  RxList<UserModel> users = <UserModel>[].obs;
  Rxn<UserModel> currentUser = Rxn<UserModel>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  // Toutes les variables BEGIN -------------------------------------------------
  RxString idUser = "".obs;
  RxString lastName = "".obs;
  RxString firstName = "".obs;
  RxString gender = "".obs;
  RxString address = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString avatar = "".obs;
  RxString inscriptionDate = "".obs;
  RxString status = "".obs;
  RxString selectedAccountType = "".obs;
  RxString selectedGender = "".obs;

  // Controllers BEGIN -----------------------------------------------------------------
  Rx<TextEditingController> idUserController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> genderController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> avatarController = TextEditingController().obs;
  Rx<TextEditingController> inscriptionDateController =
      TextEditingController().obs;
  Rx<TextEditingController> statusController = TextEditingController().obs;
  Rx<TextEditingController> accountTypeController = TextEditingController().obs;
  Rx<TextEditingController> pseudoController = TextEditingController().obs;
  Rx<TextEditingController> birthdayController = TextEditingController().obs;
  Rx<TextEditingController> profileCompleteController =
      TextEditingController().obs;

  // Controllers END -----------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    // Bind stream for all users
    _bindUsersStream();
    // If firebaseUser is not null, bind the current user's stream
    if (firebaseUser.value != null) {
      _bindCurrentUserStream(firebaseUser.value!.uid);
    }
    // Watch changes to firebaseUser and update the currentUser stream accordingly
    ever(firebaseUser, (user) {
      if (user != null) {
        _bindCurrentUserStream(user.uid);
      } else {
        currentUser.value = null;
      }
    });
  }

  // Method to bind the stream for all users
  void _bindUsersStream() {
    _firestore.collection('users').snapshots().listen((querySnapshot) {
      // Update the users list with the fetched data in real-time
      users.value = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    }, onError: (e) {
      _handleError('Erreur lors de la récupération des utilisateurs', e);
    });
  }

  // Method to bind the stream for the current user's data
  void _bindCurrentUserStream(String userId) {
    _firestore.collection('users').doc(userId).snapshots().listen(
        (docSnapshot) {
      if (docSnapshot.exists) {
        currentUser.value =
            UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
        initializeControllersWithUser(currentUser.value!);
      }
    }, onError: (e) {
      _handleError(
          'Erreur lors de la récupération de l\'utilisateur courant', e);
    });
  }

  // Initialize controllers with the user's data
  void initializeControllersWithUser(UserModel user) {
    Map<String, TextEditingController> controllers = {
      'id': idUserController.value,
      'lastName': lastNameController.value,
      'firstName': firstNameController.value,
      'gender': genderController.value,
      'address': addressController.value,
      'email': emailController.value,
      'phone': phoneController.value,
      'avatar': avatarController.value,
      'inscriptionDate': inscriptionDateController.value,
      'status': statusController.value,
      'accountType': accountTypeController.value,
      'profileComplete': profileCompleteController.value,
    };

    controllers.forEach((key, controller) {
      var value = _getFieldValue(user, key);
      if (value != null) {
        controller.text = value;
      }
    });
  }

  // Method to fetch the value of a field from the UserModel
  String? _getFieldValue(UserModel user, String field) {
    switch (field) {
      case 'id':
        return user.id;
      case 'lastName':
        return user.lastName;
      case 'firstName':
        return user.firstName;
      case 'gender':
        return user.gender;
      case 'address':
        return user.address;
      case 'email':
        return user.email;
      case 'phone':
        return user.phoneNumber;
      case 'avatar':
        return user.avatar;
      case 'inscriptionDate':
        return user.registrationDate.toString();
      case 'status':
        return user.status.toString();
      case 'accountType':
        return user.accountType;
      default:
        return null;
    }
  }

  // Method to reset all controllers
  void resetControllers() {
    Map<String, TextEditingController> controllers = {
      'id': idUserController.value,
      'lastName': lastNameController.value,
      'firstName': firstNameController.value,
      'gender': genderController.value,
      'address': addressController.value,
      'email': emailController.value,
      'phone': phoneController.value,
      'avatar': avatarController.value,
      'inscriptionDate': inscriptionDateController.value,
      'status': statusController.value,
      'accountType': accountTypeController.value,
    };

    controllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        controller.clear();
      }
    });
  }

  // Method to handle errors
  void _handleError(String message, dynamic e) {
    if (kDebugMode) {
      print('$message: $e');
    }
    Get.snackbar('Erreur', message);
  }

  // Fetch all users from Firestore
  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      users.value = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _handleError('Erreur lors de la récupération des utilisateurs', e);
    }
  }

  // Fetch the current user from Firestore
  Future<void> fetchCurrentUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        currentUser.value =
            UserModel.fromMap(doc.data() as Map<String, dynamic>);
        initializeControllersWithUser(currentUser.value!);
      }
    } catch (e) {
      _handleError(
          'Erreur lors de la récupération de l\'utilisateur courant', e);
    }
  }

  // Create a new user in Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      users.add(user);
      if (kDebugMode) {
        print('Utilisateur créé avec succès');
      }
    } catch (e) {
      _handleError('Erreur lors de la création de l\'utilisateur', e);
    }
  }

  // Update an existing user in Firestore
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      int index = users.indexWhere((element) => element.id == user.id);
      if (index != -1) {
        users[index] = user;
      }
      buildSnackbar(
          title: "Succès !", message: 'Utilisateur mis à jour avec succès.');
    } catch (e) {
      _handleError('Erreur lors de la mise à jour de l\'utilisateur', e);
      buildSnackbar(title: "Erreur !", message: "Une erreur est survenue.");
    }
  }

  // Delete a user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      users.removeWhere((user) => user.id == userId);
    } catch (e) {
      _handleError('Erreur lors de la suppression de l\'utilisateur', e);
    }
  }

  // Check if a user exists in Firestore
  Future<bool> checkIfUserExists(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      _handleError('Erreur lors de la vérification de l\'utilisateur', e);
      return false;
    }
  }

  // Check if a user's account is of type "Starter"
  Future<bool> checkIfUserAccountIsStarter(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        String accountType = doc['Type de compte'] ?? 'Starter';
        return accountType == 'Starter';
      }
      return false;
    } catch (e) {
      _handleError('Erreur lors de la vérification du compte', e);
      return false;
    }
  }
}
