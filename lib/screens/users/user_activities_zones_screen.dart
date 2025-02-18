// import 'dart:core';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:radar/utils/constants.dart';
// import 'dart:async';
// import 'package:flutter_svg/svg.dart';

// import '../../_builds/build_all_elements.dart';
// import '../../_builds/build_form.dart';

// class UserActivitiesZonesScreen extends StatefulWidget {
//   const UserActivitiesZonesScreen({super.key});

//   @override
//   State<UserActivitiesZonesScreen> createState() =>
//       _UserActivitiesZonesScreenState();
// }

// class _UserActivitiesZonesScreenState extends State<UserActivitiesZonesScreen> {
//   double latitude = 14.735845139493666;
//   double longitude = -17.477583804163356;
//   bool _mapCreated = false;
//   final dynamic _completer = Completer<GoogleMapController>();
//   GoogleMapController? _controller;

//   CameraPosition? cameraPosition;

//   String _mapStyle = '';
//   final markers = <Marker>{};
//   int markerIdCounter = 1;

//   late String addressLocation;
//   LatLng startLocation = const LatLng(14.735845139493666, -17.477583804163356);
//   String location = "Votre quartier et emplacement";
//   bool displayMap = false;
//   // ignore: unused_field
//   dynamic _numberOfUser;

//   // ignore: unused_field
//   final dynamic _auth = FirebaseFirestore.instance;

//   // ignore: unused_field
//   final List<dynamic> _option = [];

//   final _formKey = GlobalKey<FormState>();

//   // ignore: unused_field
//   late final String _id = '';

//   late String _region = 'Dakar';
//   late String _quartier = "";

//   DateTime datePublication = DateTime.now();
//   // ignore: prefer_typing_uninitialized_variables, unused_field
//   var _subscriptionPlanId;

//   @override
//   void initState() {
//     Future(() async {
//       rootBundle.loadString('assets/json/dark_mode_style.txt').then((string) {
//         _mapStyle = string;
//       });

//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     if (_mapCreated = true) {
//       _controller?.dispose();
//     }
//     // timer.cancel();
//     super.dispose();
//   }

//   _buildDeleteDialog(id) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0)),
//             child: Container(
//               constraints: const BoxConstraints(maxHeight: 200),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       "Êtes vous sur de vouloir supprimer ce contenu ? ",
//                       style: Theme.of(context).textTheme.titleMedium,
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               textStyle: const TextStyle(fontSize: 12),
//                               backgroundColor: Colors.red,
//                             ),
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             label: const Text('Non, annuler')),
//                         ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               textStyle: const TextStyle(fontSize: 12),
//                               backgroundColor: Colors.green,
//                             ),
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               // DeleteHouse()
//                               //     .deleteHouse();
//                               DeleteUserActivitiesZones(id)
//                                   .deleteActivitiesZones();
//                               Navigator.pop(context);
//                               buildSnackbar(
//                                 title: "Succès !",
//                                 message: "Bien supprimé avec succès !",
//                               );
//                             },
//                             label: const Text('Oui, supprimer')),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   final Stream<QuerySnapshot> _activitiesZoneStream = FirebaseFirestore.instance
//       .collection('activities zones')
//       // .where('Id User', isEqualTo: user?.uid)
//       // .orderBy('Date de publication', descending: true)
//       .snapshots();

//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return GestureDetector(
//       onTap: () {
   
//       },
//       child: Scaffold(
//           appBar: buildAppBar(
//             title: "Mes zones d'activités",
//           ),
//           body: SizedBox(
//             width: screenWidth,
//             height: screenHeight,
//             child: Stack(children: [
//               Material(
//                   child: Container(
//                 decoration: const BoxDecoration(color: secondaryColor),
//                 child: Column(
//                   children: [
//                     Form(
//                       key: _formKey,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(20)),
//                                 color: Colors.orange.shade100,
//                               ),
//                               child: buildText(
//                                   color: Colors.orange,
//                                   fontStyle: FontStyle.italic,
//                                   text:
//                                       "Pour recevoir des notifications de recherches continues, veuillez définir des zones d'activités."),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             buildElevatedButtonIcon(
//                                 backgroundColor: primaryColor,
//                                 label: "Ajouter une zone d'activité",
//                                 icon: const Icon(Icons.add),
//                                 onPressed: () {
//                                   setState(() {
//                                     displayMap = true;
//                                   });
//                                 }),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: StreamBuilder<QuerySnapshot>(
//                         stream: _activitiesZoneStream,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (snapshot.hasError) {
//                             return const Text(
//                                 "Quelques chose c'est mal passé lors de la connexion à la base de donnée.");
//                           }

//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }

//                           return ListView(
//                             children: snapshot.data!.docs
//                                 .map((DocumentSnapshot document) {
//                               //Map Data as  Map String
//                               Map<String, dynamic> data =
//                                   document.data()! as Map<String, dynamic>;
//                               // Menu Items
//                               const menuItems = <String>[
//                                 'Supprimer',
//                               ];

//                               final List<PopupMenuItem<String>> popUpMenuItems =
//                                   menuItems
//                                       .map(
//                                         (String value) => PopupMenuItem<String>(
//                                             value: value,
//                                             child: Row(
//                                               children: [
//                                                 const Icon(Icons.edit),
//                                                 Text('  $value'),
//                                               ],
//                                             )),
//                                       )
//                                       .toList();
//                               // ignore: unused_local_variable
//                               late String selectedValPopup;
//                               return Container(
//                                 margin: const EdgeInsets.all(5),
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                     gradient: const LinearGradient(
//                                       begin: Alignment.topRight,
//                                       end: Alignment.bottomLeft,
//                                       colors: <Color>[
//                                         thirdColor,
//                                         secondaryColor,
//                                       ],
//                                       tileMode: TileMode.mirror,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10),
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color: Colors.black.withOpacity(0.3),
//                                           blurRadius: 3),
//                                     ]),
//                                 child: ListTile(
//                                   leading: const Icon(
//                                     Icons.location_searching,
//                                     color: primaryColor,
//                                   ),
//                                   title: Text(
//                                     "${data['Région']}, ${data['Quartier']}",
//                                     // maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium
//                                         ?.copyWith(
//                                           color: Colors.white,
//                                         ),
//                                   ),
//                                   // subtitle: Column(
//                                   //   children: [],
//                                   // ),
//                                   trailing: PopupMenuButton<String>(
//                                     color: Colors.white,
//                                     onSelected: (String newValue) {
//                                       selectedValPopup = newValue;
//                                       _buildDeleteDialog(data['Id']);
//                                     },
//                                     itemBuilder: (BuildContext context) =>
//                                         popUpMenuItems,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               )),
//               displayMap
//                   ? Positioned(
//                       bottom: 0,
//                       right: 0,
//                       left: 0,
//                       top: 0,
//                       child: Stack(
//                         children: [
//                           GoogleMap(
//                             zoomGesturesEnabled:
//                                 true, //enable Zoom in, out on map
//                             initialCameraPosition: CameraPosition(
//                               target: startLocation,
//                               zoom: 12.0,
//                             ),
//                             mapType: MapType.normal,
//                             onTap: (argument) {
         
//                             },
//                             onMapCreated: (controller) {
//                               setState(() {
//                                 if (_mapCreated != true) {
//                                   _completer.complete(controller);
//                                 }
//                                 _controller = controller;
//                                 _controller!.setMapStyle(_mapStyle);
//                                 _mapCreated = true;

//                                 determineCurrentPosition();
//                               });
//                             },
//                             onCameraMove: (CameraPosition cameraPositiona) {
//                               cameraPosition = cameraPositiona;
//                             },
//                             onCameraIdle: () async {
//                               if (cameraPosition != null) {
//                                 List<Placemark> placemarks =
//                                     await placemarkFromCoordinates(
//                                   cameraPosition!.target.latitude,
//                                   cameraPosition!.target.longitude,
//                                 );
//                                 setState(() {
//                                   _region = placemarks.first.locality!;
//                                   _quartier = placemarks.first.subLocality!;
//                                   location =
//                                       "${placemarks.first.subLocality}, ${placemarks.first.street}";

//                                   latitude = cameraPosition!.target.latitude;
//                                   longitude = cameraPosition!.target.longitude;
//                                 });
//                               }
//                             },
//                           ),
//                           Center(
//                             child: Image.asset(
//                               'assets/mapicons/pin.png',
//                               height: 80,
//                             ),
//                           ),
//                         ],
//                       ))
//                   : Container(),
//               displayMap
//                   ? Positioned(
//                       top: 50,
//                       left: 20,
//                       right: 20,
//                       child: InkWell(
//                         onTap: () async {
//                           var place = await PlacesAutocomplete.show(
//                               hint: 'Rechercher un emplacement',
//                               logo: Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.all(
//                                   20,
//                                 ),
//                                 child: Image.asset(
//                                   "assets/images/logo1.png",
//                                   height: 70,
//                                 ),
//                               ),
//                               context: context,
//                               apiKey: googleMapApiKey,
//                               mode: Mode.overlay,
//                               types: [],
//                               strictbounds: false,
//                               components: [Component(Component.country, 'sn')],
//                               //google_map_webservice package
//                               onError: (err) {
//                                 if (kDebugMode) {
//                                   print(err);
//                                 }
//                               });

//                           if (place != null) {
//                             setState(() {
//                               rxMapController.location =
//                                   place.description.toString();
//                             });

//                             //form google_maps_webservice package
//                             final placeList = GoogleMapsPlaces(
//                               apiKey: googleMapApiKey,
//                               apiHeaders:
//                                   await const GoogleApiHeaders().getHeaders(),
//                               //from google_api_headers package
//                             );
//                             String placeid = place.placeId ?? "0";
//                             final detail =
//                                 await placeList.getDetailsByPlaceId(placeid);
//                             final geometry = detail.result.geometry!;
//                             final lat = geometry.location.lat;
//                             final lang = geometry.location.lng;
//                             var newlatlang = LatLng(lat, lang);

//                             //move map camera to selected place with animation
//                             rxMapController.googleMapController.value!
//                                 .animateCamera(CameraUpdate.newCameraPosition(
//                                     CameraPosition(
//                               target: newlatlang,
//                               zoom: 12,
//                             )));
//                             rxMapController.setMarker(
//                                 newlatlang, 'SearchPlaceSparkle', 'pin');
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(0),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                                 side: const BorderSide(
//                                   width: 1,
//                                   color: Colors.grey,
//                                 )),
//                             elevation: 0,
//                             child: Container(
//                               padding: const EdgeInsets.all(0),
//                               width: MediaQuery.of(context).size.width - 40,
//                               child: ListTile(
//                                 title: Text(
//                                   rxMapController.location,
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 trailing: const Icon(Icons.search),
//                                 dense: true,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container(),
//               displayMap
//                   ? Positioned(
//                       bottom: 100,
//                       left: 50,
//                       right: 50,
//                       child: Column(
//                         children: [
//                           buildElevatedButtonIcon(
//                               backgroundColor: Colors.green,
//                               label: "Valider cet emplacement",
//                               icon: const Icon(Icons.check),
//                               onPressed: () {
//                                 setState(() {
//                                   saveActivityZone(_quartier);
//                                   displayMap = false;
//                                 });
//                                 _controller?.dispose();
                     
//                               }),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           buildElevatedButtonIcon(
//                             label: 'Votre position actuelle',
//                             icon: SvgPicture.asset(
//                               "assets/svg/target.svg",
//                               color: Colors.white,
//                               height: 20,
//                             ),
//                             backgroundColor: primaryColor,
//                             onPressed: () {
//                               determineCurrentPosition();
                         
//                             },
//                           ),
//                         ],
//                       ))
//                   : Container(),
//               displayMap
//                   ? Positioned(
//                       top: 25,
//                       left: 30,
//                       height: 25,
//                       child: Image.asset(
//                         'assets/images/logo2.png',
//                       ))
//                   : Container(),
//             ]),
//           )),
//     );
//   }

//   void setMarker(point, idMarker, types) async {
//     Future<Uint8List> getBytesFromAsset(String path, int width) async {
//       ByteData data = await rootBundle.load(path);

//       ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//           targetWidth: width);
//       ui.FrameInfo fi = await codec.getNextFrame();
//       return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//           .buffer
//           .asUint8List();
//     }

//     final Uint8List markerIcon;

//     if (types.contains('default')) {
//       markerIcon = await getBytesFromAsset('assets/mapicons/default.png', 150);
//     } else if (types.contains('currentPosition')) {
//       markerIcon =
//           await getBytesFromAsset('assets/mapicons/currentposition.png', 150);
//     } else if (types.contains('destination')) {
//       markerIcon =
//           await getBytesFromAsset('assets/mapicons/destination2.png', 150);
//     } else if (types.contains('origin')) {
//       markerIcon = await getBytesFromAsset('assets/mapicons/origin.png', 150);
//     } else if (types.contains('pin')) {
//       markerIcon = await getBytesFromAsset('assets/mapicons/pin.png', 150);
//     } else if (types.contains('locality')) {
//       markerIcon =
//           await getBytesFromAsset('assets/mapicons/local-services.png', 150);
//     } else {
//       markerIcon = await getBytesFromAsset('assets/mapicons/places.png', 150);
//     }
//     final Marker marker = Marker(
//       markerId: MarkerId('$idMarker'),
//       position: point,
//       onTap: () {},
//       icon: BitmapDescriptor.fromBytes(markerIcon),
//     );

//     setState(() {
//       markers.add(marker);
//     });
//   }

//   Future<void> determineCurrentPosition() async {
//     Position currentPosition = await MapServices().getCurrentLocation();

//     setMarker(LatLng(currentPosition.latitude, currentPosition.latitude),
//         'currentPositionSparkle', 'pin');
//     _goToPlace(currentPosition.latitude, currentPosition.longitude);
//   }

//   Future<void> _goToPlace(double lat, double lng) async {
//     await _controller!.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//         target: LatLng(lat, lng),
//         zoom: 14,
//       ),
//     ));
//     setMarker(LatLng(lat, lng), 'ResultPlaceSparkle', 'pin');
//   }

//   DocumentReference<Map<String, dynamic>> userActivitiesZones =
//       FirebaseFirestore.instance.collection('activities zones').doc();

//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<void> saveActivityZone(String quartier) async {
//     // Vérifier si l'utilisateur est connecté
//     User? user = auth.currentUser;
//     if (user == null) {
//       print('Utilisateur non connecté');
//       return;
//     }

//     // Vérifier si la zone existe déjà
//     QuerySnapshot querySnapshot = await firestore
//         .collection('activities zones')
//         .where('Quartier', isEqualTo: quartier)
//         .where(
//           'Id User',
//           isEqualTo: user.uid,
//         )
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       buildSnackbar(
//         title: "Erreur !",
//         message: "La zone d'activité existe déjà !",
//         backgroundColor: Colors.red,
//       );

//       print('La zone existe déjà');
//       return;
//     }

//     // Enregistrer la nouvelle zone
//     await userActivitiesZones.set({
//       'Id': userActivitiesZones.id,
//       'Id User': user.uid,
//       'Quartier': quartier,
//       'Région': _region,
//       'Coords': GeoPoint(latitude, longitude),
//     });
//     buildSnackbar(
//       title: "Succès !",
//       message: "Zone d'activité ajouté avec succès !",
//     );

//     print('Zone enregistrée avec succès');
//   }
// }

// class DeleteUserActivitiesZones {
//   final String idActivitiesZones;
//   // constructeur
//   DeleteUserActivitiesZones(this.idActivitiesZones);
//   CollectionReference activitiesZones =
//       FirebaseFirestore.instance.collection('activities zones');

//   Future<void> deleteActivitiesZones() {
//     // Call the user's CollectionReference to add a new user
//     return activitiesZones
//         .doc(idActivitiesZones.toString())
//         .delete()
//         // ignore: avoid_print
//         .then((value) => print("User Deleted"))
//         // ignore: avoid_print
//         .catchError((error) => print("Failed to delete user: $error"));
//   }
// }
