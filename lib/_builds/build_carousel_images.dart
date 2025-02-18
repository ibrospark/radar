import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCarouselImage(List<String> images) {
  return CarouselSlider.builder(
    itemCount: images.length,
    options: CarouselOptions(
      height: 250.0,
      enableInfiniteScroll: false,
    ),
    itemBuilder: (context, index, realIndex) {
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: buildImageDialog(images, index),
              );
            },
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(18.0),
            image: DecorationImage(
              image: CachedNetworkImageProvider(images[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}

Widget buildImageDialog(List<String> images, int initialIndex) {
  return CarouselSlider.builder(
    itemCount: images.length,
    options: CarouselOptions(
      initialPage: initialIndex,
      height: Get.size.height * 0.7,
      enableInfiniteScroll: false,
    ),
    itemBuilder: (context, index, realIndex) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(images[index]),
            fit: BoxFit.contain,
          ),
        ),
      );
    },
  );
}
