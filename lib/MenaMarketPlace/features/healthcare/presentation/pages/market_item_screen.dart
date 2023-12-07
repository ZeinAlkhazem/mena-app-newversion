// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_button/group_button.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/info_title_widget.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/item_view_group_buttons.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/threed_viewer_widget.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/video_player.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/discount_info_widget.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/tab_sections.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/cubit/market_cubit.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/image_viewer_widget.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/product_description.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/product_specification.dart';

class MarketItemScreen extends StatefulWidget {
  const MarketItemScreen({super.key});

  @override
  State<MarketItemScreen> createState() => _MarketItemScreenState();
}

class _MarketItemScreenState extends State<MarketItemScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 300.h),
        child: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            final cubit = context.read<MarketCubit>();
            Widget selectView() {
              switch (cubit.viewType) {
                case 'Photos':
                  return const ImageViewerWidget();
                case '3D':
                  return const ThreeDViewerWidget();
                case 'Virtual Tour':
                  return const ImageViewerWidget();

                default:
                  return const VideoPlayerWidget();
              }
            }

            return AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: selectView(),
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ItemViewGroupButtons(),
              SizedBox(
                height: 10.h,
              ),
              const InfoTitleWidget(
                title: 'Apple',
                desc:
                    '''AirPods Max a perfect balance of exhilarating high-fidelity audio''',
              ),
              SizedBox(
                height: 20.h,
              ),
              const InfoTitleWidget(
                title: 'Price',
                desc: 'AED 500.00',
                descInfo: '( Inclusive of Vat )',
              ),
              SizedBox(
                height: 5.h,
              ),
              const DiscountInfoWidget(oldPrice: '639.00', discount: '21% OFF'),
              const Divider(
                thickness: 0.5,
              ),
              TabBar(
                controller: tabController,
                unselectedLabelStyle: TextStyle(
                  color: const Color(0xFF939393),
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
                labelStyle: TextStyle(
                  color: const Color(0xFF286294),
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: const Color(0xFF286294),
                tabs: const [
                  Tab(text: 'Descriptions'),
                  Tab(text: 'Specification'),
                ],
              ),
              SizedBox(
                height: 1700.h,
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    ProductDescription(),
                    ProductSpecification(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
