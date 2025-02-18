import 'package:flutter/material.dart';
import 'package:radar/_builds/build_drawer.dart';
import 'package:radar/_builds/build_map.dart';
import 'package:radar/utils/constants.dart';

class MainMapsScreen extends StatefulWidget {
  const MainMapsScreen({super.key});

  @override
  State<MainMapsScreen> createState() => _MainMapsScreenState();
}

class _MainMapsScreenState extends State<MainMapsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DraggableScrollableController? draggableScrollableController;

  @override
  void initState() {
    super.initState();
    print(rxMapController.markers.length);
    // Initialiser le contrôleur ici
    draggableScrollableController = DraggableScrollableController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rxHouseController.resetAllControllers();
    });
  }

  @override
  void dispose() {
    // Dispose du contrôleur pour libérer les ressources
    draggableScrollableController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: buildDrawer(),
      body: buildGoogleMap(scaffoldKey,
          draggableScrollableController: draggableScrollableController),
    );
  }
}
