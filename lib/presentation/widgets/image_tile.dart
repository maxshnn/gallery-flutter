import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageTile extends StatelessWidget {
  final state;
  final int index;
  const ImageTile({
    Key? key,
    required this.index,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: state.posts![index].image!.name,
        fit: BoxFit.cover,
        height: 150,
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          height: 150,
          decoration: BoxDecoration(color: Colors.grey[350]),
        ),
        errorWidget: (context, error, stackTrace) => Container(
          height: 150,
          decoration: BoxDecoration(color: Colors.grey[350]),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/error.svg', height: 50),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('broken image'),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
