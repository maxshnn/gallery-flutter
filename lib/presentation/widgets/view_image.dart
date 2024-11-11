import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../const.dart';
import '../../domain/entity/post.dart';
import '../../domain/entity/user.dart';

class ViewImage extends StatefulWidget {
  final User? user;
  final Post post;
  const ViewImage({
    Key? key,
    this.user,
    required this.post,
  }) : super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    User? user = widget.user;
    final date = DateFormat('dd MMM. y');
    return DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 1,
        builder: (context, scrollController) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: post.image!.name,
                          // height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            decoration: BoxDecoration(color: Colors.grey[350]),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/svg/error.svg'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('broken image',
                                      style: ThemeApp.textViewName),
                                ),
                              ],
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.name,
                                  style: ThemeApp.textViewName,
                                  softWrap: true,
                                ),
                                Text(user?.username ?? post.user,
                                    style: ThemeApp.textViewUsername),
                                Text(
                                  post.description,
                                  softWrap: true,
                                  style: ThemeApp.textViewDescription,
                                ),
                                Text(
                                  date.format(DateTime.parse(post.dateCreate)),
                                  style: ThemeApp.textViewDate,
                                )
                              ]
                                  .map((widget) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: widget,
                                      ))
                                  .toList()),
                        ),
                      ]),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
