import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';

class StayImagePage extends StatelessWidget{
  List<String> images;
  @override
  Widget build(BuildContext context) {
    if(images==null){
      images = ModalRoute.of(context).settings.arguments;
      print(images);
//      print(parms);
    }
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
//            heroTag: galleryItems[index].id,
          );
        },
        itemCount: images.length,
//        loadingChild: images.loadingChild,
//        backgroundDecoration: widget.backgroundDecoration,
//        pageController: widget.pageController,
//        onPageChanged: onPageChanged,
      ),
    );
  }
}