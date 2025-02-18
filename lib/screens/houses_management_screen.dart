import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/screens/maps/main_maps_screen.dart';
import 'package:radar/utils/constants.dart';

class HousesManagementScreen extends StatefulWidget {
  const HousesManagementScreen({super.key});

  @override
  State<HousesManagementScreen> createState() => _HousesManagementScreenState();
}

class _HousesManagementScreenState extends State<HousesManagementScreen> {
  buildDivider() {
    return const Divider(
      height: 0,
      indent: 10,
      endIndent: 10,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(const MainMapsScreen());
        // Naviguer vers FirstPage
        return false; // Empêcher le retour par défaut
      },
      child: Scaffold(
        appBar: buildAppBar(
          title: "Gestion des biens",
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            ListTile(
              minLeadingWidth: 0,
              leading: SvgPicture.asset(
                'assets/svg/houses.svg',
                height: 20,
                color: primaryColor,
              ),
              title: const Text(
                "Mes biens immobiliers",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                    color: Colors.white),
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const MainMapScreenPersonnal()),
                // );
                // // Navigator.pop(context);
              },
            ),
            buildDivider(),
            ListTile(
              minLeadingWidth: 0,
              leading: SvgPicture.asset(
                'assets/svg/continuous_search.svg',
                height: 35,
                color: primaryColor,
              ),
              title: const Text(
                "Mes recherches continues",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                    color: Colors.white),
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const ContinuousResearchScreen()),
                // );
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
