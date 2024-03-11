import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/controller/splash_controller.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_button.dart';
import 'package:dokandar/view/base/custom_image.dart';
import 'package:dokandar/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvestmentPaymentDialogue extends StatefulWidget {
  const InvestmentPaymentDialogue({Key? key, required this.packageId})
      : super(key: key);

  final int? packageId;

  @override
  State<InvestmentPaymentDialogue> createState() =>
      _InvestmentPaymentDialogueState();
}

class _InvestmentPaymentDialogueState extends State<InvestmentPaymentDialogue> {
  @override
  void initState() {
    super.initState();
    Get.find<InvestmentController>()
        .changeDigitalPaymentName('', isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor.withOpacity(0.5),
            ),
            padding: const EdgeInsets.all(3),
            child: const Icon(Icons.clear),
          ),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),
      GetBuilder<InvestmentController>(builder: (investmentController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
          ),
          width: context.width * 0.8,
          height: context.height * 0.5,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Text('Invest In Project'.tr,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                      'Pay through secure digital payment gateways to invest in this project'
                          .tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      textAlign: TextAlign.center),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Row(children: [
                    Text('payment_method'.tr,
                        style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    // Expanded(
                    //     child: Text('faster_and_secure_way_to_pay_bill'.tr,
                    //         style: robotoRegular.copyWith(
                    //             fontSize: Dimensions.fontSizeSmall,
                    //             color: Theme.of(context).hintColor))),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Get.find<SplashController>()
                          .configModel!
                          .activePaymentMethodList!
                          .isNotEmpty
                      ? ListView.builder(
                          itemCount: Get.find<SplashController>()
                              .configModel!
                              .activePaymentMethodList!
                              .length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isSelected = Get.find<SplashController>()
                                    .configModel!
                                    .activePaymentMethodList![index]
                                    .getWay! ==
                                investmentController.digitalPaymentName;
                            return InkWell(
                              onTap: () {
                                investmentController.changeDigitalPaymentName(
                                    Get.find<SplashController>()
                                        .configModel!
                                        .activePaymentMethodList![index]
                                        .getWay!);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.05)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeLarge),
                                child: Row(children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).cardColor,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .disabledColor)),
                                    child: Icon(Icons.check,
                                        color: Theme.of(context).cardColor,
                                        size: 16),
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeDefault),
                                  CustomImage(
                                    height: 20,
                                    fit: BoxFit.contain,
                                    image:
                                        '${Get.find<SplashController>().configModel!.baseUrls!.gatewayImageUrl}/${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImage!}',
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    child: Text(
                                      Get.find<SplashController>()
                                              .configModel!
                                              .activePaymentMethodList![index]
                                              .getWayTitle ??
                                          '',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          })
                      : Text('no_payment_method_is_available'.tr,
                          style: robotoMedium),
                  InkWell(
                    onTap: () {
                      investmentController
                          .changeDigitalPaymentName('investment_balance');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: investmentController.digitalPaymentName ==
                                  'investment_balance'
                              ? Colors.blue.withOpacity(0.05)
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeLarge),
                      child: Row(children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: investmentController.digitalPaymentName ==
                                      'investment_balance'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).cardColor,
                              border: Border.all(
                                  color: Theme.of(context).disabledColor)),
                          child: Icon(Icons.check,
                              color: Theme.of(context).cardColor, size: 16),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Icon(Icons.account_balance_wallet,
                            color: Theme.of(context).primaryColor, size: 20),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Text(
                            'Investment Balance',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ),
            ),
            CustomButton(
              color: Colors.green,
              buttonText: 'Pay & Invest'.tr,
              onPressed: () {
                if (widget.packageId == null) {
                  showCustomSnackBar('No package id found!');
                } else if (investmentController.digitalPaymentName == '') {
                  showCustomSnackBar('please_select_payment_method'.tr);
                } else {
                  investmentController.investInPackage(widget.packageId!,
                      investmentController.digitalPaymentName!);
                }
              },
            ),
          ]),
        );
      })
    ]);
  }
}
