import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

Drawer buildDrawer() {
  return Drawer(
    // Ajoutez ici le contenu de votre drawer
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        gradient: gradient,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.45,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                children: [
                  // Affichage dynamique de l'image du profil utilisateur
                  Stack(
                    children: [
                      Obx(
                        () => buildImageCircle(
                          rxUserController.currentUser.value!.avatar.toString(),
                          radius: 75,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: thirdColor,
                          onPressed: () {
                            Get.toNamed(Routes.userSettings);
                          },
                          child: Icon(
                            Icons.edit,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildSpacer(),
                  // Affichage dynamique du numéro de téléphone
                  buildText(
                    text: user?.phoneNumber ??
                        'Numéro de téléphone non disponible',
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),

                  // Affichage dynamique du type de compte
                  Obx(
                    () => buildText(
                      text: rxUserController.currentUser.value != null
                          ? "Type de compte : ${rxUserController.currentUser.value!.accountType}"
                          : "Type de compte : Non disponible",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Affichage dynamique de l'UID de l'utilisateur
                  buildText(
                    text: "UID : ${user?.uid}",
                    fontSize: 13,
                  ),
                  // Affichage dynamique du nom et prénom
                  if ((rxUserController
                              .currentUser.value?.firstName?.isNotEmpty ??
                          false) &&
                      (rxUserController
                              .currentUser.value?.lastName?.isNotEmpty ??
                          false)) ...[
                    buildText(
                      text:
                          "${rxUserController.currentUser.value!.firstName} ${rxUserController.currentUser.value!.lastName}",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    buildSpacer(),
                  ]
                ],
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/radar.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Radar Immobilier",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Get.back();
              rxMapController.activateDefaultMode();
            },
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/houses.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Gestion des biens",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Get.back();
              rxMapController.activatePropertyManagement();
            },
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/chat.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Chat",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Get.toNamed(Routes.discussionList);
            },
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/wallet_credit.svg',
                width: 20,
              ),
            ),
            title: buildText(
              text: "Offres d'abonnement",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Get.toNamed(Routes.offers);
            },
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/plans.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Mon abonnement",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Get.toNamed(Routes.offerSubscription);
            },
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/bell.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Notifications",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () => Get.toNamed(Routes.notifications),
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/target.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Zones d'activités",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () => Get.toNamed(
              Routes.activityZoneScreen,
            ),
          ),
          divider,
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/svg/settings.svg',
                width: 20,
                color: primaryColor,
              ),
            ),
            title: buildText(
              text: "Paramètres",
              fontSize: 18,
              color: white,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Get.toNamed(Routes.settings);
            },
          ),
        ],
      ),
    ),
  );
}
