
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/parcel_category_model.dart';
import 'package:sixam_mart/data/model/response/parcel_instruction_model.dart';
import 'package:sixam_mart/data/model/response/place_details_model.dart';
import 'package:sixam_mart/data/model/response/video_content_model.dart';
import 'package:sixam_mart/data/model/response/why_choose_model.dart';
import 'package:sixam_mart/data/model/response/zone_response_model.dart';
import 'package:sixam_mart/data/repository/parcel_repo.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_dropdown.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/screens/address/widget/address_widget.dart';

class ParcelController extends GetxController implements GetxService {
  final ParcelRepo parcelRepo;
  ParcelController({required this.parcelRepo});

  List<ParcelCategoryModel>? _parcelCategoryList;
  AddressModel? _pickupAddress;
  AddressModel? _destinationAddress;
  bool? _isPickedUp = true;
  bool _isSender = true;
  bool _isLoading = false;
  double? _distance = -1;
  final List<String> _payerTypes = ['sender', 'receiver'];
  int _payerIndex = 0;
  int _paymentIndex = -1;
  bool _acceptTerms = true;
  double? _extraCharge;
  String? _digitalPaymentName;
  WhyChooseModel? _whyChooseDetails;
  VideoContentModel? _videoContentDetails;
  int _selectedOfflineBankIndex = 0;
  List<Data>? _parcelInstructionList;
  int _instructionSelectedIndex = -1;
  final TextEditingController _customNoteController = TextEditingController();
  String _customNote = '';
  int _selectedIndexNote = -1;
  int? _senderAddressIndex = 0;
  int? _receiverAddressIndex = 0;
  String? _senderCountryCode;
  String? _receiverCountryCode;

  List<ParcelCategoryModel>? get parcelCategoryList => _parcelCategoryList;
  AddressModel? get pickupAddress => _pickupAddress;
  AddressModel? get destinationAddress => _destinationAddress;
  bool? get isPickedUp => _isPickedUp;
  bool get isSender => _isSender;
  bool get isLoading => _isLoading;
  double? get distance => _distance;
  int get payerIndex => _payerIndex;
  List<String> get payerTypes => _payerTypes;
  int get paymentIndex => _paymentIndex;
  bool get acceptTerms => _acceptTerms;
  double? get extraCharge => _extraCharge;
  String? get digitalPaymentName => _digitalPaymentName;
  WhyChooseModel? get whyChooseDetails => _whyChooseDetails;
  VideoContentModel? get videoContentDetails => _videoContentDetails;
  int get selectedOfflineBankIndex => _selectedOfflineBankIndex;
  List<Data>? get parcelInstructionList => _parcelInstructionList;
  int get instructionSelectedIndex => _instructionSelectedIndex;
  TextEditingController get customNoteController => _customNoteController;
  String? get customNote => _customNote;
  int? get selectedIndexNote => _selectedIndexNote;
  int? get senderAddressIndex => _senderAddressIndex;
  int? get receiverAddressIndex => _receiverAddressIndex;
  String? get senderCountryCode => _senderCountryCode;
  String? get receiverCountryCode => _receiverCountryCode;

  void setCountryCode(String code, bool isSender) {
    if(isSender) {
      _senderCountryCode = code;
    } else {
      _receiverCountryCode = code;
    }
  }

  void setSenderAddressIndex(int? index, {bool canUpdate = true}) {
    _senderAddressIndex = index;
    if(canUpdate) {
      update();
    }
  }

  void setReceiverAddressIndex(int? index, {bool canUpdate = true}) {
    _receiverAddressIndex = index;
    if(canUpdate) {
      update();
    }
  }

  void selectOfflineBank(int index){
    _selectedOfflineBankIndex = index;
    update();
  }

  void changeDigitalPaymentName(String name){
    _digitalPaymentName = name;
    update();
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  Future<void> getParcelCategoryList() async {
    Response response = await parcelRepo.getParcelCategory();
    if(response.statusCode == 200) {
      _parcelCategoryList = [];
      response.body.forEach((parcel) => _parcelCategoryList!.add(ParcelCategoryModel.fromJson(parcel)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setPickupAddress(AddressModel? addressModel, bool notify) {
    _pickupAddress = addressModel;
    if(notify) {
      update();
    }
  }

  void setDestinationAddress(AddressModel? addressModel, {bool notify = true}) {
    _destinationAddress = addressModel;
    if(notify) {
      update();
    }
  }

  void setLocationFromPlace(String? placeID, String? address, bool? isPickedUp) async {
    Response response = await parcelRepo.getPlaceDetails(placeID);
    if(response.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(placeDetails.status == 'OK') {
        AddressModel address0 = AddressModel(
          address: address, addressType: 'others', latitude: placeDetails.result!.geometry!.location!.lat.toString(),
          longitude: placeDetails.result!.geometry!.location!.lng.toString(),
          contactPersonName: Get.find<LocationController>().getUserAddress()!.contactPersonName,
          contactPersonNumber: Get.find<LocationController>().getUserAddress()!.contactPersonNumber,
        );
        ZoneResponseModel response0 = await Get.find<LocationController>().getZone(address0.latitude, address0.longitude, false);
        if (response0.isSuccess) {
          bool inZone = false;
          for(int zoneId in Get.find<LocationController>().getUserAddress()!.zoneIds!) {
            if(response0.zoneIds.contains(zoneId)) {
              inZone = true;
              break;
            }
          }
          if(inZone) {
            address0.zoneId =  response0.zoneIds[0];
            address0.zoneIds = [];
            address0.zoneIds!.addAll(response0.zoneIds);
            address0.zoneData = [];
            address0.zoneData!.addAll(response0.zoneData);
            if(isPickedUp!) {
              setPickupAddress(address0, true);
            }else {
              setDestinationAddress(address0);
            }
          }else {
            showCustomSnackBar('your_selected_location_is_from_different_zone_store'.tr);
          }
        } else {
          showCustomSnackBar(response0.message);
        }
      }
    }
  }

  Future<void> getWhyChooseDetails() async {
    Response response = await parcelRepo.getWhyChooseDetails();
    if(response.statusCode == 200) {
      _whyChooseDetails = WhyChooseModel.fromJson(response.body);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getVideoContentDetails() async {
    Response response = await parcelRepo.getVideoContentDetails();
    if(response.statusCode == 200) {
      _videoContentDetails = VideoContentModel.fromJson(response.body);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setIsPickedUp(bool? isPickedUp, bool notify) {
    _isPickedUp = isPickedUp;
    if(notify) {
      update();
    }
  }

  void setIsSender(bool sender, bool notify) {
    _isSender = sender;
    if(notify) {
      update();
    }
  }

  void getDistance(AddressModel pickedUpAddress, AddressModel destinationAddress) async {
    _distance = -1;
    _distance = await Get.find<OrderController>().getDistanceInKM(
      LatLng(double.parse(pickedUpAddress.latitude!), double.parse(pickedUpAddress.longitude!)),
      LatLng(double.parse(destinationAddress.latitude!), double.parse(destinationAddress.longitude!)),
    );

    _extraCharge = Get.find<OrderController>().extraCharge;

    update();
  }

  void setPayerIndex(int index, bool notify) {
    _payerIndex = index;
    if(_payerIndex == 1) {
      _paymentIndex = 0;
    }
    if(notify) {
      update();
    }
  }

  void setPaymentIndex(int index, bool notify) {
    _paymentIndex = index;
    if(notify) {
      update();
    }
  }

  void startLoader(bool isEnable, {bool canUpdate = true}) {
    _isLoading = isEnable;
    if(canUpdate) {
      update();
    }
  }

  Future<void> getParcelInstruction() async {
    _parcelInstructionList = null;
    Response response = await parcelRepo.getParcelInstruction(1);
    if(response.statusCode == 200) {
      _parcelInstructionList = [];
      _parcelInstructionList!.addAll(ParcelInstructionModel.fromJson(response.body).data!);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setInstructionSelectedIndex(int index, {bool notify = true}) {
    _instructionSelectedIndex = index;
    if(notify) {
      update();
    }
  }

  void setCustomNoteController(String customNote, {bool notify = true}) {
    _customNoteController.text = customNote;
    if(notify) {
      update();
    }
  }

  void setCustomNote(String? customNoteText) {
    if (customNoteText != null && customNoteText.isNotEmpty) {
      _customNote = customNoteText;
      update();
    }else {
      _customNote = _customNoteController.text;
    }
    if(customNoteText == null) {
      update();
    }
  }

  void setSelectedIndex(int? index) {
    if(index != null) {
      _selectedIndexNote = index;
    }else{
      _selectedIndexNote = _instructionSelectedIndex;
    }
    if(index == null) {
      update();
    }
  }

  List<DropdownItem<int>> getDropdownAddressList({required BuildContext context, required List<AddressModel>? addressList, required bool isSender}) {
    List<DropdownItem<int>> dropDownAddressList = [];

    if(_isSender) {
      dropDownAddressList.add(DropdownItem<int>(value: 0, child: SizedBox(
        width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth - 50 : context.width - 50,
        child: AddressWidget(
          address: _pickupAddress,
          fromAddress: false, fromCheckout: true,
        ),
      )));
    } else if(!_isSender) {
      dropDownAddressList.add(DropdownItem<int>(value: 0, child: SizedBox(
        width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth - 50 : context.width - 50,
        child: AddressWidget(
          address: _destinationAddress ?? Get.find<LocationController>().getUserAddress(),
          fromAddress: false, fromCheckout: true,
        ),
      )));
    }

    if(addressList != null && Get.find<AuthController>().isLoggedIn()) {
      for(int index=0; index<addressList.length; index++) {

        dropDownAddressList.add(DropdownItem<int>(value: index + 1, child: SizedBox(
          width: context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth-50 : context.width-50,
          child: AddressWidget(
            address: addressList[index],
            fromAddress: false, fromCheckout: true,
          ),
        )));
      }
    }
    return dropDownAddressList;
  }

  List<AddressModel> getAddressList({required List<AddressModel>? addressList, required bool isSender}) {
    List<AddressModel> address = [];

    if(isSender) {
      address.add(_pickupAddress!);
    } else if(!isSender) {
      address.add(_destinationAddress ?? Get.find<LocationController>().getUserAddress()!);
    }

    if(addressList != null && Get.find<AuthController>().isLoggedIn()) {
      for(int index=0; index<addressList.length; index++) {
        address.add(addressList[index]);
      }
    }
    return address;
  }

}