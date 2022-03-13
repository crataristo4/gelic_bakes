import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';

//Display full image
class ShowImageScreen extends StatelessWidget {
  final image;

  const ShowImageScreen({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            //  color: const Color(0xff7c94b6),
            color: Colors.black45,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.colorDodge),
              image: CachedNetworkImageProvider(
                image!,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: tenDp),
        ),
      ),
    );
  }
}
