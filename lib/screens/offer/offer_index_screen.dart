import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/screens/users/user_signup_screen.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

class PlansSubscriptionsScreen extends StatefulWidget {
  const PlansSubscriptionsScreen({super.key});

  @override
  State<PlansSubscriptionsScreen> createState() =>
      _PlansSubscriptionsScreenState();
}

class _PlansSubscriptionsScreenState extends State<PlansSubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await rxUserController.checkIfUserAccountIsStarter(user!.uid);
    });
  }

  Widget buildText(String text,
      {double fontSize = 14, Color? color, FontStyle? fontStyle}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: fontSize,
            fontStyle: fontStyle,
            color: color ?? Colors.white,
          ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Offres membres"),
      body: Material(
        child: Container(
          decoration: const BoxDecoration(color: secondaryColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/svg/wallet_credit.svg",
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: buildText(
                    'Activez une offre pour publier un bien immobilier !'
                        .toUpperCase(),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: rxOfferSubscriptionController.offersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        var offerName = data["Nom de l'offre"];
                        var offerPrice = data["Montant"];
                        var offerNumberOfPublications =
                            data["Nombre de publications"];
                        var offerNumberOfDay = data["Nombre de jours"];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: <Color>[thirdColor, secondaryColor],
                              tileMode: TileMode.mirror,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  buildText(
                                    offerName.toString().toUpperCase(),
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  buildText(
                                    '$offerPrice Fcfa',
                                    fontSize: 30,
                                    color: primaryColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  Row(
                                    children: [
                                      buildText(
                                        offerNumberOfPublications.toString() ==
                                                "-1"
                                            ? 'Illimité'
                                            : '$offerNumberOfPublications publication(s)',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      const SizedBox(width: 20),
                                      buildText(
                                        offerNumberOfDay == 30
                                            ? '1 Mois'
                                            : '$offerNumberOfDay Jour(s)',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              buildElevatedButtonIcon(
                                label: "Activer l'offre".toUpperCase(),
                                icon: const Icon(Icons.credit_card),
                                onPressed: () async {
                                  Get.toNamed(Routes.addHouse);
                                  buildSnackbar(
                                    title: "Succès !",
                                    message:
                                        "Votre offre a été activée avec succès !",
                                  );
                                },
                                backgroundColor: primaryColor,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      if (rxUserController
                              .checkIfUserAccountIsStarter(user!.uid) ==
                          true)
                        Column(
                          children: [
                            buildText(
                              "Ou activez votre compte pour profiter de plus d'offres"
                                  .toUpperCase(),
                              fontSize: 20,
                            ),
                            buildElevatedButtonIcon(
                              backgroundColor: secondaryColor,
                              label: 'Devenir un membre actif',
                              icon: const Icon(Icons.verified_user_sharp),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UserSignUpScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
