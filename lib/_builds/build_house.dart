import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_carousel_images.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildDescription() {
  return Obx(() {
    return buildTextFormField(
      controller: rxHouseController.descriptionController.value,
      labelText: 'Description',
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 6,
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Veuillez saisir la description';
      //   }
      //   return null;
      // },
    );
  });
}

Widget buildPrice() {
  return Obx(() {
    return buildTextFormField(
      controller: rxHouseController.priceController.value,
      labelText: 'Prix',
      keyboardType: TextInputType.number,
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir un prix';
        }
        final parsedValue = int.tryParse(value);
        if (parsedValue == null) {
          return 'Veuillez saisir un prix valide';
        }
        return null;
      },
      suffix:
          rxHouseController.selectedTransactionType.value.contains("A louer")
              ? buildRentalDuration()
              : null,
    );
  });
}

Widget buildMinPrice() {
  return Obx(() {
    return buildTextFormField(
      controller: rxHouseController.minPriceController.value,
      labelText: 'Prix Minimum',
      keyboardType: TextInputType.number,
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir un prix minimum';
        }
        final parsedValue = int.tryParse(value);
        if (parsedValue == null) {
          return 'Veuillez saisir un prix valide';
        }
        return null;
      },
    );
  });
}

Widget buildMaxPrice() {
  return Obx(() {
    return buildTextFormField(
      controller: rxHouseController.maxPriceController.value,
      labelText: 'Prix Maximum',
      keyboardType: TextInputType.number,
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir un prix maximum';
        }
        final parsedValue = int.tryParse(value);
        if (parsedValue == null) {
          return 'Veuillez saisir un prix valide';
        }
        return null;
      },
    );
  });
}

Widget buildTransactionType() {
  return Obx(() {
    return Row(
      children: transactionsTypeList.map((transaction) {
        return Expanded(
          child: buildRadioButton(
            title: transaction,
            value: transaction,
            selectedGroupValue: rxHouseController.selectedTransactionType.value,
            onChanged: (newValue) {
              rxHouseController.selectedTransactionType.value = newValue!;
            },
          ),
        );
      }).toList(),
    );
  });
}

Widget buildCategorie() {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: buildText(
            text: 'Categories',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.left,
          ),
        ),
        buildWrapTextFormField(
          child: buildDropdownButton(
            items: categoriesList,
            selectedItem: rxHouseController.selectedCategory.value,
            onChanged: (String? value) {
              rxHouseController.selectedCategory.value = value!;
            },
          ),
        )
      ],
    );
  });
}

Widget buildRentalDuration() {
  return Obx(() {
    return SizedBox(
      height: 35,
      child: buildDropdownButton(
        isExpanded: false,
        items: rentalDurationList,
        selectedItem: rxHouseController.selectedRentalDuration.value,
        onChanged: (String? value) {
          rxHouseController.selectedRentalDuration.value = value!;
        },
      ),
    );
  });
}

Widget buildCurrency() {
  return Obx(() {
    return buildWrapTextFormField(
      child: buildDropdownButton(
        items: currenciesList,
        selectedItem: rxHouseController.selectedCurrency.value,
        onChanged: (String? value) {
          rxHouseController.selectedCurrency.value = value!;
        },
      ),
    );
  });
}

Widget buildArea() {
  return Obx(() {
    return buildTextFormField(
      controller: rxHouseController.areaController.value,
      labelText: 'Superficie',
      keyboardType: TextInputType.number,
      suffix: const Text(
        'm²',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  });
}

Widget buildNumberOfBedrooms() {
  return Obx(() {
    if ([
      'Appartement',
      'Chambre',
      'Villa',
      'Maison',
      'Maison de vacance',
      'Studio',
    ].contains(rxHouseController.selectedCategory.value)) {
      return buildTextFormField(
        controller: rxHouseController.numberOfBedroomsController.value,
        labelText: 'Nombre de chambre(s)',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir le nombre de chambre(s)';
          }
          final parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue <= 0) {
            return 'Veuillez saisir un nombre valide de chambre(s)';
          }
          return null;
        },
      );
    } else {
      return Container();
    }
  });
}

Widget buildNumberOfLivingRooms() {
  return Obx(() {
    if ([
      'Appartement',
      'Villa',
      'Maison',
      'Maison de vacance',
      'Studio',
    ].contains(rxHouseController.selectedCategory.value)) {
      return buildTextFormField(
        controller: rxHouseController.numberOfLivingRoomsController.value,
        labelText: 'Nombre de Salon(s)',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir le nombre de salon(s)';
          }
          final parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue <= 0) {
            return 'Veuillez saisir un nombre valide de salon(s)';
          }
          return null;
        },
      );
    } else {
      return Container();
    }
  });
}

Widget buildNumberOfBathrooms() {
  return Obx(() {
    if ([
      'Appartement',
      'Villa',
      'Maison',
      'Maison de vacance',
      'Studio',
    ].contains(rxHouseController.selectedCategory.value)) {
      return buildTextFormField(
        controller: rxHouseController.numberOfBathroomsController.value,
        labelText: 'Nombre de salle(s) de bain',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir le nombre de salle(s) de  bain';
          }
          final parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue <= 0) {
            return 'Veuillez saisir un nombre valide de salle(s) de  bain';
          }
          return null;
        },
      );
    } else {
      return Container(); // Widget vide si la condition n'est pas remplie
    }
  });
}

Widget buildOptionsSelection() {
  return Obx(() {
    if ([
      'Appartement',
      'Villa',
      'Maison',
      'Maison de vacance',
      'Studio',
    ].contains(rxHouseController.selectedCategory.value)) {
      return Column(
        children: [
          buildText(
            text: "Sélectionner une option",
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          buildSpacer(),
          buildMultipleSelection(
            optionsList: optionsList,
            selectedOptions: rxHouseController.selectedOptions,
            onChanged: (List<String> newSelectedOptions) {
              rxHouseController.selectedOptions.value =
                  newSelectedOptions; // Mettez à jour la liste des options sélectionnées
            },
          ),
        ],
      );
    } else {
      return Container(); // Retourne un widget vide si la condition n'est pas remplie
    }
  });
}

Widget buildNumberOfFloors() {
  return Obx(() {
    if (rxHouseController.selectedCategory.value == 'Immeuble' ||
        rxHouseController.selectedCategory.value == 'Villa') {
      return buildTextFormField(
        controller: rxHouseController.numberOfFloorsController.value,
        labelText: 'Nombre d\'étage(s)',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir le nombre d\'étages(s)';
          }
          final parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue <= 0) {
            return 'Veuillez saisir un nombre valide d\'étages(s)';
          }
          return null;
        },
      );
    } else {
      return Container();
    }
  });
}

Widget buildValidateAddOrModifyHouse(formKey) {
  return Obx(() {
    return buildElevatedButtonIcon(
      label: rxHouseController.isUpdateHouse.value
          ? 'Modifier bien immobilier'
          : 'Ajouter bien immobilier',
      backgroundColor: primaryColor,
      icon: const Icon(Icons.check),
      onPressed: () async {
        if (formKey.currentState?.validate() ?? false) {
          // Resumé de l'annonce
          buildRecapHouse();
        } else {
          // Form is invalid
          buildSnackbar(
              title: "Erreur",
              message: "Veuillez remplir tous les champs obligatoires.",
              backgroundColor: Colors.red);
        }
      },
    );
  });
}

Widget buildProgress() {
  return Obx(() {
    final uploadTask = rxImageController.uploadTask.value;
    if (uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            int percentage = (progress * 100).toInt();
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '$percentage%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(height: 50);
          }
        },
      );
    } else {
      return const SizedBox(height: 50);
    }
  });
}

buildRecapHouseLinesTemplate(String label, String value) {
  return Column(
    children: [
      Row(
        children: [
          buildText(
            text: label,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: buildText(
                text: value,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                maxLines: 5),
          ),
        ],
      ),
      const Divider(
        height: 20,
        thickness: 1,
        indent: 0,
        endIndent: 0,
        color: Colors.grey,
      )
    ],
  );
}

Widget buildInfoBlock({
  String? text = '',
  Color? color = thirdColor,
  Color? backgroundColor = yellowColor,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: backgroundColor,
    ),
    padding: const EdgeInsets.all(15),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info,
          color: color,
          size: 15,
        ),
        buildSpacer(
          width: 20,
          height: 0,
        ),
        Expanded(
          child: buildText(
            text: text,
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            overflow: TextOverflow.visible,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}

Future<void> buildRecapHouse() async {
  await Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height - 20,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Récapitulatif :".toUpperCase(),
                  style: Get.textTheme.titleLarge!.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                buildRecapHouseLinesTemplate(
                  'Description',
                  rxHouseController.descriptionController.value.text,
                ),
                buildRecapHouseLinesTemplate(
                  'Prix',
                  '${rxHouseController.priceController.value.text} ${rxHouseController.selectedCurrency.value}',
                ),
                buildRecapHouseLinesTemplate(
                  'Type de transaction',
                  rxHouseController.selectedTransactionType.value,
                ),
                buildRecapHouseLinesTemplate(
                  'Catégorie',
                  rxHouseController.selectedCategory.value,
                ),
                buildRecapHouseLinesTemplate(
                  'Superficie',
                  '${rxHouseController.areaController.value.text} m²',
                ),
                if ([
                  'Appartement',
                  'Chambre',
                  'Villa',
                  'Maison',
                  'Maison de vacance',
                  'Studio',
                ].contains(rxHouseController.selectedCategory.value))
                  buildRecapHouseLinesTemplate(
                    'Nombre de chambre(s)',
                    rxHouseController.numberOfBedroomsController.value.text,
                  ),
                if ([
                  'Appartement',
                  'Villa',
                  'Maison',
                  'Maison de vacance',
                  'Studio',
                ].contains(rxHouseController.selectedCategory.value))
                  buildRecapHouseLinesTemplate(
                    'Nombre de Salon(s)',
                    rxHouseController.numberOfLivingRoomsController.value.text,
                  ),
                if ([
                  'Appartement',
                  'Villa',
                  'Maison',
                  'Maison de vacance',
                  'Studio',
                ].contains(rxHouseController.selectedCategory.value))
                  buildRecapHouseLinesTemplate(
                    'Nombre de salle(s) de bain',
                    rxHouseController.numberOfBathroomsController.value.text,
                  ),
                if (rxHouseController.selectedCategory.value == 'Immeuble' ||
                    rxHouseController.selectedCategory.value == 'Villa')
                  buildRecapHouseLinesTemplate(
                    'Nombre d\'étage(s)',
                    rxHouseController.numberOfFloorsController.value.text,
                  ),
                const SizedBox(height: 10),
                buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildActionButtons() {
  // return Obx(() {
  return Column(
    children: [
      buildElevatedButtonIcon(
        label: "J'ai fais une erreur",
        icon: const Icon(Icons.cancel),
        backgroundColor: Colors.red,
        onPressed: () {
          Get.back();
        },
      ),
      buildElevatedButtonIcon(
        label: "Je confirme mes informations",
        icon: const Icon(Icons.check),
        backgroundColor: Colors.green,
        onPressed: () async {
          // Uploader limage
          await rxImageController.uploadFile();
          // Ajouter la maison
          rxHouseController.publishOrUpdateHouse();
          // enlever le nombre de publication
          await rxOfferSubscriptionController.decreasePublicationCount(0, 1);
          // Form is valid
          Get.snackbar("Succès", "Formulaire validé");
          buildSnackbar(
              title: "Succès",
              message: "Maison ajoutée avec succees !",
              backgroundColor: Colors.green);
        },
      ),
    ],
  );
  // });
}

Widget buildFilterButton() {
  return buildElevatedButtonIcon(
    label: 'Activer le radar',
    icon: SvgPicture.asset('assets/svg/radar.svg'),
    backgroundColor: primaryColor,
    fixedSize: Size(Get.size.width, 40),
    onPressed: () {
      rxMapController.addFilteredFirebaseCircularMarker();
    },
  );
}

// Diplay  fields ------------------------------------------------------

Widget buildCategoryLabel() {
  return Obx(
    () => Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: primaryColor),
      child: buildText(
        text: rxHouseController.currentHouse.value.category ?? "Non spécifié",
      ),
    ),
  );
}

Widget buildHouseTitle() {
  return Obx(
    () => buildText(
      text: rxHouseController.currentHouse.value.title ?? "Titre non spécifié",
      fontSize: 30,
      fontWeight: FontWeight.w800,
      overflow: TextOverflow.visible,
    ),
  );
}

Widget buildPriceAndLocation() {
  return Obx(
    () => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildText(
          text:
              "${rxHouseController.currentHouse.value.price ?? "Prix non spécifié"} ${rxHouseController.currentHouse.value.currency ?? "Devise non spécifiée"} ${rxHouseController.currentHouse.value.rentalDuration ?? "Durée locative non spécifiée"}",
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w800,
          color: primaryColor,
        ),
        const Icon(
          Icons.favorite_border_outlined,
          color: Colors.grey,
        ),
      ],
    ),
  );
}

Widget buildPublishedDate() {
  return Obx(
    () => RichText(
      text: TextSpan(
        text: 'Publié le :  ',
        style: buildTextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: rxHouseController.currentHouse.value.createdAt != null
                ? '${rxHouseController.currentHouse.value.createdAt!.day}-${rxHouseController.currentHouse.value.createdAt!.month}-${rxHouseController.currentHouse.value.createdAt!.year}'
                : 'Date non spécifiée',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget buildLocationInfo() {
  return Obx(
    () => Row(
      children: [
        const Icon(Icons.location_on),
        buildText(
            text: rxHouseController.currentHouse.value.address ??
                "Adresse non spécifiée"),
      ],
    ),
  );
}

Widget buildRatingBar() {
  return Row(
    children: [
      RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 20.0,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Color.fromARGB(255, 240, 184, 18),
        ),
        onRatingUpdate: (rating) {
          if (kDebugMode) {
            print(rating);
          }
        },
      ),
    ],
  );
}

Widget buildRoomsInfo() {
  return Obx(
    () => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (rxHouseController.currentHouse.value.numberOfBedrooms != null &&
            rxHouseController.currentHouse.value.numberOfBedrooms! > 0)
          buildRoomIcon('assets/svg/chambres.svg',
              'x ${rxHouseController.currentHouse.value.numberOfBedrooms}'),
        if (rxHouseController.currentHouse.value.numberOfBathrooms != null &&
            rxHouseController.currentHouse.value.numberOfBathrooms! > 0)
          buildRoomIcon('assets/svg/douche2.svg',
              'x ${rxHouseController.currentHouse.value.numberOfBathrooms}'),
        if (rxHouseController.currentHouse.value.numberOfLivingRooms != null &&
            rxHouseController.currentHouse.value.numberOfLivingRooms! > 0)
          buildRoomIcon('assets/svg/salon.svg',
              'x ${rxHouseController.currentHouse.value.numberOfLivingRooms}'),
        if (rxHouseController.currentHouse.value.numberOfRooms != null &&
            rxHouseController.currentHouse.value.numberOfRooms! > 0)
          buildRoomIcon('assets/svg/pieces.svg',
              'x ${rxHouseController.currentHouse.value.numberOfRooms}'),
      ],
    ),
  );
}

Widget buildRoomIcon(String iconPath, String label) {
  return Row(
    children: [
      SvgPicture.asset(
        iconPath,
        height: 50.0,
        color: Colors.black,
      ),
      Text(label),
    ],
  );
}

Widget buildItineraryButton() {
  return Center(
      child: buildElevatedButtonIcon(
    fixedSize: Size(Get.size.width * 0.8, 30),
    label: "Voir l'itinéraire".toUpperCase(),
    icon: const Icon(
      Icons.route,
      color: Colors.black,
    ),
    backgroundColor: primaryColor,
    onPressed: () {
      rxMapController.activateRouteMode();
    },
  ));
}

Widget buildContactButton() {
  return Center(
    child: buildElevatedButtonIcon(
      label: 'Contacter'.toUpperCase(),
      icon: const Icon(
        Icons.call,
        color: Colors.white,
      ),
      color: white,
      fixedSize: Size(Get.size.width * 0.8, 30),
      backgroundColor: Colors.black,
      onPressed: () async {
        String? numbertoCall = user?.phoneNumber.toString();
        Uri phoneno = Uri.parse('tel:$numbertoCall');
        if (await launchUrl(phoneno)) {
        } else {}
      },
    ),
  );
}

Widget buildDescriptionView() {
  return buildText(
    text: rxHouseController.currentHouse.value.description ?? "",
    maxLines: 2,
    overflow: TextOverflow.visible,
  );
}

Widget buildShowHousePanel() {
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
