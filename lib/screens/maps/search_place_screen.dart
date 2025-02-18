import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';

class SearchPlaceScreen extends StatelessWidget {
  const SearchPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: buildAppBar(title: "Rechercher un emplacement"),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildText(
                    textAlign: TextAlign.start,
                    text: "Que recherchez-vous?",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  Obx(
                    () => buildTextFormField(
                      disableLabel: true,
                      onChanged: (value) {
                        rxSearchPlaceController.autoCompleteSearch(value);
                        rxSearchPlaceController.placeName.value = value;
                      },
                      labelText: rxSearchPlaceController.placeName.value,
                    ),
                  ),
                ],
              ),
            ),
            // Autocomplete Suggestions
            Expanded(
              child: rxSearchPlaceController.predictions.isEmpty
                  ? Center(
                      child: buildLogo(),
                    )
                  : ListView.builder(
                      itemCount: rxSearchPlaceController.predictions.length,
                      itemBuilder: (context, index) {
                        final prediction =
                            rxSearchPlaceController.predictions[index];
                        return buildListTile(
                          title: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/maps_marker.svg",
                                width: 20,
                                color: white,
                              ),
                              buildSpacer(width: 20, height: 0),
                              Expanded(
                                child: buildText(
                                  text: " ${prediction['description']}",
                                  color: white,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                          tileColor: white,
                          onTap: () {
                            rxMapController.handlePlaceSelection(
                                prediction['place_id'], prediction);
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
