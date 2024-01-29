import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/parcel_category_model.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/screens/parcel/widget/parcel_view.dart';

class ParcelLocationScreen extends StatefulWidget {
  final ParcelCategoryModel category;
  const ParcelLocationScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ParcelLocationScreen> createState() => _ParcelLocationScreenState();
}

class _ParcelLocationScreenState extends State<ParcelLocationScreen> with TickerProviderStateMixin {
   final TextEditingController _senderNameController = TextEditingController();
   final TextEditingController _senderPhoneController = TextEditingController();
   final TextEditingController _receiverNameController = TextEditingController();
   final TextEditingController _receiverPhoneController = TextEditingController();
   final TextEditingController _senderStreetNumberController = TextEditingController();
   final TextEditingController _senderHouseController = TextEditingController();
   final TextEditingController _senderFloorController = TextEditingController();
   final TextEditingController _receiverStreetNumberController = TextEditingController();
   final TextEditingController _receiverHouseController = TextEditingController();
   final TextEditingController _receiverFloorController = TextEditingController();

  TabController? _tabController;
  String? _countryDialCode;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    initCall();
  }

  Future<void> initCall() async {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

    Get.find<ParcelController>().setPickupAddress(Get.find<LocationController>().getUserAddress(), false);
    Get.find<ParcelController>().setDestinationAddress(Get.find<LocationController>().getUserAddress(), notify: false);
    Get.find<ParcelController>().setIsPickedUp(true, false);
    Get.find<ParcelController>().setIsSender(true, false);
    Get.find<ParcelController>().setSenderAddressIndex(0, canUpdate: false);
    Get.find<ParcelController>().setReceiverAddressIndex(0, canUpdate: false);
    Get.find<ParcelController>().setCountryCode(_countryDialCode!, true);
    Get.find<ParcelController>().setCountryCode(_countryDialCode!, false);
    if(Get.find<AuthController>().isLoggedIn() && Get.find<LocationController>().addressList == null) {
      Get.find<LocationController>().getAddressList();
    }
    if (Get.find<AuthController>().isLoggedIn()){
      if(Get.find<UserController>().userInfoModel == null){
        await Get.find<UserController>().getUserInfo();
        _senderNameController.text = Get.find<UserController>().userInfoModel != null ? '${Get.find<UserController>().userInfoModel!.fName!} ${Get.find<UserController>().userInfoModel!.lName!}' : '';
        _countryDialCode = await splitPhoneNumber(Get.find<UserController>().userInfoModel != null ? Get.find<UserController>().userInfoModel!.phone! : '', true);
        _senderPhoneController.text = await splitPhoneNumber(Get.find<UserController>().userInfoModel != null ? Get.find<UserController>().userInfoModel!.phone! : '', false);
      }else{
        _senderNameController.text = '${Get.find<UserController>().userInfoModel!.fName!} ${Get.find<UserController>().userInfoModel!.lName!}';
        _countryDialCode = await splitPhoneNumber(Get.find<UserController>().userInfoModel != null ? Get.find<UserController>().userInfoModel!.phone! : '', true);
        _senderPhoneController.text = await splitPhoneNumber(Get.find<UserController>().userInfoModel != null ? Get.find<UserController>().userInfoModel!.phone! : '', false);
      }

    }

    _tabController?.addListener((){
      Get.find<ParcelController>().setIsPickedUp(_tabController!.index == 0, false);
      Get.find<ParcelController>().setIsSender(_tabController!.index == 0, true);
    });
  }

   Future<String> splitPhoneNumber(String number, bool returnCountyCode) async {
    String code = '';
    String pNumber = '';
     if(GetPlatform.isAndroid || GetPlatform.isIOS) {
       try {
         PhoneNumber phoneNumber = await PhoneNumberUtil().parse(number);
         code = '+${phoneNumber.countryCode}';
         pNumber = phoneNumber.nationalNumber;
         Get.find<ParcelController>().setCountryCode(phoneNumber.countryCode, true);
         Get.find<ParcelController>().setCountryCode(phoneNumber.countryCode, false);
       } catch (_) {}
     } else if(GetPlatform.isWeb) {
       if(number.contains(_countryDialCode!)) {
         pNumber = number.replaceAll(_countryDialCode!, '');
       } else {
         pNumber = number;
       }
     }
     if(returnCountyCode) {
       return code;
     } else {
       return pNumber;
     }
   }

  @override
  void dispose() {
    super.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _senderStreetNumberController.dispose();
    _senderHouseController.dispose();
    _senderFloorController.dispose();
    _receiverStreetNumberController.dispose();
    _receiverHouseController.dispose();
    _receiverFloorController.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'parcel_location'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<ParcelController>(builder: (parcelController) {
          return Column(children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Expanded(child: Column(children: [

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  width: Dimensions.webMaxWidth,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: [

                      TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 0,
                        indicator: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          color: Theme.of(context).primaryColor,
                        ),
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.black,
                        onTap: (int index) {
                          if(index == 1) {
                            _validateSender(parcelController);
                          }
                        },
                        unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text(
                              'sender_info'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: parcelController.isSender ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
                            ),
                          ),
                          Text(
                            'receiver_info'.tr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: !parcelController.isSender ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      // Container(height: 3, width: Dimensions.webMaxWidth, decoration: BoxDecoration(color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              ),

              Expanded(child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ParcelView(
                    isSender: true, nameController: _senderNameController, phoneController: _senderPhoneController, bottomButton: _bottomButton(),
                    streetController: _senderStreetNumberController, floorController: _senderFloorController, houseController: _senderHouseController,
                    countryCode: _countryDialCode,
                  ),
                  ParcelView(
                    isSender: false, nameController: _receiverNameController, phoneController: _receiverPhoneController, bottomButton: _bottomButton(),
                    streetController: _receiverStreetNumberController, floorController: _receiverFloorController, houseController: _receiverHouseController,
                    countryCode: _countryDialCode,
                  ),
                ],
              )),
            ])),

            ResponsiveHelper.isDesktop(context) ? const SizedBox() : _bottomButton(),

          ]);
        }),
      ),
    );
  }

  Widget _bottomButton() {
    return GetBuilder<ParcelController>(
      builder: (parcelController) {
        return CustomButton(
          margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          buttonText: parcelController.isSender ? 'continue'.tr : 'save_and_continue'.tr,
          onPressed: () async {
            if( _tabController!.index == 0 ) {
              _validateSender(parcelController);
            }
            else{
              String numberWithCountryCode = '${GetPlatform.isWeb ? '' : '+'}${parcelController.receiverCountryCode!}${_receiverPhoneController.text.trim()}';
              PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
              numberWithCountryCode = phoneValid.phone;

              if(parcelController.destinationAddress == null) {
                  showCustomSnackBar('select_destination_address'.tr);
              }
              else if(_receiverNameController.text.isEmpty){
                showCustomSnackBar('enter_receiver_name'.tr);
              }
              else if(_receiverPhoneController.text.isEmpty){
                showCustomSnackBar('enter_receiver_phone_number'.tr);
              }
              else if (!phoneValid.isValid) {
                showCustomSnackBar('invalid_phone_number'.tr);
              }
              else {
                AddressModel destination = AddressModel(
                  address: parcelController.destinationAddress!.address,
                  additionalAddress: parcelController.destinationAddress!.additionalAddress,
                  addressType: parcelController.destinationAddress!.addressType,
                  contactPersonName: _receiverNameController.text.trim(),
                  contactPersonNumber: numberWithCountryCode,
                  latitude: parcelController.destinationAddress!.latitude,
                  longitude: parcelController.destinationAddress!.longitude,
                  method: parcelController.destinationAddress!.method,
                  zoneId: parcelController.destinationAddress!.zoneId,
                  zoneIds: parcelController.destinationAddress!.zoneIds,
                  id: parcelController.destinationAddress!.id,
                  streetNumber: _receiverStreetNumberController.text.trim(),
                  house: _receiverHouseController.text.trim(),
                  floor: _receiverFloorController.text.trim(),
                );

                parcelController.setDestinationAddress(destination);

                Get.toNamed(RouteHelper.getParcelRequestRoute(
                  widget.category,
                  Get.find<ParcelController>().pickupAddress!,
                  Get.find<ParcelController>().destinationAddress!,
                ));
              }
           }
          },
        );
      }
    );
  }

  Future<void> _validateSender(ParcelController parcelController) async {
    String numberWithCountryCode = '${GetPlatform.isWeb ? '' : '+'}${parcelController.senderCountryCode??''}${_senderPhoneController.text.trim()}';
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if(Get.find<ParcelController>().pickupAddress == null) {
      showCustomSnackBar('select_pickup_address'.tr);
      _tabController!.animateTo(0);
    } else if(_senderNameController.text.isEmpty){
      showCustomSnackBar('enter_sender_name'.tr);
      _tabController!.animateTo(0);
    } else if(_senderPhoneController.text.isEmpty){
      showCustomSnackBar('enter_sender_phone_number'.tr);
      _tabController!.animateTo(0);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
      _tabController!.animateTo(0);
    } else{
      AddressModel pickup = AddressModel(
        address: Get.find<ParcelController>().pickupAddress!.address,
        additionalAddress: Get.find<ParcelController>().pickupAddress!.additionalAddress,
        addressType: Get.find<ParcelController>().pickupAddress!.addressType,
        contactPersonName: _senderNameController.text.trim(),
        contactPersonNumber: numberWithCountryCode,
        latitude: Get.find<ParcelController>().pickupAddress!.latitude,
        longitude: Get.find<ParcelController>().pickupAddress!.longitude,
        method: Get.find<ParcelController>().pickupAddress!.method,
        zoneId: Get.find<ParcelController>().pickupAddress!.zoneId,
        id: Get.find<ParcelController>().pickupAddress!.id,
        zoneIds: Get.find<ParcelController>().pickupAddress!.zoneIds,
        streetNumber: _senderStreetNumberController.text.trim(),
        house: _senderHouseController.text.trim(),
        floor: _senderFloorController.text.trim(),
      );
      Get.find<ParcelController>().setPickupAddress(pickup, true);
      _tabController!.animateTo(1);
    }
  }

}
