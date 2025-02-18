import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DraggableScrollableSheetController extends GetxController {
  RxDouble currentExtent = 0.3.obs;
  RxDouble minExtent = 0.1.obs;
  RxDouble maxExtent = 0.9.obs;

  void updateExtent(double extent, DraggableScrollableController controller) {
    if (extent >= minExtent.value && extent <= maxExtent.value) {
      controller.animateTo(extent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      currentExtent.value = extent;
    }
  }

  void resetExtent(DraggableScrollableController controller) {
    currentExtent.value = 0.3;
    controller.animateTo(currentExtent.value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void closeExtent(DraggableScrollableController controller) {
    controller.animateTo(minExtent.value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
