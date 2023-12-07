import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSpecification extends StatelessWidget {
  const ProductSpecification({
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
        const Text(
          'Industry-specific attributes \n',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        Table(
          border: TableBorder.all(color: const Color(0xFFD9D9D9)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: List<TableRow>.generate(
            3,
            (index) => TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'attribute ${index + 1} ',
                      style: const TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Lorem ipsum dolor',
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0.08,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const Text(
          'Other attributes \n',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        Table(
          border: TableBorder.all(color: const Color(0xFFD9D9D9)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: List<TableRow>.generate(
            8,
            (index) => TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'attribute ${index + 1} ',
                      style: const TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Lorem ipsum dolor',
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0.08,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
