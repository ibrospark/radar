import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/routes.dart';
import '../utils/constants.dart';

PreferredSizeWidget? buildAppBar({
  String? title = "Acceuil",
  List<Widget>? actions,
}) {
  return AppBar(
    title: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildText(
            text: title!,
            color: thirdColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: buildLogo(
            color: thirdColor,
            height: 100,
          ),
        ),
      ],
    ),
    actions: actions,
    backgroundColor: primaryColor,
  );
}

void buildSnackbar({
  String title = "Information", // Titre par défaut
  String? message, // Message optionnel
  SnackPosition position = SnackPosition.TOP,
  Color backgroundColor = Colors.green,
  Color textColor = Colors.white,
  Icon? icon,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title,
    message ?? '', // Si message est nul, utilise une chaîne vide
    snackPosition: position,
    backgroundColor: backgroundColor,
    colorText: textColor,
    duration: duration,
    borderRadius: 8,
    margin: const EdgeInsets.all(10),
    icon:
        icon ?? const Icon(Icons.info, color: Colors.white), // Icône par défaut
  );
}

// Text ----------------------------------------------------------------------
buildText({
  String? text,
  strutStyle,
  textDirection,
  locale,
  TextOverflow? overflow = TextOverflow.ellipsis,
  textScaleFactor,
  int? maxLines,
  semanticsLabel,
  textWidthBasis,
  textHeightBehavior,
  selectionColor,
  double? fontSize = 14,
  fontWeight = FontWeight.w300,
  fontStyle = FontStyle.normal,
  color = Colors.black,
  TextAlign? textAlign = TextAlign.left,
  textDecoration = TextDecoration.none,
  initialValue,
}) {
  return Text(
    text!,
    style: GoogleFonts.sourceSans3(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.1,
      color: color,
      decoration: textDecoration,
    ),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: true,
    overflow: overflow,
    textScaleFactor: textScaleFactor,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );
}

TextStyle? buildTextStyle({
  required Color? color,
  double? fontSize = 12,
  FontWeight? fontWeight = FontWeight.normal,
  FontStyle? fontStyle = FontStyle.normal,
}) {
  return GoogleFonts.sourceSans3(
    textStyle: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    ),
  );
}

// ListTile ----------------------------------------------------------------------
buildListTile({
  Widget? leading,
  Widget? title,
  Widget? subtitle,
  void Function()? onTap,
  Color? backgroundColor = thirdColor,
  Color? tileColor = Colors.transparent,
  Widget? trailing,
  bool dense = false,
}) {
  return Container(
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    width: Get.mediaQuery.size.width * 0.10,
    decoration: BoxDecoration(
      gradient: gradient,
      boxShadow: [
        boxShadow,
      ],
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: trailing,
      tileColor: tileColor,
      titleTextStyle: TextStyle(
        color: white,
      ),
      dense: dense,
    ),
  );
}

// LabelWithText ----------------------------------------------------------------------
buildLabelWithText({
  label,
  text,
  fontSize = 13.0,
  color,
}) {
  return Wrap(
    children: [
      buildText(
        text: label,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: color,
      ),
      const SizedBox(
        width: 10,
      ),
      buildText(
        text: text,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        color: color,
      ),
    ],
  );
}
// FloatingActionButton ----------------------------------------------------------------------

buildFloatingActionButton({
  onPressed,
  tooltip,
}) {
  return FloatingActionButton(
    tooltip: tooltip,
    backgroundColor: secondaryColor,
    onPressed: onPressed,
    child: const Icon(Icons.add),
  );
}

// Fonction pour construire un bouton circulaire réutilisable
Widget buildCircularIconButton({
  required Widget icon,
  Color color = Colors.white,
  Color backgroundColor = primaryColor,
  double radius = 20.0,
  double? padding = 10,
  required VoidCallback onPressed,
}) {
  return CircleAvatar(
    backgroundColor: backgroundColor,
    radius: radius,
    child: IconButton(
      padding: EdgeInsets.all(padding!.toDouble()),
      icon: icon,
      color: color,
      onPressed: onPressed,
    ),
  );
}

buildGrandTitle({
  required String text,
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.w800,
  FontStyle fontStyle = FontStyle.normal,
  textAlign = TextAlign.center,
  color = Colors.black,
}) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: buildText(
      text: text.toUpperCase(),
      textAlign: textAlign,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      overflow: TextOverflow.visible,
    ),
  );
}

Widget buildLogo({
  color = primaryColor,
  double? height = 50.0,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    child: SvgPicture.asset(
      'assets/svg/logo.svg',
      color: color,
      height: height!.toDouble(),
    ),
  );
}

Widget buildImageCircle(
  String imageUrl, {
  double radius = 50.0,
  Color borderColor = Colors.white,
  String imageType = "Network",
}) {
  return Container(
    width: radius * 2 + 4, // Diamètre + largeur de la bordure
    height: radius * 2 + 4, // Diamètre + largeur de la bordure
    decoration: BoxDecoration(
      shape: BoxShape.circle, // Forme circulaire
      border: Border.all(
        color: borderColor, // Couleur de la bordure
        width: 2, // Largeur de la bordure
      ),
    ),
    child: ClipOval(
      child: Builder(
        builder: (context) {
          switch (imageType) {
            case "Asset":
              return Image.asset(
                imageUrl,
                width: radius * 2, // Diamètre
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(radius);
                },
              );
            case "File":
              return Image.file(
                File(imageUrl),
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(radius);
                },
              );
            case "Network":
            default:
              return Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(radius);
                },
              );
          }
        },
      ),
    ),
  );
}

Widget _buildPlaceholder(double radius) {
  return Container(
    width: radius * 2,
    height: radius * 2,
    color: Colors.grey[200], // Couleur de fond du placeholder
    child: Icon(
      Icons.person, // Icône par défaut pour le placeholder
      size: radius,
      color: Colors.grey[400],
    ),
  );
}

buildSpacer({
  double? height = 20,
  double? width = 0,
  Widget? child,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: child,
  );
}

Widget buildNoPermission() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "Vous n'avez pas encore de permission d'ajouter une annonce !"),
          const SizedBox(height: 20),
          buildElevatedButtonIcon(
            label: "Consulter le tarif",
            onPressed: () {
              Get.toNamed(Routes.planSubscription);
            },
            backgroundColor: primaryColor,
          ),
        ],
      ),
    ),
  );
}

buildCongratulationsPopupDialog({String text = ""}) {
  return Get.dialog(
    Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: Get.size.width * 0.8,
          height: Get.size.height * 0.4,
          decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(
                20,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/checked.svg",
                width: Get.size.width * 0.3,
              ),
              buildGrandTitle(
                text: "Félicitation!",
                color: primaryColor,
              ),
              buildSpacer(),
              buildText(
                text: text,
                color: white,
              ),
              buildSpacer(),
              buildElevatedButtonIcon(
                fixedSize: Size(double.infinity, 30),
                label: "Fermer",
                backgroundColor: thirdColor,
                color: white,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
