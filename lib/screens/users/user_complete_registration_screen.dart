import 'package:flutter/material.dart';
import 'package:radar/models/user_model.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/_builds/build_user.dart';
import 'package:radar/utils/constants.dart';

class UserCompleteRegistrationScreen extends StatefulWidget {
  const UserCompleteRegistrationScreen({super.key});

  @override
  State<UserCompleteRegistrationScreen> createState() =>
      _UserCompleteRegistrationScreenState();
}

class _UserCompleteRegistrationScreenState
    extends State<UserCompleteRegistrationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Completer les informations",
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: gradient,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(
                            text: "Bienvenue ! ",
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                          buildText(
                            text:
                                "Nous sommes ravis de vous accueillir sur Radar. Completez vos informations personnelles.",
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w800,
                          ),
                          buildSpacer(),
                          buildAvatarPicker(),
                          Row(
                            children: [
                              Expanded(child: buildFirstNameField()),
                              Expanded(child: buildLastNameField()),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildEmailField(),
                              ),
                              Expanded(child: buildGender()),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildAccountTypeField(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    buildElevatedButtonIcon(
                        label: "Valider mes informations",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // formKey.currentState!.save();
                            // Call the controller to save the data
                            rxUserController.updateUser(UserModel(
                              id: rxUserController.currentUser.value!.id,
                              lastName: rxUserController
                                  .lastNameController.value.text,
                              firstName: rxUserController
                                  .firstNameController.value.text,
                              email:
                                  rxUserController.emailController.value.text,
                              accountType:
                                  rxUserController.selectedAccountType.value,
                              gender: rxUserController.selectedGender.value,
                              profileComplete: true,
                            ));
                          }
                        },
                        backgroundColor: primaryColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
