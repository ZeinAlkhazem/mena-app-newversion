import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerReviewsWidget extends StatelessWidget {
  final String picture;
  final String name;
  final String date;
  final String descr;
  final double rating;
  const CustomerReviewsWidget({
    super.key,
    required this.picture,
    required this.name,
    required this.date,
    required this.descr,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
              radius: 15,
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            subtitle: Text(
              date,
              style: const TextStyle(
                color: Color(0xFFB2B3B5),
                fontSize: 8,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            trailing: RatingBarIndicator(
              rating: rating,
              itemBuilder: (context, index) => const Icon(
                Icons.star_rate_rounded,
                color: Colors.amber,
              ),
              itemSize: 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              descr,
              softWrap: true,
              style: const TextStyle(
                color: Color(0xFF444444),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
