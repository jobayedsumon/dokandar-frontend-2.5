import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/zone_response_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_dropdown.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/screens/address/widget/address_widget.dart';
import 'package:sixam_mart/view/screens/location/pick_map_screen.dart';

class ParcelView extends StatelessWidget {
  final bool isSender ;
  final Widget bottomButton;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController houseController;
  final TextEditingController floorController;
  final String? countryCode;

  const ParcelView({
    Key? key, required this.isSender, required this.nameController, required this.phoneController,
    required this.streetController, required this.houseController, required this.floorController, required this.bottomButton, required this.countryCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode streetNode = FocusNode();
    final FocusNode houseNode = FocusNode();
    final FocusNode floorNode = FocusNode();
    final FocusNode nameNode = FocusNode();
    final FocusNode phoneNode = FocusNode();
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    String? countryDialCode;

    return SizedBox(width: Dimensions.webMaxWidth, child: GetBuilder<LocationController>(builder: (locationController) {
        return GetBuilder<ParcelController>(builder: (parcelController) {
          List<DropdownItem<int>> senderAddressList = parcelController.getDropdownAddressList(context: context, addressList: locationController.addressList, isSender: true);
          List<DropdownItem<int>> receiverAddressList = parcelController.getDropdownAddressList(context: context, addressList: locationController.addressList, isSender: false);
          List<AddressModel> senderAddress = parcelController.getAddressList(addressList: locationController.addressList, isSender: true);
          List<AddressModel> receiverAddress = parcelController.getAddressList(addressList: locationController.addressList, isSender: false);

          return SingleChildScrollView(
              controller: ScrollController(),
              child: Center(child: FooterView(
                child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      decoration: BoxDecoration(color: Theme.of(context).cardColor),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('pickup_location'.tr, style: robotoMedium),

                          TextButton.icon(
                            onPressed: () async {
                              if(ResponsiveHelper.isDesktop(Get.context)){
                                showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                                  return SizedBox(
                                    height: 300, width: 300,
                                    child: PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: false, route:'', onPicked: (AddressModel address) async {

                                      ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);

                                      AddressModel a = AddressModel(
                                        id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                                        address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                                        zoneIds: address.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                                      );

                                      if(parcelController.isPickedUp!) {
                                        parcelController.setPickupAddress(a, true);
                                      }else {
                                        parcelController.setDestinationAddress(a);
                                      }
                                    }),
                                  );
                                });
                              }else{
                                Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                                  fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) async {

                                  if(parcelController.isPickedUp!) {
                                    ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);
                                    AddressModel pickupAddress = AddressModel(
                                      id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                                      address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                                      zoneIds: responseModel.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                                    );
                                    parcelController.setPickupAddress(pickupAddress, true);
                                    parcelController.setSenderAddressIndex(0);
                                  }else {
                                    ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);
                                    AddressModel a = AddressModel(
                                      id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                                      address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                                      zoneIds: responseModel.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                                    );
                                    parcelController.setDestinationAddress(a);
                                    parcelController.setReceiverAddressIndex(0);
                                  }
                                },
                                ));
                              }
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: Text('add_new'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          ),
                        ]),

                        Container(
                          constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? 90 : 75),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {

                              if(parcelController.isSender){
                                parcelController.setPickupAddress(senderAddress[index], true);
                                parcelController.setSenderAddressIndex(index);
                                streetController.text = senderAddress[index].streetNumber ?? '';
                                houseController.text = senderAddress[index].house ?? '';
                                floorController.text = senderAddress[index].floor ?? '';
                              }else{
                                parcelController.setDestinationAddress(receiverAddress[index]);
                                parcelController.setReceiverAddressIndex(index);
                                streetController.text = receiverAddress[index].streetNumber ?? '';
                                houseController.text = receiverAddress[index].house ?? '';
                                floorController.text = receiverAddress[index].floor ?? '';
                              }
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: parcelController.isSender ? senderAddressList : receiverAddressList,
                            child: AddressWidget(
                              address: parcelController.isSender ? senderAddress[parcelController.senderAddressIndex!] : receiverAddress[parcelController.receiverAddressIndex!],
                              fromAddress: false, fromCheckout: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        !isDesktop ? CustomTextField(
                          hintText: ' ',
                          titleText: 'street_number'.tr,
                          inputType: TextInputType.streetAddress,
                          focusNode: streetNode,
                          nextFocus: houseNode,
                          controller: streetController,
                        ) : const SizedBox(),
                        SizedBox(height: !isDesktop ? Dimensions.paddingSizeLarge : 0),

                        Row(
                            children: [
                              isDesktop ? Expanded(
                                child: CustomTextField(
                                  showTitle: true,
                                  hintText: ' ',
                                  titleText: 'street_number'.tr,
                                  inputType: TextInputType.streetAddress,
                                  focusNode: streetNode,
                                  nextFocus: houseNode,
                                  controller: streetController,
                                ),
                              ) : const SizedBox(),
                              SizedBox(width: isDesktop ? Dimensions.paddingSizeSmall : 0),

                              Expanded(
                                child: CustomTextField(
                                  showTitle: isDesktop,
                                  hintText: ' ',
                                  titleText: 'house'.tr,
                                  inputType: TextInputType.text,
                                  focusNode: houseNode,
                                  nextFocus: floorNode,
                                  controller: houseController,
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(
                                child: CustomTextField(
                                  showTitle: isDesktop,
                                  hintText: ' ',
                                  titleText: 'floor'.tr,
                                  inputType: TextInputType.text,
                                  focusNode: floorNode,
                                  nextFocus: nameNode,
                                  controller: floorController,
                                ),
                              ),
                              //const SizedBox(height: Dimensions.paddingSizeLarge),
                            ]
                        ),
                      ]),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(parcelController.isSender ? 'sender_information'.tr : 'receiver_information'.tr, style: robotoMedium),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        CustomTextField(
                          showTitle: isDesktop,
                          hintText: ' ',
                          titleText: parcelController.isSender ? 'sender_name'.tr : 'receiver_name'.tr,
                          inputType: TextInputType.name,
                          focusNode: nameNode,
                          nextFocus: phoneNode,
                          controller: nameController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        // CustomTextField(
                        //   showTitle: isDesktop,
                        //   hintText: ' ',
                        //   titleText: parcelController.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
                        //   inputType: TextInputType.phone,
                        //   focusNode: _phoneNode,
                        //   inputAction: TextInputAction.done,
                        //   controller: phoneController,
                        // ),
                        CustomTextField(
                          titleText: parcelController.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
                          hintText: ' ',
                          controller: phoneController,
                          focusNode: phoneNode,
                          inputType: TextInputType.phone,
                          inputAction: TextInputAction.done,
                          isPhone: true,
                          showTitle: ResponsiveHelper.isDesktop(context),
                          onCountryChanged: (CountryCode countryCode) {
                            countryDialCode = countryCode.dialCode;
                            parcelController.setCountryCode(countryDialCode!, parcelController.isSender);
                          },
                          countryDialCode: countryDialCode ?? countryCode,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ]),
                    ),

                    ResponsiveHelper.isDesktop(context) ? Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.fontSizeSmall),
                      child: bottomButton,
                    ) : const SizedBox(),

                  ]),
                )),
              )),
            );
            }
          );
      }
    ),
    );
  }
}
