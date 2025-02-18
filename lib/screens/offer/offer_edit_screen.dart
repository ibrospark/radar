import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/models/offer_model.dart';
import 'package:radar/utils/constants.dart';

class OfferEditScreen extends StatelessWidget {
  final Offer offer;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController numberOfPublicationController;
  final TextEditingController numberOfDayController;

  OfferEditScreen({super.key, required this.offer})
      : nameController = TextEditingController(text: offer.name),
        priceController =
            TextEditingController(text: offer.price?.toString() ?? ''),
        numberOfPublicationController = TextEditingController(
            text: offer.numberOfPublication?.toString() ?? ''),
        numberOfDayController =
            TextEditingController(text: offer.numberOfDay?.toString() ?? '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(
          title: "Modifier l' Offre",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildGrandTitle(
                text: "Modifier l'offre",
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextFormField(
                      controller: nameController,
                      labelText: "Nom de l'offre",
                    ),
                    buildTextFormField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      labelText: "Prix",
                    ),
                    buildTextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberOfPublicationController,
                      labelText: "Nombre de publication",
                    ),
                    buildTextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberOfDayController,
                      labelText: "Nombre de jour(s)",
                    ),
                    const SizedBox(height: 16),
                    buildElevatedButtonIcon(
                        label: "Mettre à jour",
                        onPressed: () {
                          offer.name = nameController.text;
                          offer.price = int.tryParse(priceController.text);
                          offer.numberOfPublication =
                              int.tryParse(numberOfPublicationController.text);
                          offer.numberOfDay =
                              int.tryParse(numberOfDayController.text);
                          rxOfferController.updateOffer(offer);
                          Get.back();
                        },
                        backgroundColor: primaryColor,
                        fixedSize: Size(Get.size.width * 0.85, 50)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
