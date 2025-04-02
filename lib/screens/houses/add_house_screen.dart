import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/_builds/build_image_picker.dart';
import 'package:radar/_builds/build_subscription_offer.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

class AddHouseScreen extends StatefulWidget {
  const AddHouseScreen({super.key});

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    rxOfferSubscriptionController.loadUserSubscriptions();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   rxHouseController.resetAllControllers();
    // });
    super.initState();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   rxHouseController.resetAllControllers();
    // });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (rxOfferSubscriptionController.offersSubscriptions.isEmpty ||
          rxOfferSubscriptionController
                  .offersSubscriptions.first.numberOfPublication ==
              0) {
        return Scaffold(
          appBar: buildAppBar(title: "Publier un bien immobilier"),
          body: buildLowCredit(),
        );
      }
      // -------------------------------
      return WillPopScope(
        onWillPop: () async {
          rxMapController.activateDefaultMode();
          return true;
        },
        child: Obx(
          () => Scaffold(
            appBar: buildAppBar(title: "Publier une bien immobilier"),
            body: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  Material(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: gradient,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Form(
                          key: formKey,
                          child: ListView(
                            padding: const EdgeInsets.all(10.0),
                            children: [
                              buildGrandTitle(
                                text: "Publier un bien immobilier",
                              ),
                              const SizedBox(height: 10),
                              buildInfoBlock(
                                text:
                                    "Il vous reste ${rxOfferSubscriptionController.offersSubscriptions.first.numberOfPublication} publication(s)",
                              ),
                              const SizedBox(height: 10),
                              buildTransactionType(),
                              const SizedBox(height: 10),
                              buildCategorie(),
                              buildArea(),
                              buildPrice(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildNumberOfFloors(),
                                  buildNumberOfBedrooms(),
                                  buildNumberOfLivingRooms(),
                                  buildNumberOfBathrooms(),
                                ],
                              ),
                              const SizedBox(height: 20),
                              buildOptionsSelection(),
                              buildSpacer(),
                              buildImagePicker(),
                              buildSpacer(),
                              buildDescription(),
                              buildSpacer(),
                              buildElevatedButtonIcon(
                                label: "Position sur la carte",
                                backgroundColor: Colors.black,
                                color: white,
                                icon: SvgPicture.asset(
                                  'assets/svg/location_house.svg',
                                  width: 20,
                                  color: white,
                                ),
                                onPressed: () {
                                  rxMapController.activatePickerHouseMode();
                                  Get.toNamed(Routes.mainMap);
                                },
                              ),
                              buildSpacer(),
                              Obx(
                                () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Adresse :',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    buildText(
                                      text: rxSearchPlaceController
                                          .placeName.value,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.visible,
                                      color: white,
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                              buildSpacer(),
                              buildValidateAddOrModifyHouse(formKey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
