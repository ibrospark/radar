import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

Widget buildDraggableScrollableSheet(
    {Widget? child, required draggableScrollableController}) {
  return DraggableScrollableSheet(
    controller: draggableScrollableController,
    initialChildSize: rxDraggableScrollableSheetController.currentExtent.value,
    minChildSize: rxDraggableScrollableSheetController.minExtent.value,
    maxChildSize: rxDraggableScrollableSheetController.maxExtent.value,
    builder: (BuildContext context, ScrollController scrollController) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: gradient,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Divider(
                  thickness: 3.0,
                  indent: Get.size.width * 0.42,
                  endIndent: Get.size.width * 0.42,
                  color: white,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: child ?? Container(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
