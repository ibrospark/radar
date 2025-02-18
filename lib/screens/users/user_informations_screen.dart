// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UserInformationsScreen extends StatefulWidget {
//   const UserInformationsScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _UserInformationsScreenState createState() => _UserInformationsScreenState();
// }

// class _UserInformationsScreenState extends State<UserInformationsScreen> {
//   final Stream<QuerySnapshot> _usersStream =
//       FirebaseFirestore.instance.collection('users').snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _usersStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text("Loading");
//         }

//         return Material(
//           child: ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data()! as Map<String, dynamic>;
//               return ListTile(
//                 title: Text(
//                   "${data['Nom']} ${data['Prenom']}",
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 20,
//                   ),
//                 ),
//                 // subtitle: Text(
//                 //   data['Prenom'].toString(),
//                 //   style: GoogleFonts.poppins(
//                 //     fontWeight: FontWeight.w600,
//                 //     fontSize: 12,
//                 //   ),
//                 // ),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
