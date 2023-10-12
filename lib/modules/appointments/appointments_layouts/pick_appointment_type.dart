import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/local_models.dart';

class PickAppointmentType extends StatelessWidget {
  const PickAppointmentType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Appointment type',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose from list bellow:'),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => AppointmentTypeItem(
                appointmentItem: appointmentCubit.appointmentTypes[index],
              ),
              separatorBuilder: (c, i) => heightBox(10.h),
              itemCount: appointmentCubit.appointmentTypes.length,
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentTypeItem extends StatelessWidget {
  const AppointmentTypeItem({
    required this.appointmentItem,
    super.key,
  });

  final ItemWithTitleAndCallback appointmentItem;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      childWidget: Padding(
        padding: EdgeInsets.all(8),
        child: Text('jshdk'),
      ),
    );
  }
}
