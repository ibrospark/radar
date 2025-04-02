import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';
import '../utils/routes.dart';

Widget buildAddActivityZoneButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: buildElevatedButtonIcon(
      onPressed: () {
        rxMapController.activatePickerActivityZone();
        Get.toNamed(Routes.mainMap);
      },
      icon: Icon(Icons.add),
      label: "Ajouter une zone d'activité",
      backgroundColor: primaryColor,
    ),
  );
}

Widget buildActivityZoneList() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: rxActivityZoneController.activityZones.length,
        itemBuilder: (context, index) {
          return buildListTile(
            leading: Icon(
              Icons.location_searching,
              color: primaryColor,
            ),
            title: Text(rxActivityZoneController.activityZones[index].name),
            trailing: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (String value) async {
                switch (value) {
                  case 'Supprimer':
                    await rxActivityZoneController.deleteActivityZone(
                        rxActivityZoneController.activityZones[index].id);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Supprimer'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          );
        },
      );
    }),
  );
}
