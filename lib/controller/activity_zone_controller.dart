import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radar/models/activity_zone_model.dart';

class ActivityZoneController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<ActivityZone> activityZones = <ActivityZone>[].obs;
  late final String userId;

  @override
  void onInit() {
    super.onInit();
    userId = auth.currentUser?.uid ?? '';
    fetchActivityZones();
  }

  void fetchActivityZones() async {
    try {
      final snapshot = await firestore
          .collection('activityZones')
          .where('idUser', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        activityZones.value = snapshot.docs
            .map((doc) => ActivityZone.fromJson(doc.data()))
            .toList();
      }
    } catch (e) {
      print('Error fetching activity zones: $e');
    }
  }

  Future<void> addActivityZone(ActivityZone zone) async {
    try {
      await firestore.collection('activityZones').add(zone.toJson());
      activityZones.add(zone);
    } catch (e) {
      print('Error adding activity zone: $e');
    }
  }

  Future<void> deleteActivityZone(String zoneId) async {
    try {
      await firestore
          .collection('activityZones')
          .where('id', isEqualTo: zoneId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      activityZones.removeWhere((zone) => zone.id == zoneId);
    } catch (e) {
      print('Error deleting activity zone: $e');
    }
  }
}
