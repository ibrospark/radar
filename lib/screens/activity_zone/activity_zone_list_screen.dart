import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/utils/constants.dart';

import '../../utils/routes.dart';

class ActivityZoneListScreen extends StatefulWidget {
  const ActivityZoneListScreen({super.key});

  @override
  State<ActivityZoneListScreen> createState() => _ActivityZoneListScreenState();
}

class _ActivityZoneListScreenState extends State<ActivityZoneListScreen> {
  List<String> activityZones = [
    'Almadies',
    'Medina',
    'Plateau',
    'Yoff',
    'Ngor',
    'Ouakam',
  ];

  void _handleMenuSelection(String value, int index) {
    switch (value) {
      case 'Modifier':
        // Handle edit action
        _editActivityZone(index);
        break;
      case 'Supprimer':
        // Handle delete action
        _deleteActivityZone(index);
        break;
    }
  }

  void _editActivityZone(int index) {
    // Implement edit functionality
    print('Edit activity zone: ${activityZones[index]}');
  }

  void _deleteActivityZone(int index) {
    setState(() {
      activityZones.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: buildElevatedButtonIcon(
                      onPressed: () {
                        rxMapController.activatePickerMode();
                        Get.toNamed(Routes.mainMap);
                      },
                      icon: Icon(Icons.add),
                      label: "Ajouter une zone d'activité",
                      backgroundColor: primaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: activityZones.length,
                    itemBuilder: (context, index) {
                      return buildListTile(
                        leading: Icon(
                          Icons.location_searching,
                          color: primaryColor,
                        ),
                        title: Text(activityZones[index]),
                        trailing: PopupMenuButton<String>(
                          color: Colors.white,
                          onSelected: (String value) {
                            _handleMenuSelection(value, index);
                          },
                          itemBuilder: (BuildContext context) {
                            return {'Modifier', 'Supprimer'}
                                .map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      );
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
