import 'package:flutter/material.dart';

class ProviderProfileBody extends StatelessWidget {
  const ProviderProfileBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Text('Profile body')],
      ),
    );
  }
}
