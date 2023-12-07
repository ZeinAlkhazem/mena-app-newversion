import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageViewerWidget extends StatelessWidget {
  const ImageViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8aGVhZHBob25lc3xlbnwwfHwwfHx8MA%3D%3D',
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 20,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: CircleAvatar(
                  backgroundColor: Color(0x4C252836),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/menamarket/heart_circle_outline_28 2.svg',
              ),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                'assets/menamarket/share_external_outline_28 3.svg',
              ),
            ],
          ),
        ),
        const Positioned(
          left: 10,
          top: 20,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: CircleAvatar(
              backgroundColor: Color(0x4C252836),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
