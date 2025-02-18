// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:radar/screens/_builds/build_all_elements.dart';
// import 'package:radar/screens/_builds/build_form.dart';
// import 'package:radar/utils/constants.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'carousel_images.dart';

// // ignore: must_be_immutable
// class HousePanel extends StatefulWidget {
//   HousePanel({
//     super.key,
//     required this.dataResult,
//     required this.personnalHouse,
//   });
//   dynamic dataResult;
//   bool personnalHouse;
//   @override
//   State<HousePanel> createState() => _HousePanelState();
// }

// class _HousePanelState extends State<HousePanel> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.75,
//       child: SingleChildScrollView(
//         // controller: widget.scrollController,
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             MyCarouselImages(images: widget.dataResult['Lien Image']),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: primaryColor,
//               ),
//               child: Text(
//                 '${widget.dataResult['Catégorie']}',
//                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                       fontStyle: FontStyle.italic,
//                       color: Colors.white,
//                     ),
//               ),
//             ),

//             const SizedBox(
//               height: 8.0,
//             ),
//             Text(
//               "${widget.dataResult['Titre']}",
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontSize: 20,
//                     overflow: TextOverflow.visible,
//                   ),
//             ),

//             const SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 buildText(
//                   text:
//                       "${widget.dataResult['Prix']} ${widget.dataResult['Devise']} ${widget.dataResult['Durée locative']}",
//                   fontSize: 20,
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.w800,
//                   color: primaryColor,
//                 ),
//                 const Icon(
//                   Icons.favorite_border_outlined,
//                   color: Colors.grey,
//                 )
//               ],
//             ),

//             RichText(
//               text: TextSpan(
//                 text: 'Publié le :  ',
//                 style: DefaultTextStyle.of(context).style,
//                 children: const <TextSpan>[
//                   TextSpan(
//                       text: 'formattedDate',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 const Icon(Icons.location_on),
//                 buildText(text: widget.dataResult['Adresse']),
//               ],
//             ),
//             const SizedBox(
//               height: 8.0,
//             ),
//             Row(
//               children: [
//                 RatingBar.builder(
//                   initialRating: 3,
//                   minRating: 1,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemSize: 20.0,
//                   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   itemBuilder: (context, _) => const Icon(
//                     Icons.star,
//                     color: Color.fromARGB(255, 240, 184, 18),
//                   ),
//                   onRatingUpdate: (rating) {
//                     if (kDebugMode) {
//                       print(rating);
//                     }
//                   },
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 const SizedBox(
//                   height: 30.0,
//                 ),
//                 if (widget.dataResult['Nombre de chambres']
//                     .toString()
//                     .isNotEmpty)
//                   Row(
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/chambres.svg',
//                         height: 50.0,
//                         color: secondaryColor,
//                       ),
//                       Text('x ${widget.dataResult['Nombre de chambres']}'),
//                     ],
//                   ),
//                 if (widget.dataResult['Nombre de salles de bain']
//                     .toString()
//                     .isNotEmpty)
//                   Row(
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/douche2.svg',
//                         height: 40.0,
//                         color: secondaryColor,
//                       ),
//                       Text(
//                           'x ${widget.dataResult['Nombre de salles de bain']}'),
//                     ],
//                   ),
//                 if (widget.dataResult['Nombre de salons'].toString().isNotEmpty)
//                   Row(
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/salon.svg',
//                         height: 40.0,
//                         color: secondaryColor,
//                       ),
//                       Text('x ${widget.dataResult['Nombre de salons']}'),
//                     ],
//                   ),
//                 if (widget.dataResult['Nombre de pièces']
//                         .toString()
//                         .isNotEmpty &&
//                     widget.dataResult['Nombre de pièces'] != 0)
//                   Row(
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/pieces.svg',
//                         height: 40.0,
//                         color: secondaryColor,
//                       ),
//                       Text('x ${widget.dataResult['Nombre de pièces']}'),
//                     ],
//                   ),
//                 // Row(
//                 //   children: [
//                 //     SvgPicture.asset(
//                 //       'assets/svg/pieces.svg',
//                 //       height: 40.0,
//                 //       color: secondaryColor,
//                 //     ),
//                 //     Text('x ${widget.dataResult["Nombre d'étage(s)"]}'),
//                 //   ],
//                 // ),
//               ],
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             buildElevatedButtonIcon(
//               label: "Voir l'itinéraire".toUpperCase(),
//               icon: const Icon(Icons.route),
//               backgroundColor: primaryColor,
//               onPressed: () async {
//                 // await rxMapController.determineCurrentPosition('target');
//                 setState(() {
//                   // Clear maps elements ---------------------------------------------------
//                   rxMapController.polylines.clear();
//                   rxMapController.polylineCoordinates.clear();
//                   rxMapController.polylinePoints.clear();
//                   // widget.markers.clear();

//                   // widget.displayRoute = true;

//                   rxMapController.displayFilterPanel.value = false;
//                   rxMapController.displayRoute.value = true;

//                   rxMapController.destinationLat.value =
//                       widget.dataResult['coords'].latitude;

//                   rxMapController.destinationLong.value =
//                       widget.dataResult['coords'].longitude;
//                   rxMapController.markers.removeWhere(
//                     (Marker marker) =>
//                         marker.markerId.value != widget.dataResult['Id'] &&
//                         marker.markerId.value != 'currentPositionSparkle' &&
//                         marker.markerId.value != 'ResultPlaceSparkle',
//                   );

//                   // rxMapController.getRouteBetweenCoordinates(
//                   //     rxMapController.currentPositionLat.value,
//                   //     rxMapController.currentPositionLong.value,
//                   //     rxMapController.destinationLat.value,
//                   //     rxMapController.destinationLong.value);

//                   Get.back();

//                   Navigator.pop(context);
//                 });
//               },
//             ),

//             // rxGeneralController.nameOfScreen.value != '/'
//             // ? Column(
//             //     children: [
//             //       Text(
//             //         widget.dataResult['Description'],
//             //         maxLines: 2,
//             //         overflow: TextOverflow.ellipsis,
//             //       ),
//             //     if (widget.dataResult["Statut"] == 'En ligne')
//             //       Container(
//             //           padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//             //           width: double.infinity,
//             //           decoration: BoxDecoration(
//             //             color: Colors.green.shade300,
//             //           ),
//             //           child: buildText(
//             //             text: "Statut : ${widget.dataResult['Statut']}",
//             //             color: Colors.white,
//             //             fontSize: 12,
//             //           )),
//             //     if (widget.dataResult["Statut"] == 'Hors ligne')
//             //       Container(
//             //           padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//             //           width: double.infinity,
//             //           decoration: BoxDecoration(
//             //             color: Colors.red.shade300,
//             //           ),
//             //           child: buildText(
//             //             text: "Statut : ${widget.dataResult['Statut']}",
//             //             color: Colors.white,
//             //             fontSize: 12,
//             //           )),
//             //     if (widget.dataResult["Statut"] ==
//             //         'En cours de validation')
//             //       Container(
//             //           padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//             //           width: double.infinity,
//             //           decoration: BoxDecoration(
//             //             color: Colors.orange.shade300,
//             //           ),
//             //           child: buildText(
//             //             text: "Statut : ${widget.dataResult['Statut']}",
//             //             color: Colors.white,
//             //             fontSize: 12,
//             //           )),
//             //   ],
//             // )
//             // : buildElevatedButtonIcon(
//             //     label: 'Contacter'.toUpperCase(),
//             //     icon: const Icon(Icons.call),
//             //     backgroundColor: secondaryColor,
//             //     onPressed: () async {
//             //       String? numbertoCall = user?.phoneNumber.toString();
//             //       Uri phoneno = Uri.parse('tel:$numbertoCall');
//             //       if (await launchUrl(phoneno)) {
//             //       } else {}
//             //     },
//             //   ),
//             const SizedBox(
//               height: 8.0,
//             ),
//             buildText(
//               text: 'Description'.toUpperCase(),
//             ),
//             const Divider(
//               height: 20,
//               thickness: 1,
//               color: Colors.grey,
//             ),
//             Text(
//               '${widget.dataResult["Description"]}',
//               style: const TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
