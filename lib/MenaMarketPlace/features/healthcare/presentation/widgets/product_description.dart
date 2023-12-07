import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/customer_info_widget.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/provider_info_widget.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/related_product_item.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          'Description of product',
          style: TextStyle(
            color: const Color(0xFF444444),
            fontSize: 14.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu rhoncus, turpis nisl sed. Neque viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla et. A, blandit morbi suspendisse vel malesuada purus massa mi. Faucibus neque a mi hendrerit.  Read More''',
          style: TextStyle(
            color: const Color(0xFF444444),
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Client Reviews',
              style: TextStyle(
                color: const Color(0xFF444444),
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                  size: 20,
                ),
                Text(
                  '654 Reviews',
                  style: TextStyle(
                    color: Color(0xFF286294),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Column(
          children: List.generate(
            2,
            (index) => const CustomerReviewsWidget(
              date: 'August 05 , 2021 ',
              descr:
                  '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu ra mi. Faucibus neque a mi hendrerit.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu ra mi. Faucibus neque a mi hendrerit.''',
              name: 'Armen Sargsyan',
              picture: '',
              rating: 4.5,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const Align(
          child: Text(
            'View more',
            style: TextStyle(
              color: Color(0xFF286294),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const Text(
          'Supplier',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Column(
          children: List.generate(
            1,
            (index) => const ProviderInfoWidget(
              name: 'Provider name',
              subSubCategory: 'Sub Sub Category',
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const Text(
          'Location',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/menamarket/location_map_outline_28 4.svg',
            ),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.17,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 346,
          height: 212,
          decoration: ShapeDecoration(
            color: const Color(0xFFD9D9D9),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/menamarket/Mapsicle Map.png',
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const Text(
          'Related Item',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 185,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 20.w,
            ),
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const RelatedProductItem(),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/menamarket/market_fill_blue_48 2.png',
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                side: const BorderSide(color: Color(0xFF286294)),
              ),
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/menamarket/chats_outline_28 2.svg',
              ),
              label: const Text(
                'Chats',
                style: TextStyle(
                  color: Color(0xFF286294),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF286294),
              ),
              onPressed: () {},
              child: const Text(
                'Send Inquiry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}
