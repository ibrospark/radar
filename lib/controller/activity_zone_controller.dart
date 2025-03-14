import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityZoneController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var activityZones = <String>[].obs;
  final String userId; // Store the UUID of the current user

  ActivityZoneController(this.userId);

  @override
  void onInit() {
    super.onInit();
    fetchActivityZones();
  }

  void fetchActivityZones() async {
    try {
      // Fetch activity zones from Firestore based on the user ID (UUID)
      final snapshot = await firestore
          .collection('activityZones') // Replace with your collection
          .doc(userId) // Fetch zones related to this user
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        activityZones.value = List<String>.from(data['zones']);
      }
    } catch (e) {
      print('Error fetching activity zones: $e');
    }
  }

  void addActivityZone(String zone) async {
    activityZones.add(zone);
    await updateFirestore();
  }

  void deleteActivityZone(int index) async {
    activityZones.removeAt(index);
    await updateFirestore();
  }

  Future<void> updateFirestore() async {
    await firestore.collection('activityZones').doc(userId).set({
      'zones': activityZones,
    });
  }
}
