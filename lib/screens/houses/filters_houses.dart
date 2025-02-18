// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:radar/builds/build_all_elements.dart';
// import 'package:radar/builds/build_form.dart';
// import 'package:radar/utils/constants.dart';
// import '../controller/notification_controller.dart';
// import '../widgets/form/my_multiselect_input.dart';
// import '../widgets/form/my_radio_button.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // ignore: must_be_immutable
// class FiltersHouses extends StatefulWidget {
//   FiltersHouses(
//       {super.key,
//       required this.location,
//       required this.callbackLocation,
//       required this.mapController,
//       required this.clearmarkers,
//       required this.setMarkers,
//       required this.dragController
//       // ignore: non_constant_identifier_names

//       // ignore: non_constant_identifier_names
//       });
//   // ignore: non_constant_identifier_names

//   // ignore: non_constant_identifier_names

//   Function? callbackLocation;

//   DraggableScrollableController dragController;
//   String? location;
//   GoogleMapController mapController;
//   dynamic setMarkers;
//   dynamic clearmarkers;

//   @override
//   State<FiltersHouses> createState() => _FiltersHousesState();
// }

// class _FiltersHousesState extends State<FiltersHouses> {
//   @override
//   void initState() {
//     setState(() {});
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // if (rxMapController.mapIsCompleted == true) {
//     //   // Completer mapCompleter = Completer();
//     //   rxMapController.mapController.dispose();
//     // }

//     super.dispose();
//   }

//   NotificationController rxNotificationsController = Get.find();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // _typeTransaction --------------------------------------
// // _categorie --------------------------------------
// // _superficieController --------------------------------------
// // _nombreDetagesController --------------------------------------
// // _nombreDeChambresController --------------------------------------
// // _nombreDeSalonsController --------------------------------------
// // _nombreDeSallesDeBainController --------------------------------------
// // _optionListItems --------------------------------------
// // _locationDuration --------------------------------------
// // _prixController
// // _currency --------------------------------------

//   getFilteredHouses() async {
//     CollectionReference<Map<String, dynamic>> collectionHouses =
//         firestore.collection('houses');

//     Query<Map<String, dynamic>> query =
//         collectionHouses.where('Catégorie', isEqualTo: _categorie);
//     // .where('Statut', isEqualTo: 'En ligne');

//     if (_typeTransaction.isNotEmpty) {
//       query = query.where('Type de transaction', isEqualTo: _typeTransaction);
//     }
//     if (_nombreDeChambresController.text.isNotEmpty) {
//       query = query.where('Nombre de chambres',
//           isEqualTo: _nombreDeChambresController.text);
//     }

//     if (_nombreDeSalonsController.text.isNotEmpty) {
//       query = query.where('Nombre de salons',
//           isEqualTo: _nombreDeSalonsController.text);
//     }
//     if (_nombreDeSallesDeBainController.text.isNotEmpty) {
//       query = query.where('Nombre de salles de bain',
//           isEqualTo: _nombreDeSallesDeBainController.text);
//     }
//     if (_nombreDetagesController.text.isNotEmpty) {
//       query = query.where("Nombre d'étages",
//           isEqualTo: _nombreDetagesController.text);
//     }
//     if (_superficieController.text.isNotEmpty) {
//       query = query.where('Superficie', isEqualTo: _superficieController.text);
//     }
//     if (_locationDuration != null && _locationDuration!.isNotEmpty) {
//       query = query.where('Durée locative', isEqualTo: _locationDuration);
//     }
//     if (_currency != null && _currency!.isNotEmpty) {
//       query = query.where('Devise', isEqualTo: _currency);
//     }
//     if (_options.isNotEmpty) {
//       query = query.where('Options', arrayContainsAny: _options);
//     }
//     if (rxMapController.neighborhood.value.isNotEmpty) {
//       query = query.where('Quartier',
//           isEqualTo: rxMapController.neighborhood.value);
//     }

//     // if (_MinprixController.text.isNotEmpty && _MaxprixController.text.isEmpty) {
//     //   query = query.where(int.parse("Prix"),
//     //       isGreaterThanOrEqualTo: int.parse(_MinprixController.text));
//     // }
//     // if (_MaxprixController.text.isNotEmpty && _MinprixController.text.isEmpty) {
//     //   query = query.where(int.parse("Prix"),
//     //       isLessThanOrEqualTo: int.parse(_MaxprixController.text));
//     // }
//     // if (_MinprixController.text.isNotEmpty &&
//     //     _MaxprixController.text.isNotEmpty) {
//     //   query = query.where(int.parse("Prix"),
//     //       isGreaterThanOrEqualTo: int.parse(_MinprixController.text),
//     //       isLessThanOrEqualTo: int.parse(_MaxprixController.text));
//     // }
//     await query.orderBy('Prix', descending: false).get().then((snapshots) {
//       if (snapshots.docs.isNotEmpty) {
//         for (var i = 0; i < snapshots.docs.length;) {
//           var data = snapshots.docs[i].data();
//           if (data['Prix'] == '') {
//             setState(() {
//               data['Prix'] = '0';
//             });
//           }
//           if (_MinprixController.text == '') {
//             setState(() {
//               _MinprixController.text = '0';
//             });
//           }
//           if (_MaxprixController.text == '') {
//             setState(() {
//               _MaxprixController.text = '${snapshots.docs.last.data()['Prix']}';
//             });
//           }
//           if (
//               // ------------------------------------
//               // data['Adresse'].toString().contains(rxMapController.quartier.value) &&
//               // -----------------------------------
//               int.parse(data['Prix'].toString()) >=
//                       (int.parse(_MinprixController.text)) &&
//                   // -----------------------------------
//                   int.parse(data['Prix'].toString()) <=
//                       (int.parse(_MaxprixController.text))
//               // -------------------------------------------
//               ) {
//             widget.setMarkers(snapshots.docs[i].data(), snapshots.docs[i].id);
//             return buildSnackbar(
//                 title: "Désolé !",
//                 message:
//                     "Nous avons trouvé ${snapshots.docs.length} résultat(s) à votre recherche !",
//                 backgroundColor: Colors.redAccent);
//           } else {
//             widget.clearmarkers();
//             SearchContinueDialog();
//             return buildSnackbar(
//                 title: "Désolé !",
//                 message: "Aucun résultat trouvé !",
//                 backgroundColor: Colors.redAccent);
//           }
//         }
//       } else if ((snapshots.docs.isEmpty)) {
//         widget.clearmarkers();
//         SearchContinueDialog();
//         return buildSnackbar(
//             title: "Désolé !",
//             message: "Aucun résultat trouvé !",
//             backgroundColor: Colors.redAccent);
//       }
//     });
//   }

//   typeDeTransaction? _selectedTypeOfTransaction = typeDeTransaction.Location;
//   late String _typeTransaction = '';
//   Widget _buildTypeTransaction() {
//     return Row(
//       children: [
//         MyRadioTileButton(
//             title: typeDeTransaction.Location.name,
//             value: typeDeTransaction.Location,
//             selectedGroupValue: _selectedTypeOfTransaction,
//             onChanged: (value) {
//               setState(() {
//                 _selectedTypeOfTransaction = value;
//                 _typeTransaction =
//                     _selectedTypeOfTransaction.toString().split(".").last;
//               });
//             }),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: RadioListTile(
//             title: const Text('Acheter'),
//             value: typeDeTransaction.Vente,
//             groupValue: _selectedTypeOfTransaction,
//             onChanged: (value) {
//               setState(() {
//                 _selectedTypeOfTransaction = typeDeTransaction.Vente;
//                 _typeTransaction =
//                     _selectedTypeOfTransaction.toString().split(".").last;
//               });
//             },
//             contentPadding: const EdgeInsets.all(0.0),
//             dense: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             tileColor: Colors.blue.shade50,
//           ),
//         ),
//       ],
//     );
//   }

//   late String? categorieDropdownValue = categoriesList.first;
//   late String? _categorie = categoriesList.first;
//   Widget _buildCategorie() {
//     return DropdownButtonHideUnderline(
//         child: buildDropdownButton(
//             items: categoriesList,
//             selectedItem: '$categorieDropdownValue',
//             onChanged: (value) {
//               setState(() {
//                 categorieDropdownValue = value;
//                 _categorie = value;
//               });
//             }));
//   }

//   final TextEditingController _superficieController =
//       TextEditingController(text: '');
//   Widget _buildSuperficie() {
//     return buildTextFormField(
//       controller: _superficieController,
//       labelText: 'Superficie en m²',
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       validator: null,
//       suffix: buildText(
//         text: 'm²',
//         fontWeight: FontWeight.w800,
//         fontSize: 18.0,
//       ),
//     );
//   }

//   final TextEditingController _nombreDetagesController =
//       TextEditingController(text: '');
//   Widget _buildNombreDetages() {
//     return buildTextFormField(
//       controller: _nombreDetagesController,
//       labelText: "Nombre d'étage(s)",
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "Veuillez saisir le nombre d'étage(s) !";
//         }
//         return null;
//       },
//     );
//   }

//   final TextEditingController _nombreDeChambresController =
//       TextEditingController(text: '');
//   Widget _buildNombreDeChambres() {
//     return buildTextFormField(
//       controller: _nombreDeChambresController,
//       labelText: "Nombre de chambre(s)",
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Veuillez saisir le nombre de chambre(s) !';
//         }
//         return null;
//       },
//     );
//   }

//   final TextEditingController _nombreDeSalonsController =
//       TextEditingController(text: '');
//   Widget _buildNombreDeSalons() {
//     return buildTextFormField(
//       controller: _nombreDeSalonsController,
//       labelText: "Nombre de salon(s)",
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Veuillez saisir le nombre de salon(s) !';
//         }
//         return null;
//       },
//     );
//   }

//   final TextEditingController _nombreDeSallesDeBainController =
//       TextEditingController(text: '');
//   Widget _buildNombreDeSallesDeBain() {
//     return buildTextFormField(
//       controller: _nombreDeSallesDeBainController,
//       labelText: "Nombre de salle(s) de bain",
//       keyboardType: TextInputType.number,
//       textInputAction: TextInputAction.next,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Veuillez saisir le nombre de salle(s) de bain!';
//         }
//         return null;
//       },
//     );
//   }

//   List<dynamic> _options = [];
//   _buildOptions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 20.0,
//         ),
//         Text(
//           'Selectionnez une option',
//           style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//         ),
//         const SizedBox(
//           height: 10.0,
//         ),
//         MyMultiSelectInput(
//           ontap: (values) {
//             _options = values;
//           },
//           color: secondaryColor,
//         ),
//         const SizedBox(
//           height: 20.0,
//         ),
//       ],
//     );
//   }

//   late String? locationDurationDropdownValue = rentalDurationList.first;
//   late String? _locationDuration = rentalDurationList.first;

//   // Widget _buildLocationDuration() {
//   //   return DropdownButtonHideUnderline(
//   //     child: DropdownButton<String>(
//   //       value: locationDurationDropdownValue,
//   //       icon: const Icon(Icons.arrow_drop_down),
//   //       elevation: 16,
//   //       onChanged: (value) {
//   //         locationDurationDropdownValue = value;
//   //         _locationDuration = value;
//   //       },
//   //       items:
//   //           rentalDurationList.map<DropdownMenuItem<String>>((String value) {
//   //         return DropdownMenuItem<String>(
//   //           value: value,
//   //           child: Text(value),
//   //         );
//   //       }).toList(),
//   //     ),
//   //   );
//   // }
//   Widget _buildLocationDuration() {
//     return DropdownButtonHideUnderline(
//         child: buildDropdownButton(
//             items: rentalDurationList,
//             selectedItem: '$locationDurationDropdownValue',
//             onChanged: (value) {
//               setState(() {
//                 locationDurationDropdownValue = value;
//                 _locationDuration = value;
//               });
//             }));
//   }

//   // ignore: non_constant_identifier_names
//   final TextEditingController _MinprixController = TextEditingController();
//   // ignore: non_constant_identifier_names
//   final TextEditingController _MaxprixController = TextEditingController();
//   Widget _buildMinPrix() {
//     return buildTextFormField(
//         controller: _MinprixController,
//         labelText: "Min Prix",
//         keyboardType: TextInputType.number,
//         textInputAction: TextInputAction.next,
//         validator: null);
//   }

//   Widget _buildMaxPrix() {
//     return buildTextFormField(
//         controller: _MaxprixController,
//         labelText: "Max Prix",
//         keyboardType: TextInputType.number,
//         textInputAction: TextInputAction.next,
//         validator: null);
//   }

//   late String? currencyDropdownValue = currenciesList.first;
//   late String? _currency = currenciesList.first;
//   Widget _buildCurrency() {
//     return DropdownButtonHideUnderline(
//         child: buildDropdownButton(
//             items: currenciesList,
//             selectedItem: '$currencyDropdownValue',
//             onChanged: (value) {
//               setState(() {
//                 currencyDropdownValue = value;
//                 _currency = value;
//               });
//             }));
//   }

//   Widget _buildValidationButtonForm() {
//     return buildElevatedButtonIcon(
//         label: 'Activer le radar',
//         backgroundColor: primaryColor,
//         icon: SvgPicture.asset(
//           'assets/svg/radar.svg',
//           height: 20,
//           color: Colors.white,
//         ),
//         onPressed: () async {
//           if (_formKey.currentState!.validate()) {
//             await getFilteredHouses();
//             //  rxMapController.reinitialisationMarkersButton, true
//             // widget.CallbackdisplayFilterPanel(false);
//             animateDraggableScroll(0.08);
//             Position currentPosition =
//                 await rxMapController.determineCurrentPosition();
//             widget.mapController
//                 .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//               target:
//                   LatLng(currentPosition.latitude, currentPosition.longitude),
//               zoom: 12,
//               tilt: 90,
//             )));
//           } else {
//             buildSnackbar(
//               title: "Désolé !",
//               message:
//                   "Une erreur est survenue ! Vérifiez les champs saisies. !",
//               backgroundColor: Colors.redAccent,
//             );
//           }
//         });
//   }

//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Material(
//         child: Container(
//           decoration: const BoxDecoration(
//             // gradient: LinearGradient(
//             //   begin: Alignment.topLeft,
//             //   end: Alignment(0.8, 1),
//             //   colors: <Color>[
//             //     thirdColor,
//             //     secondaryColor,
//             //   ], // Gradient from https://learnui.design/tools/gradient-generator.html
//             //   tileMode: TileMode.mirror,
//             // ),
//             color: secondaryColor,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.search,
//                       size: 30,
//                     ),
//                     buildText(
//                       text: 'JE '.toUpperCase(),
//                       // fontStyle: FontStyle.italic,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                     buildText(
//                       text: 'R'.toUpperCase(),
//                       // fontStyle: FontStyle.italic,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 20,
//                       color: yellowColor,
//                     ),
//                     buildText(
//                       text: 'ECHERCHE ICI'.toUpperCase(),
//                       // fontStyle: FontStyle.italic,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 _buildTypeTransaction(),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 _buildCategorie(),
//                 if (_categorie == 'Immeuble' ||
//                     _categorie == 'Maison' ||
//                     _categorie == 'Maison de vacance')
//                   _buildNombreDetages(),
//                 if (_categorie == 'Appartement' ||
//                     _categorie == 'Villa' ||
//                     _categorie == 'Maison' ||
//                     _categorie == 'Maison de vacance' ||
//                     _categorie == 'Studio')
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildNombreDeChambres(),
//                       _buildNombreDeSalons(),
//                       _buildNombreDeSallesDeBain(),
//                     ],
//                   ),
//                 _buildSuperficie(),
//                 if (_categorie == 'Appartement' ||
//                     _categorie == 'Villa' ||
//                     _categorie == 'Maison' ||
//                     _categorie == 'Maison de vacance' ||
//                     _categorie == 'Studio')
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildOptions(),
//                     ],
//                   ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildMinPrix(),
//                     ),
//                     Expanded(
//                       child: _buildMaxPrix(),
//                     ),
//                   ],
//                 ),
//                 if (_typeTransaction.contains("Location"))
//                   _buildLocationDuration(),
//                 _buildCurrency(),
//                 InkWell(
//                   onTap: () async {
//                     var place = await PlacesAutocomplete.show(
//                         hint: 'Rechercher un emplacement',
//                         logo: Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(
//                               20,
//                             ),
//                             child: buildLogo(
//                               height: 70,
//                             )),
//                         context: context,
//                         apiKey: googleMapApiKey,
//                         mode: Mode.overlay,
//                         types: [],
//                         strictbounds: false,
//                         components: [const Component(Component.country, 'sn')],
//                         //google_map_webservice package
//                         onError: (err) {
//                           if (kDebugMode) {
//                             print(err);
//                           }
//                         });

//                     if (place != null) {
//                       setState(() {
//                         rxMapController.location = place.description.toString();
//                       });

//                       //form google_maps_webservice package
//                       final placeList = GoogleMapsPlaces(
//                         apiKey: googleMapApiKey,
//                         apiHeaders: await const GoogleApiHeaders().getHeaders(),
//                         //from google_api_headers package
//                       );
//                       String placeid = place.placeId ?? "0";
//                       final detail =
//                           await placeList.getDetailsByPlaceId(placeid);
//                       final geometry = detail.result.geometry!;
//                       final lat = geometry.location.lat;
//                       final lang = geometry.location.lng;
//                       var newlatlang = LatLng(lat, lang);

//                       //move map camera to selected place with animation
//                       // rxMapController.mapController.animateCamera(
//                       //     CameraUpdate.newCameraPosition(CameraPosition(
//                       //   target: newlatlang,
//                       //   zoom: 12,
//                       // )));
//                       rxMapController.setMarker(
//                           newlatlang, 'SearchPlaceSparkle', 'pin');
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           side: const BorderSide(
//                             width: 1,
//                             color: Colors.grey,
//                           )),
//                       elevation: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(0),
//                         width: MediaQuery.of(context).size.width - 40,
//                         child: ListTile(
//                           title: Text(
//                             rxMapController.location,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           trailing: const Icon(Icons.search),
//                           dense: true,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 _buildValidationButtonForm()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ignore: non_constant_identifier_names
//   Future<void> SearchContinueDialog() async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             backgroundColor: Colors.transparent,
//             child: Container(
//               constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height - 20),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         buildText(
//                           text: "Souhaitez-vous passer en recherche continue?",
//                           fontStyle: FontStyle.italic,
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Stack(
//                           children: [
//                             Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: const BoxDecoration(
//                                   color: yellowColor,
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Flexible(
//                                       child: Text(
//                                         'La recherche continue vous permet de recevoir des notifications lorsque le bien que vous recherchez est disponible',
//                                       ),
//                                     ),
//                                   ],
//                                 )),
//                             const Positioned(
//                               bottom: 5,
//                               right: 5,
//                               child: Icon(
//                                 Icons.info,
//                                 color: Colors.black,
//                                 size: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton.icon(
//                                 label: const Text("Non"),
//                                 icon: const Icon(Icons.cancel),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   textStyle:
//                                       Theme.of(context).textTheme.titleSmall,
//                                   // fixedSize: Size(MediaQuery.of(context).size.width, 40),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(0),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   //  reset all marker
//                                   rxMapController.displayFilterPanel.value =
//                                       true;

//                                   // reset all markers
//                                   Navigator.pop(context);
//                                   TextEditingController().clear();
//                                   animateDraggableScroll(0.8);
//                                 },
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Expanded(
//                               child: ElevatedButton.icon(
//                                   label: const Text("Oui"),
//                                   icon: const Icon(Icons.check),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: yellowColor,
//                                     textStyle:
//                                         Theme.of(context).textTheme.titleSmall,
//                                     // fixedSize: Size(MediaQuery.of(context).size.width, 40),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(0),
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     //  reset all marker
//                                     rxMapController.displayFilterPanel.value =
//                                         true;

//                                     // reset all markers

//                                     addContiniousResearch();
//                                     rxNotificationsController.sendNotifToAllUsers(
//                                         'Recherche de bien immobilier',
//                                         'Un utilisateur recherche un bien Immobilier, cliquez pour en savoir plus');
//                                     Navigator.pop(context);
//                                     buildSnackbar(
//                                       title: "Félicitation !",
//                                       message:
//                                           "Votre recherche a été enregistré avec succès!",
//                                     );

//                                     TextEditingController().clear();
//                                     animateDraggableScroll(0.8);
//                                   }),
//                             ),
//                           ],
//                         ),
//                       ]),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   DocumentReference<Map<String, dynamic>> continuousResearch =
//       FirebaseFirestore.instance.collection('continuous research').doc();
//   Future<void> addContiniousResearch() async {
//     return await continuousResearch
//         .set({
//           'Id': continuousResearch.id,
//           'Id User': user!.uid,
//           // 'Titre': _titre,
//           // 'Description': _description,
//           'Catégorie': _categorie,
//           // 'Région': _region,
//           'Quartier': rxMapController.neighborhood.value,
//           'Type de transaction': _typeTransaction,
//           'Min prix': _MinprixController.text,
//           "Max prix": _MaxprixController.text,
//           'Devise': _currency,
//           // 'Nombre de pièces': _nombreDePieces,
//           'Nombre de chambres': _nombreDeChambresController.text,
//           'Nombre de salons': _nombreDeSalonsController.text,
//           'Nombre de salles de bain': _nombreDeSallesDeBainController.text,
//           "Nombre d'étages": _nombreDetagesController.text,
//           // 'Lien Image': _lienImage,
//           'Date de publication': DateTime.now(),
//           'Superficie': _superficieController.text,
//           'Options': _options,
//           'Durée locative': _locationDuration.toString(),

//           // 'coords': GeoPoint(latitude, longitude),
//         })
//         // ignore: avoid_print
//         .then((value) => print("Home Added"))
//         // ignore: avoid_print
//         .catchError((error) => print("Failed to add Home: $error"));
//   }

//   void animateDraggableScroll(dynamic maxValue) {
//     if (widget.dragController.isAttached) {
//       setState(() {
//         widget.dragController.animateTo(maxValue,
//             duration: const Duration(seconds: 2), curve: Curves.easeOut);
//         widget.dragController.jumpTo(0.0);
//         // scrollController.animateTo(
//         //   0.0,
//         //   duration: const Duration(milliseconds: 500),
//         //   curve: Curves.easeOut,
//         // );
//       });
//     }
//   }
// }
