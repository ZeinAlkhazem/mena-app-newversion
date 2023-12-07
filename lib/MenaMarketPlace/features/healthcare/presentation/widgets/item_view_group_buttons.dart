import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/cubit/market_cubit.dart';

class ItemViewGroupButtons extends StatelessWidget {
  const ItemViewGroupButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: GroupButton<String>(
        buttons: const ['Video', 'Photos', '3D', 'Virtual Tour'],
        buttonBuilder: (selected, value, context) => selected
            ? Container(
                padding: const EdgeInsets.all(5),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
        onSelected: (value, index, isSelected) {
          if (isSelected) {
            context.read<MarketCubit>().changeProductView(value);
          }
        },
        controller: GroupButtonController(selectedIndex: 0),
      ),
    );
  }
}
