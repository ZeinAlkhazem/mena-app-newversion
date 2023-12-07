

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'provider_icon_widget.dart';

class ProviderInfoWidget extends StatelessWidget {
  final String name;
  final String subSubCategory;
  const ProviderInfoWidget({
    super.key,
    required this.name,
    required this.subSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black.withOpacity(0.05000000074505806),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: const CircleAvatar(
              radius: 20,
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: Color(0xFF393F42),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            subtitle: Text(
              subSubCategory,
              style: const TextStyle(
                color: Color(0xFFB2B3B5),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            trailing: const Icon(
              Icons.add_box_outlined,
              color: Colors.blue,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 65.w,
              ),
              const Icon(
                Icons.star_rate_rounded,
                color: Colors.amber,
                size: 10,
              ),
              SizedBox(
                width: 3.w,
              ),
              const Text(
                '654 Reviews',
                style: TextStyle(
                  color: Color(0xFF393F42),
                  fontSize: 6,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              SvgPicture.asset(
                'assets/menamarket/location_map_outline_28 1.svg',
              ),
              SizedBox(
                width: 3.w,
              ),
              const Text(
                '5 KM',
                style: TextStyle(
                  color: Color(0xFF393F42),
                  fontSize: 6,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProviderIconWidget(
                  icon: 'assets/menamarket/storefront_outline_28 1.svg',
                  title: 'My Store',
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 1.5,
                    color: Color(0xFF286294),
                  ),
                ),
                ProviderIconWidget(
                  icon: 'assets/menamarket/users_3_outline_20 1.svg',
                  title: 'Followers',
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 1.5,
                    color: Color(0xFF286294),
                  ),
                ),
                ProviderIconWidget(
                  icon: 'assets/menamarket/profile_28 1.svg',
                  title: 'My Profile',
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 1.5,
                    color: Color(0xFF286294),
                  ),
                ),
                ProviderIconWidget(
                  icon: 'assets/menamarket/share_outline_28 1.svg',
                  title: 'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
