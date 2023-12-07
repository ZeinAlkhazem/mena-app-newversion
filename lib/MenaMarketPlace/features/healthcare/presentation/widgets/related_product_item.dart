
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RelatedProductItem extends StatelessWidget {
  const RelatedProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.topCenter,
          width: 129,
          height: 180,
          decoration: const ShapeDecoration(
            color: Color(0x99EBEBEB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.61),
                topRight: Radius.circular(12.61),
                bottomLeft: Radius.circular(12.61),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Image.asset(
              'assets/menamarket/MX402_AV4 1.png',
            ),
          ),
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(
                left: 1,
                right: 1,
                bottom: 1,
              ),
              width: 128,
              height: 93,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.61),
                    topRight: Radius.circular(12.61),
                    bottomLeft: Radius.circular(12.61),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JBL Club Pro',
                    style: TextStyle(
                      color: Color(0xFF09090A),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  Text(
                    'Headset',
                    style: TextStyle(
                      color: Color(0xFF09090A),
                      fontSize: 9,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                        size: 15,
                      ),
                      Text(
                        '4.5',
                        style: TextStyle(
                          color: Color(0xFF2A2727),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'AED 420',
                    style: TextStyle(
                      color: Color(0xFF286294),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 15),
              child: Container(
                width: 29.18,
                height: 28.51,
                decoration: const ShapeDecoration(
                  color: Color(0xFF286294),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}