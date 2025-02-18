// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:radar/screens/_builds/build_all_elements.dart';
// import 'package:radar/models/houses_model.dart';
// import 'package:radar/utils/constants.dart';

// class ContinuousResearchScreen extends StatefulWidget {
//   const ContinuousResearchScreen({super.key});

//   @override
//   State<ContinuousResearchScreen> createState() =>
//       _ContinuousResearchScreenState();
// }

// class _ContinuousResearchScreenState extends State<ContinuousResearchScreen> {
// // Instance of collection's House
//   final Stream<QuerySnapshot> _continuousResearchStream = FirebaseFirestore
//       .instance
//       .collection('continuous research')
//       .where('Id User', isEqualTo: user?.uid)
//       .orderBy('Date de publication', descending: true)
//       .snapshots();

//   // Menu item -----------------------------------------
//   _buildMyTextRich(String? label, text) {
//     return RichText(
//       text: TextSpan(
//         text: '$label : ',
//         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: Colors.white,
//             ),
//         children: <TextSpan>[
//           TextSpan(
//             text: '$text',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.white,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(
//         title: "Mes recherches continues",
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _continuousResearchStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Text(
//                 "Quelques chose c'est mal passé lors de la connexion à la base de donnée.");
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               //Map Data as  Map String
//               Map<String, dynamic> data =
//                   document.data()! as Map<String, dynamic>;
//               const menuItems = <String>[
//                 'Supprimer',
//               ];
//               Timestamp t = data['Date de publication'] as Timestamp;
//               final List<PopupMenuItem<String>> popUpMenuItems = menuItems
//                   .map(
//                     (String value) => PopupMenuItem<String>(
//                         value: value,
//                         child: Row(
//                           children: [
//                             const Icon(Icons.delete),
//                             Text('  $value'),
//                           ],
//                         )),
//                   )
//                   .toList();
//               late String selectedValPopup;
//               return Container(
//                 margin: const EdgeInsets.all(5),
//                 padding: const EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.bottomLeft,
//                       colors: <Color>[
//                         thirdColor,
//                         secondaryColor,
//                       ],
//                       tileMode: TileMode.mirror,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withOpacity(0.3), blurRadius: 3),
//                     ]),
//                 child: ListTile(
//                   // leading: CircleAvatar(
//                   //   radius: 30,
//                   //   backgroundImage:
//                   //       // data['Lien Image'].toString().isEmpty
//                   //       //     ? const NetworkImage("https://placehold.co/600x600.png")
//                   //       //     :
//                   //       data['Lien Image'].isEmpty
//                   //           ? const CachedNetworkImageProvider(
//                   //               "https://firebasestorage.googleapis.com/v0/b/prime-depot-279715.appspot.com/o/default_assets%2Fempty.jpg?alt=media&token=fb159289-0237-48e4-b6c8-5a32e8ef628e")
//                   //           : CachedNetworkImageProvider(
//                   //               "${data['Lien Image'][0]!}"),
//                   // ),

//                   subtitle: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       buildText(
//                         text: 'Recherche, ${data['Catégorie']}'.toUpperCase(),
//                         fontSize: 15,
//                         color: primaryColor,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       buildText(
//                           fontStyle: FontStyle.italic,
//                           fontWeight: FontWeight.w100,
//                           text:
//                               "Recherché le ${t.toDate().day} / ${t.toDate().month} / ${t.toDate().year} à ${t.toDate().hour}h ${t.toDate().minute} min"),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       if (data["Catégorie"].toString().isNotEmpty)
//                         _buildMyTextRich("Catégorie", data['Catégorie']),
//                       if (data["Nombre de chambres"].toString().isNotEmpty)
//                         _buildMyTextRich(
//                             "Nombre de chambre(s)", data['Nombre de chambres']),
//                       if (data["Durée locative"].toString().isNotEmpty)
//                         _buildMyTextRich(
//                             "Durée locative", data['Durée locative']),
//                       Row(
//                         children: [
//                           if (data["Min prix"].toString().isNotEmpty)
//                             _buildMyTextRich("Min prix", data['Min prix']),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           if (data["Max prix"].toString().isNotEmpty)
//                             _buildMyTextRich("Max prix ", data['Max prix']),
//                         ],
//                       ),
//                       if (data["Nombre d'étages"].toString().isNotEmpty)
//                         _buildMyTextRich(
//                             "Nombre d'étages", data["Nombre d'étages"]),
//                       if (data["Nombre de salles de bain"]
//                           .toString()
//                           .isNotEmpty)
//                         _buildMyTextRich("Nombre de salles de bain",
//                             data['Nombre de salles de bain']),
//                       if (data["Nombre de salons"].toString().isNotEmpty)
//                         _buildMyTextRich(
//                             "Nombre de salons", data['Nombre de salons']),
//                       if (data["Options"].toString().isNotEmpty)
//                         _buildMyTextRich("Options", data['Options']),
//                       if (data["Quartier"].toString().isNotEmpty)
//                         _buildMyTextRich("Quartier", data['Quartier']),
//                       if (data["Superficie"].toString().isNotEmpty)
//                         _buildMyTextRich("Superficie", data['Superficie']),
//                       if (data["Type de transaction"].toString().isNotEmpty)
//                         _buildMyTextRich(
//                             "Type de transaction", data['Type de transaction']),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     color: Colors.white,
//                     onSelected: (String newValue) {
//                       selectedValPopup = newValue;

//                       if (selectedValPopup == 'Supprimer') {
//                         showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return Dialog(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 child: Container(
//                                   constraints:
//                                       const BoxConstraints(maxHeight: 200),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(
//                                           height: 20,
//                                         ),
//                                         Text(
//                                           "Êtes vous sur de vouloir supprimer ce contenu ? ",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .titleMedium,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         const SizedBox(
//                                           height: 20,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             ElevatedButton.icon(
//                                                 style: ElevatedButton.styleFrom(
//                                                   textStyle: const TextStyle(
//                                                       fontSize: 12),
//                                                   backgroundColor: Colors.red,
//                                                 ),
//                                                 icon: const Icon(Icons.delete),
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 label:
//                                                     const Text('Non, annuler')),
//                                             ElevatedButton.icon(
//                                                 style: ElevatedButton.styleFrom(
//                                                   textStyle: const TextStyle(
//                                                       fontSize: 12),
//                                                   backgroundColor: Colors.green,
//                                                 ),
//                                                 icon: const Icon(Icons.delete),
//                                                 onPressed: () {
//                                                   DeleteContinuousResearch(
//                                                           data['Id']!)
//                                                       .deleteContinuousResearch();
//                                                   Navigator.pop(context);
//                                                   buildSnackbar(
//                                                     title: "Succès !",
//                                                     message:
//                                                         "Recherche continue, supprimée avec succès !",
//                                                   );
//                                                 },
//                                                 label: const Text(
//                                                     'Oui, supprimer')),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             });
//                       }
//                     },
//                     itemBuilder: (BuildContext context) => popUpMenuItems,
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
