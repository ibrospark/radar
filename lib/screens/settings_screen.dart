import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Paramètres'),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                buildListTile(
                  title: buildText(
                    text: "Modifier vos informations personnelles",
                    fontSize: 14,
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: white,
                  ),
                  onTap: () {
                    Get.toNamed(Routes.userSettings);
                  },
                ),
                buildListTile(
                  title: buildText(
                    text: "Zones d'activités",
                    fontSize: 14,
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: buildElevatedButtonIcon(
                    label: "Déconnexion",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      rxAuthController.disconnect();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
