import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_carousel_images.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/utils/constants.dart';

class ShowHousePanel extends StatefulWidget {
  const ShowHousePanel({super.key});

  @override
  State<ShowHousePanel> createState() => _ShowHousePanelState();
}

class _ShowHousePanelState extends State<ShowHousePanel> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCarouselImage(
              rxHouseController.currentHouse.value.imageLinks ?? []),
          buildSpacer(),
          buildCategoryLabel(),
          buildSpacer(),
          buildHouseTitle(),
          buildSpacer(),
          buildPriceAndLocation(),
          buildPublishedDate(),
          buildLocationInfo(),
          // buildSpacer(),
          buildRatingBar(),
          buildSpacer(),
          buildRoomsInfo(),
          buildSpacer(),
          buildItineraryButton(),
          buildSpacer(),
          buildContactButton(),
        ],
      ),
    );
  }
}
