import 'package:country_code_picker/country_code.dart';
import 'package:dokandar/controller/wallet_controller.dart';
import 'package:dokandar/helper/price_converter.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_button.dart';
import 'package:dokandar/view/base/custom_snackbar.dart';
import 'package:dokandar/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../base/code_picker_widget.dart';

class WalletFundTransfer extends StatefulWidget {
  const WalletFundTransfer({Key? key}) : super(key: key);

  @override
  State<WalletFundTransfer> createState() => _WalletFundTransferState();
}

class _WalletFundTransferState extends State<WalletFundTransfer> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  String _countryDialCode = '+880';

  void transferFund(double amount, WalletController walletController) async {
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    String phone = _phoneController.text.trim();
    String numberWithCountryCode = _countryDialCode + phone;
    bool isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode =
            '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (e) {}
    }
    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
                iconPadding: const EdgeInsets.only(bottom: 8.0),
                title: Center(
                    child: Column(
                  children: [
                    Text('Confirm to Transfer Fund',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(2)
                      },
                      border: TableBorder.all(
                          color: Theme.of(context).disabledColor),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Amount',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Recipient ID',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(PriceConverter.convertPrice(amount),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(numberWithCountryCode,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault)),
                          )
                        ]),
                      ],
                    ),
                  ],
                )),
                actions: [
                  Center(
                    child: CustomButton(
                      onPressed: () async {
                        await walletController.transferFund(
                            amount, numberWithCountryCode);
                      },
                      buttonText: 'Confirm',
                    ),
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Transfer your wallet balance to someone.',
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).disabledColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(children: [
            CodePickerWidget(
              onChanged: (CountryCode countryCode) {
                _countryDialCode = countryCode.dialCode!;
              },
              initialSelection: _countryDialCode,
              favorite: const ['+880', 'BD'],
              showDropDownButton: true,
              padding: EdgeInsets.zero,
              showFlagMain: true,
              flagWidth: 30,
              dialogBackgroundColor: Theme.of(context).cardColor,
              textStyle: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Expanded(
                flex: 1,
                child: CustomTextField(
                  titleText: 'Enter recipient phone number',
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  inputType: TextInputType.phone,
                )),
          ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.3)),
            child: CustomTextField(
              titleText: 'Enter amount',
              controller: _amountController,
              inputType: TextInputType.phone,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          GetBuilder<WalletController>(builder: (walletController) {
            return !walletController.isLoading
                ? CustomButton(
                    buttonText: 'Transfer',
                    onPressed: () {
                      if (_phoneController.text.trim().isEmpty) {
                        if (Get.isBottomSheetOpen!) {
                          Get.back();
                        }
                        showCustomSnackBar('Phone number is required');
                      } else if (_amountController.text.trim().isEmpty) {
                        if (Get.isBottomSheetOpen!) {
                          Get.back();
                        }
                        showCustomSnackBar('Amount is required');
                      } else {
                        double amount =
                            double.parse(_amountController.text.trim());

                        if (amount < 100) {
                          if (Get.isBottomSheetOpen!) {
                            Get.back();
                          }
                          showCustomSnackBar(
                              'Minimum transfer amount is 100 ৳');
                        } else {
                          transferFund(amount, walletController);
                        }
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator());
          }),
        ]),
      ),
    );
  }
}
