import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

buildLowCredit() {
  return Container(
    decoration: BoxDecoration(gradient: gradient),
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/svg/low-performance.svg",
          width: Get.size.width * 0.7,
        ),
        buildSpacer(
          height: 30,
        ),
        buildText(
            text: "Le nombre de publication(s) de votre abonnement est épuisé.",
            color: primaryColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            overflow: TextOverflow.visible,
            fontSize: 20,
            textAlign: TextAlign.center),
        buildSpacer(),
        buildElevatedButtonIcon(
          label: "Activer un nouvel abonnement",
          fixedSize: Size(
            Get.width,
            30,
          ),
          backgroundColor: primaryColor,
          onPressed: () {
            Get.back();
            Get.toNamed(Routes.offers);
          },
        ),
        buildElevatedButtonIcon(
          label: "Retourner sur le Radar",
          fixedSize: Size(
            Get.width,
            30,
          ),
          backgroundColor: thirdColor,
          color: white,
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
}
