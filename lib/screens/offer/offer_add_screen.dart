import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/controller/offer/offer_controller.dart';
import 'package:radar/models/offer/offer_model.dart';
import 'package:radar/utils/constants.dart';

class OfferAddScreen extends StatelessWidget {
  final OfferController offerController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController numberOfPublicationController =
      TextEditingController();
  final TextEditingController numberOfDayController = TextEditingController();

  OfferAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(
          title: "Ajouter une Offre",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildGrandTitle(text: 'Ajouter une offre'),
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
                    label: "Ajouter",
                    onPressed: () {
                      final newOffer = Offer(
                        name: nameController.text,
                        price: int.tryParse(priceController.text),
                        numberOfPublication:
                            int.tryParse(numberOfPublicationController.text),
                        numberOfDay: int.tryParse(numberOfDayController.text),
                      );
                      offerController.addOffer(newOffer);
                      Get.back();
                    },
                    backgroundColor: primaryColor,
                    fixedSize: Size(Get.size.width * 0.85, 50)),
              ],
            ),
          ),
        ));
  }
}
