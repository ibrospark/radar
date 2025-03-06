import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/utils/constants.dart';

class OfferSubscriptionListScreen extends StatefulWidget {
  const OfferSubscriptionListScreen({super.key});

  @override
  State<OfferSubscriptionListScreen> createState() =>
      _OfferSubscriptionListScreenState();
}

class _OfferSubscriptionListScreenState
    extends State<OfferSubscriptionListScreen> {
  @override
  void initState() {
    super.initState();
    rxOfferSubscriptionController.loadUserSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Mon abonnement",
      ),
      body: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: buildGrandTitle(text: "Mon abonnement"),
            ),
            if (rxOfferSubscriptionController.offersSubscriptions.isEmpty ||
                rxOfferSubscriptionController
                        .offersSubscriptions.first.numberOfPublication ==
                    null ||
                rxOfferSubscriptionController
                        .offersSubscriptions.first.numberOfPublication! <=
                    0)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: buildInfoBlock(
                    text: "Vous n'avez aucun abonnement actif pour le moment.",
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var subscription = rxOfferSubscriptionController
                        .offersSubscriptions[index];

                    return buildListTile(
                      leading: SvgPicture.asset(
                        "assets/svg/premium.svg",
                        width: Get.size.width * 0.2,
                      ),
                      title: buildText(
                        text: subscription.name!.toUpperCase(),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: white,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(
                            text: "${subscription.price} FCFA",
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            color: primaryColor,
                          ),
                          buildSpacer(),
                          Row(
                            children: [
                              buildText(
                                text: subscription.numberOfPublication == -1
                                    ? "illimité"
                                    : "${subscription.numberOfPublication} publication(s)",
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: white,
                              ),
                              buildSpacer(width: 20),
                              buildText(
                                text: subscription.numberOfDay == 30
                                    ? "1 mois"
                                    : "${subscription.numberOfDay} Jour(s)",
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: white,
                              ),
                            ],
                          ),
                          buildSpacer(),
                          buildText(
                              text:
                                  " Date de début : ${subscription.startedAt}",
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: white,
                              overflow: TextOverflow.visible),
                          buildSpacer(),
                          buildText(
                              text: " Date de fin : ${subscription.expiredAt}",
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: white,
                              overflow: TextOverflow.visible),
                        ],
                      ),
                    );
                  },
                  childCount:
                      rxOfferSubscriptionController.offersSubscriptions.length,
                ),
              ),
          ],
        );
      }),
    );
  }
}
