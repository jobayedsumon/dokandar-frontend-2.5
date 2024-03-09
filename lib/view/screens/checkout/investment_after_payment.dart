import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_button.dart';

class InvestmentAfterPaymentScreen extends StatelessWidget {
  final bool isSuccessful;

  const InvestmentAfterPaymentScreen({super.key, required this.isSuccessful});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text('Investment Payment',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                isSuccessful
                    ? const Text('Successful',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                    : const Text('Failed',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CustomButton(
                      width: ResponsiveHelper.isDesktop(context)
                          ? 300
                          : double.infinity,
                      buttonText: 'back_to_home'.tr,
                      onPressed: () {
                        Get.offAllNamed(RouteHelper.getInitialRoute());
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
