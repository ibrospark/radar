import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/utils/constants.dart';

Future<void> buildSearchContinueDialog() async {
  await showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 20),
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildText(
                  text: "Souhaitez-vous passer en recherche continue?",
                  fontStyle: FontStyle.italic,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  overflow: TextOverflow.visible,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: yellowColor,
                      ),
                      child: const Text(
                        'La recherche continue vous permet de recevoir des notifications lorsque le bien que vous recherchez est disponible',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Positioned(
                      bottom: 5,
                      right: 5,
                      child: Icon(
                        Icons.info,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        label: const Text("Non"),
                        icon: const Icon(Icons.cancel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          textStyle: Theme.of(context).textTheme.titleSmall,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton.icon(
                        label: const Text("Oui"),
                        icon: const Icon(Icons.check),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellowColor,
                          textStyle: Theme.of(context).textTheme.titleSmall,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
