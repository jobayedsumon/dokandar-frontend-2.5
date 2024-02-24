import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dokandar/data/api/api_checker.dart';
import 'package:dokandar/helper/route_helper.dart';
import 'package:dokandar/util/app_constants.dart';
import 'package:get/get.dart';
import '../data/model/response/investment_model.dart';
import '../data/repository/investment_repo.dart';

class InvestmentController extends GetxController implements GetxService {
  final InvestmentRepo investmentRepo;
  InvestmentController({required this.investmentRepo});

  PaginatedInvestmentModel? _flexibleInvestmentModel;
  PaginatedInvestmentModel? _lockedInInvestmentModel;

  PaginatedInvestmentModel? get flexibleInvestmentModel => _flexibleInvestmentModel;
  PaginatedInvestmentModel? get lockedInInvestmentModel => _lockedInInvestmentModel;


  Future<void> getFlexiblePackages(int offset, {bool isUpdate = false}) async {
    if(offset == 1) {
      _flexibleInvestmentModel = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await investmentRepo.getFlexiblePackageList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _flexibleInvestmentModel = PaginatedInvestmentModel.fromJson(response.body);
      }else {
        _flexibleInvestmentModel!.packages!.addAll(PaginatedInvestmentModel.fromJson(response.body).packages!);
        _flexibleInvestmentModel!.offset = PaginatedInvestmentModel.fromJson(response.body).offset;
        _flexibleInvestmentModel!.totalSize = PaginatedInvestmentModel.fromJson(response.body).totalSize;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getLockedInPackages(int offset, {bool isUpdate = false}) async {
    if(offset == 1) {
      _lockedInInvestmentModel = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await investmentRepo.getLockedInPackageList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _lockedInInvestmentModel = PaginatedInvestmentModel.fromJson(response.body);
      }else {
        _lockedInInvestmentModel!.packages!.addAll(PaginatedInvestmentModel.fromJson(response.body).packages!);
        _lockedInInvestmentModel!.offset = PaginatedInvestmentModel.fromJson(response.body).offset;
        _lockedInInvestmentModel!.totalSize = PaginatedInvestmentModel.fromJson(response.body).totalSize;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void paymentRedirect({required String url, required bool canRedirect, required String? contactNumber,
    required Function onClose, required final String? addFundUrl, required final String orderID}) {

    if(canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl);
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);
      if (isSuccess || isFailed || isCancel) {
        canRedirect = false;
        onClose();
      }

      if((addFundUrl == '' && addFundUrl!.isEmpty)){
        if (isSuccess) {
          Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, contactNumber));
        } else if (isFailed || isCancel) {
          Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, contactNumber));
        }
      } else{
        if(isSuccess || isFailed || isCancel) {
          if(Get.currentRoute.contains(RouteHelper.payment)) {
            Get.back();
          }
          Get.back();
          Get.toNamed(RouteHelper.getWalletRoute(true, fundStatus: isSuccess ? 'success' : isFailed ? 'fail' : 'cancel', token: UniqueKey().toString()));
        }
      }

    }
  }

}