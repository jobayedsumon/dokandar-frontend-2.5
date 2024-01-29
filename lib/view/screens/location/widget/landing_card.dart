import 'package:flutter/material.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_image.dart';

class LandingCard extends StatelessWidget {
  final String icon;
  final String title;
  const LandingCard({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).primaryColor.withOpacity(0.05),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        CustomImage(
          image: icon,
          height: 45, width: 45,
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),

      ]),
    );
  }
}
