import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/screens/offer/offer_edit_screen.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

class OfferListScreen extends StatefulWidget {
  const OfferListScreen({super.key});

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  // List of offer names to exclude
  final List<String> excludeOffers = [
    "Offre Starter",
  ]; // Add the names of offers to exclude here
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rxOfferController.fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Offres d'abonnement",
      ),
      body: Obx(() {
        // // Check if there is an "Offre Starter" in the offers list
        // final hasOffreStarter = rxOfferController.offers
        //     .any((offer) => offer.name == "Offre Starter");

        // Filter offers to exclude those in the excludeOffers list
        final filteredOffers = rxOfferController.offers
            .where((offer) => !excludeOffers.contains(offer.name))
            .toList();

        return CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              SvgPicture.asset(
                "assets/svg/wallet_credit.svg",
                width: Get.size.width * 0.3,
              ),
            ])),
            SliverToBoxAdapter(
              child: buildGrandTitle(text: "Offres d'abonnement"),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final offer = filteredOffers[index];
                  return buildListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/premium.svg",
                      width: Get.size.width * 0.1,
                    ),
                    title: buildText(
                      text: offer.name!.toUpperCase(),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: white,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText(
                          text: "${offer.price} FCFA",
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          color: primaryColor,
                        ),
                        buildSpacer(),
                        Row(
                          children: [
                            buildText(
                              text: offer.numberOfPublication == -1
                                  ? "illimité"
                                  : "${offer.numberOfPublication} publication(s)",
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: white,
                            ),
                            buildSpacer(width: 20),
                            buildText(
                              text: offer.numberOfDay == 30
                                  ? "1 mois"
                                  : "${offer.numberOfDay} Jour(s)",
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: white,
                            ),
                          ],
                        ),
                        buildElevatedButtonIcon(
                          label: 'Activer cette offre',
                          onPressed: () {
                            rxOfferSubscriptionController.addSubscription(
                              name: offer.name!,
                              price: offer.price!,
                              numberOfPublication: offer.numberOfPublication!,
                              numberOfDay: offer.numberOfDay!,
                            );
                            buildCongratulationsPopupDialog(
                              text: "Offre activée avec succès!",
                            );
                          },
                          backgroundColor: primaryColor,
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: white),
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Modifier l\'offre'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Supprimer l\'offre'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.to(() => OfferEditScreen(offer: offer));
                        } else if (value == 'delete') {
                          rxOfferController.deleteOffer(offer.id!);
                          Get.snackbar('Succès', 'Offre supprimée avec succès');
                        }
                      },
                    ),
                  );
                },
                childCount: filteredOffers.length,
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Get.toNamed(Routes.addOffer), // Icône affichée sur le bouton
        backgroundColor: primaryColor, // Couleur de fond du bouton
        tooltip: 'Ajouter une offre', // Navigation vers OfferAddScreen
        child: const Icon(Icons.add), // Info-bulle pour le FAB
      ),
    );
  }
}
