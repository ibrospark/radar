import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_activity_zone.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/models/activity_zone_model.dart';

import '../../utils/constants.dart';

class ActivityZoneListScreen extends StatefulWidget {
  const ActivityZoneListScreen({super.key});

  @override
  State<ActivityZoneListScreen> createState() => _ActivityZoneListScreenState();
}

class _ActivityZoneListScreenState extends State<ActivityZoneListScreen> {
  final rxActivityZone = <ActivityZone>[].obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        rxMapController.activateDefaultMode();

        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(
          title: "Zones d'activité",
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildText(
                      text: "Liste des zones d'activité",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buildSpacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: buildInfoBlock(
                      text:
                          "Pour recevoir des notifications sur les zones d'activité, veuillez ajouter les zones qui vous intéressent.",
                    ),
                  ),
                  buildSpacer(),
                  buildAddActivityZoneButton(),
                  buildActivityZoneList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
