import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_draggable_scrollable_sheet.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/controller/maps/maps_controller.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

Widget buildGoogleMap(
  GlobalKey<ScaffoldState> scaffoldKey, {
  DraggableScrollableController? draggableScrollableController,
}) {
  draggableScrollableController ??= DraggableScrollableController();

  return SizedBox(
    width: Get.mediaQuery.size.width,
    height: Get.mediaQuery.size.height,
    child: Stack(
      children: [
        Obx(() {
          if (rxHouseController.houses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (rxMapController.isMapCreated.value) {
            if (!rxMapController.isPickerMode.value) {
              rxMapController.addFilteredFirebaseCircularMarker();
            }
          }

          return GetBuilder<MapController>(
            builder: (controller) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.currentUserLatLng.value,
                  zoom: 14.0,
                ),
                zoomGesturesEnabled: true,
                mapType: MapType.normal,
                onTap: (value) {
                  if (rxMapController.displayFilterPanel.value) {
                    rxDraggableScrollableSheetController
                        .resetExtent(draggableScrollableController!);
                  }
                },
                markers: controller.markers,
                polylines: controller.polylines,
                onMapCreated: controller.onMapCreated,
                onCameraIdle: controller.onCameraIdle,
                onCameraMove: (CameraPosition cameraPosition) {
                  controller.cameraPosition.value = cameraPosition;
                },
              );
            },
          );
        }),
        buildIconMap(),
        buildSearchBarLocation(),
        buildIconPickerHouse(),
        buildValidatePositionBtnLg(),
        buildCurrentPositionBtnLg(),
        buildCurrentPositionBtnCircular(),
        buildDrawerBtnCircular(scaffoldKey),
        buildFilterHousePanel(draggableScrollableController),
        buildDisplayRoute(),
      ],
    ),
  );
}

buildIconMap() {
  return Positioned(
    top: 0,
    left: 20,
    child: buildLogo(
      height: 15,
      color: primaryColor,
    ),
  );
}

buildIconPickerHouse({double? height = 50.0}) {
  return Obx(() {
    return rxMapController.displayIconPickerHouse.value
        ? Positioned(
            top: Get.size.height * 0.43,
            right: 0,
            left: 0,
            child: Center(
              child: Image.asset(
                'assets/mapicons/house_marker.png',
                height: height,
              ),
            ),
          )
        : Container();
  });
}

buildDrawerBtnCircular(scaffoldKey) {
  return Obx(() {
    return rxMapController.displayDrawerBtn.value
        ? Positioned(
            top: Get.size.height * 0.2,
            right: 20,
            child: buildCircularIconButton(
              icon: SvgPicture.asset(
                "assets/svg/explorer.svg",
                height: 30,
              ),
              backgroundColor: white,
              onPressed: () {
                rxUserController.fetchAllUsers();
                rxOfferController.fetchOffers();
                rxOfferSubscriptionController.loadUserSubscriptions();
                scaffoldKey.currentState?.openDrawer();
              },
            ),
          )
        : Container();
  });
}

buildCurrentPositionBtnCircular() {
  return Obx(() {
    return rxMapController.displayCurrentPositionBtnCircular.value
        ? Positioned(
            bottom: Get.size.height * 0.3 + 20,
            right: 20,
            child: buildCircularIconButton(
              icon: SvgPicture.asset(
                "assets/svg/maps_position.svg",
                height: 30,
              ),
              backgroundColor: white,
              onPressed: () {
                rxMapController.setCurrentLocation();
              },
            ),
          )
        : Container();
  });
}

buildValidatePositionBtnLg() {
  return Obx(() {
    return rxMapController.displayCurrentPositionBtnLg.value
        ? Positioned(
            bottom: Get.size.height * 0.1,
            right: 20,
            left: 20,
            child: Column(
              children: [
                buildElevatedButtonIcon(
                  label: 'Valider cette position',
                  icon: SvgPicture.asset(
                    "assets/svg/target.svg",
                    color: Colors.white,
                    height: 20,
                  ),
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    // Latitude de  la maison
                    rxMapController.currentHouseLatLng.value = LatLng(
                        rxMapController.cameraPosition.value.target.latitude,
                        rxMapController.cameraPosition.value.target.longitude);
                    // LatLng de  la maison
                    rxMapController.currentHouseLatLng.value =
                        rxMapController.cameraPosition.value.target;
                    // Assigner la nom de la place à la SearchPlaceController------------------
                    await rxSearchPlaceController.getPlaceNameFromLatLng(
                        rxMapController.cameraPosition.value.target.latitude,
                        rxMapController.cameraPosition.value.target.longitude);
                    // Désactiver le mode picker House de  la maison
                    rxMapController.activateDefaultMode();

                    // Retourner à l'écran ajout de  la maison
                    Get.back();
                  },
                ),
              ],
            ),
          )
        : Container();
  });
}

buildCurrentPositionBtnLg() {
  return Obx(() {
    return rxMapController.displayCurrentPositionBtnLg.value
        ? Positioned(
            bottom: Get.size.height * 0.03,
            right: 20,
            left: 20,
            child: Column(
              children: [
                buildElevatedButtonIcon(
                  label: 'Votre position actuelle',
                  icon: SvgPicture.asset(
                    "assets/svg/target.svg",
                    color: white,
                    height: 20,
                  ),
                  backgroundColor: secondaryColor,
                  color: white,
                  onPressed: () {
                    rxMapController.setCurrentLocation();
                  },
                ),
              ],
            ),
          )
        : Container();
  });
}

Widget buildFilterHousePanel(draggableScrollableController) {
  return Obx(() {
    return rxMapController.displayFilterPanel.value
        ? buildDraggableScrollableSheet(
            draggableScrollableController: draggableScrollableController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 35,
                      ),
                      const SizedBox(
                          width: 8), // Espacement entre l'icône et le texte
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Je".toUpperCase(),
                              style: buildTextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: " R".toUpperCase(),
                              style: buildTextStyle(
                                color: primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: "echerche Ici".toUpperCase(),
                              style: buildTextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildTransactionType(),
                  const SizedBox(height: 10),
                  buildCategorie(),
                  buildMinPrice(),
                  buildMaxPrice(),
                  buildArea(),
                  buildNumberOfFloors(),
                  buildNumberOfBedrooms(),
                  buildNumberOfLivingRooms(),
                  buildNumberOfBathrooms(),
                  buildOptionsSelection(),
                  buildFilterButton(),
                ],
              ),
            ),
          )
        : Container();
  });
}

buildSearchBarLocation() {
  return Obx(() {
    return rxMapController.displaySearchLocationBar.value
        ? Positioned(
            top: 50,
            right: 20,
            left: 20,
            height: Get.size.height * 0.08,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsetsDirectional.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.searchPlace);
                  },
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.search,
                          size: 40,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Obx(
                            () => buildText(
                              text: rxSearchPlaceController
                                      .placeName.value.isNotEmpty
                                  ? rxSearchPlaceController.placeName.value
                                  : "Rechercher un emplacement",
                              fontWeight: FontWeight.w600,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                      rxMapController.displayPublishBtn.isTrue
                          ? Expanded(
                              flex: 3,
                              child: buildElevatedButtonIcon(
                                icon: SvgPicture.asset(
                                  'assets/svg/houses.svg',
                                  width: 20,
                                  color: white,
                                ),
                                label: "Publier",
                                color: white,
                                backgroundColor: thirdColor,
                                onPressed: () {
                                  Get.toNamed(Routes.addHouse);
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  });
}

buildDisplayRoute() {
  return Obx(
    () => rxMapController.isRouteMode.value
        ? Positioned(
            bottom: Get.size.height * 0.05,
            right: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => buildText(
                        text:
                            "La distance est de : ${rxMapController.distanceInMeters.value.toStringAsFixed(2)} m",
                        color: white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      )),
                  buildSpacer(),
                  buildElevatedButtonIcon(
                    label: "Suivre l'itinéraire",
                    icon: const Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                    color: white,
                    fixedSize: Size(Get.size.width, 30),
                    onPressed: () {
                      rxMapController.openMap(
                          rxMapController.currentUserLatLng.value.latitude,
                          rxMapController.currentUserLatLng.value.longitude,
                          rxHouseController.currentHouse.value.coords!.latitude,
                          rxHouseController
                              .currentHouse.value.coords!.longitude);
                    },
                  ),
                  buildElevatedButtonIcon(
                    label: "Désactiver l'itineriaire",
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    backgroundColor: Colors.red,
                    fixedSize: Size(Get.size.width, 30),
                    onPressed: () {
                      rxMapController.activateDefaultMode();
                    },
                  )
                ],
              ),
            ),
          )
        : Container(),
  );
}
