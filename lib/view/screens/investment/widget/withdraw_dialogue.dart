import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WithdrawDialogue extends StatefulWidget {
  const WithdrawDialogue({Key? key}) : super(key: key);

  @override
  State<WithdrawDialogue> createState() => _WithdrawDialogueState();
}

class _WithdrawDialogueState extends State<WithdrawDialogue> {
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
          width: ResponsiveHelper.isDesktop(context)
              ? context.width * 0.4
              : context.width * 0.8,
          height: ResponsiveHelper.isDesktop(context)
              ? context.height * 0.8
              : context.height * 0.8,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(children: [
            Flexible(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Center(
                        child: Text('Send Withdraw Request'.tr,
                            style: robotoBold.copyWith(
                                fontSize: 22,
                                color: Theme.of(context).primaryColor)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(
                          'Send your withdraw request to admin. You will get your money and the request will be marked as paid.'
                              .tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                          textAlign: TextAlign.center),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      TextFormField(
                        controller:
                            investmentController.withdrawalAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount'.tr,
                          hintText: 'Enter amount'.tr,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Text('Select Payment Method'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      ListView.builder(
                          itemCount:
                              investmentController.withdrawalMethodList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isSelected = investmentController
                                    .withdrawalMethodList[index] ==
                                investmentController.withdrawalMethod;
                            return InkWell(
                              onTap: () {
                                investmentController.changeWithdrawalMethod(
                                    investmentController
                                        .withdrawalMethodList[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.05)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.paddingSizeExtraSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
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
                                      width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    child: Text(
                                      '${toBeginningOfSentenceCase(investmentController.withdrawalMethodList[index])}',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          }),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      investmentController.withdrawalMethod == 'bank'
                          ? Column(
                              children: [
                                TextFormField(
                                  controller: investmentController
                                      .withdrawalAccountNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Account Name'.tr,
                                    hintText: 'Enter account name'.tr,
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                TextFormField(
                                  controller: investmentController
                                      .withdrawalAccountNumberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Account Number'.tr,
                                    hintText: 'Enter account number'.tr,
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                TextFormField(
                                  controller: investmentController
                                      .withdrawalBankNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Bank Name'.tr,
                                    hintText: 'Enter bank name'.tr,
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                TextFormField(
                                  controller: investmentController
                                      .withdrawalBranchNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Branch Name'.tr,
                                    hintText: 'Enter branch name'.tr,
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                TextFormField(
                                  controller: investmentController
                                      .withdrawalRoutingNumberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Routing Number'.tr,
                                    hintText: 'Enter routing number'.tr,
                                  ),
                                ),
                              ],
                            )
                          : TextFormField(
                              controller: investmentController
                                  .withdrawalMobileNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number (Personal)'.tr,
                                hintText: 'Enter mobile number (Personal)'.tr,
                              ),
                            )
                    ]),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            CustomButton(
              width: 200,
              buttonText: 'Send Request'.tr,
              onPressed: () {
                if (investmentController
                    .withdrawalAmountController.text.isEmpty) {
                  Get.snackbar('Error'.tr, 'Enter withdrawal amount'.tr,
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                investmentController.sendWithdrawRequest();
              },
            ),
          ]),
        );
      })
    ]);
  }
}
