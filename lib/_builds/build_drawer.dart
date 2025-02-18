// ignore_for_file: deprecated_member_use
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
        gradient: gradient,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: Get.size.height * 0.4,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                children: [
                  // Affichage dynamique de l'image du profil utilisateur
                  Obx(
                    () => buildImageCircle(
                      rxUserController.currentUser.value!.avatar.toString(),
                      radius: 75,
                    ),
                  ),
                  buildSpacer(),
                  // Affichage dynamique du numéro de téléphone
                  buildText(
                    text: user?.phoneNumber ??
                        'Numéro de téléphone non disponible',
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    overflow: TextOverflow.visible,
                  ),

                  // Affichage dynamique du type de compte
                  Obx(
                    () => buildText(
                      text: rxUserController.currentUser.value != null
                          ? "Type de compte : ${rxUserController.currentUser.value!.accountType}"
                          : "Type de compte : Non disponible",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  // Affichage dynamique de l'UID de l'utilisateur
                  buildText(
                    text: "UID : ${user?.uid}",
                    overflow: TextOverflow.visible,
                    fontSize: 13,
                  ),
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
              Get.toNamed(Routes.mainMap);
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
                'assets/svg/maps_marker.svg',
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
