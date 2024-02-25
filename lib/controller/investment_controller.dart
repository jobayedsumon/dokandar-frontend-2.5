import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dokandar/data/api/api_checker.dart';
import 'package:dokandar/helper/route_helper.dart';
import 'package:dokandar/util/app_constants.dart';
import 'package:get/get.dart';
import '../data/model/response/investment_model.dart';
import '../data/repository/investment_repo.dart';
import 'package:universal_html/html.dart' as html;

class InvestmentController extends GetxController implements GetxService {
  final InvestmentRepo investmentRepo;

  InvestmentController({required this.investmentRepo});

  PaginatedInvestmentModel? _flexibleInvestmentModel;
  PaginatedInvestmentModel? _lockedInInvestmentModel;
  PaginatedMyInvestmentModel? _myInvestmentModel;
  PaginatedWithdrawalModel? _withdrawalModel;
  InvestmentWalletModel? _investmentWalletModel;
  InvestmentModel? _investmentModel;
  String? _digitalPaymentName;

  PaginatedInvestmentModel? get flexibleInvestmentModel =>
      _flexibleInvestmentModel;

  PaginatedInvestmentModel? get lockedInInvestmentModel =>
      _lockedInInvestmentModel;

  PaginatedMyInvestmentModel? get myInvestmentModel => _myInvestmentModel;

  PaginatedWithdrawalModel? get withdrawalModel => _withdrawalModel;

  InvestmentModel? get investmentModel => _investmentModel;

  String? get digitalPaymentName => _digitalPaymentName;

  Future<void> getFlexiblePackages(int offset, {bool isUpdate = false}) async {
    if (offset == 1) {
      _flexibleInvestmentModel = null;
      if (isUpdate) {
        update();
      }
    }
    Response response = await investmentRepo.getFlexiblePackageList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _flexibleInvestmentModel =
            PaginatedInvestmentModel.fromJson(response.body);
      } else {
        _flexibleInvestmentModel!.packages!
            .addAll(PaginatedInvestmentModel.fromJson(response.body).packages!);
        _flexibleInvestmentModel!.offset =
            PaginatedInvestmentModel.fromJson(response.body).offset;
        _flexibleInvestmentModel!.totalSize =
            PaginatedInvestmentModel.fromJson(response.body).totalSize;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getLockedInPackages(int offset, {bool isUpdate = false}) async {
    if (offset == 1) {
      _lockedInInvestmentModel = null;
      if (isUpdate) {
        update();
      }
    }
    Response response = await investmentRepo.getLockedInPackageList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _lockedInInvestmentModel =
            PaginatedInvestmentModel.fromJson(response.body);
      } else {
        _lockedInInvestmentModel!.packages!
            .addAll(PaginatedInvestmentModel.fromJson(response.body).packages!);
        _lockedInInvestmentModel!.offset =
            PaginatedInvestmentModel.fromJson(response.body).offset;
        _lockedInInvestmentModel!.totalSize =
            PaginatedInvestmentModel.fromJson(response.body).totalSize;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<InvestmentModel> getInvestmentPackageDetails(int packageId) async {
    Response response = await investmentRepo.getInvestmentPackage(packageId);
    if (response.statusCode == 200) {
      _investmentModel = InvestmentModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return _investmentModel!;
  }

  Future<void> investInPackage(int packageId, String paymentMethod) async {
    update();
    Response response = await investmentRepo.investInPackage(
      {'package_id': packageId, 'payment_method': paymentMethod},
    );
    if (response.statusCode == 200) {
      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if (GetPlatform.isWeb) {
        html.window.open(redirectUrl, "_self");
      } else {
        Get.toNamed(RouteHelper.getPaymentRoute('0', 0, '', 0, false, '',
            investmentPaymentUrl: redirectUrl, guestId: ''));
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void changeDigitalPaymentName(String name, {bool isUpdate = true}) {
    _digitalPaymentName = name;
    if (isUpdate) {
      update();
    }
  }

  Future<void> getMyInvestment(int offset, {bool isUpdate = false}) async {
    if (offset == 1) {
      _myInvestmentModel = null;
      if (isUpdate) {
        update();
      }
    }
    Response response = await investmentRepo.getMyInvestment(offset);
    if (response.statusCode == 200) {
      var investments = response.body['investments'];
      var withdrawals = response.body['withdrawals'];
      var investmentWallets = response.body['investment_wallet'];

      if (offset == 1) {
        _myInvestmentModel = PaginatedMyInvestmentModel.fromJson(investments);
        _withdrawalModel = PaginatedWithdrawalModel.fromJson(withdrawals);
        _investmentWalletModel =
            InvestmentWalletModel.fromJson(investmentWallets);
      } else {
        _myInvestmentModel!.investments!.addAll(
            PaginatedMyInvestmentModel.fromJson(investments).investments!);
        _myInvestmentModel!.offset =
            PaginatedMyInvestmentModel.fromJson(investments).offset;
        _myInvestmentModel!.totalSize =
            PaginatedMyInvestmentModel.fromJson(investments).totalSize;

        _withdrawalModel!.withdrawals!.addAll(
            PaginatedWithdrawalModel.fromJson(withdrawals).withdrawals!);
        _withdrawalModel!.offset =
            PaginatedWithdrawalModel.fromJson(withdrawals).offset;
        _withdrawalModel!.totalSize =
            PaginatedWithdrawalModel.fromJson(withdrawals).totalSize;

        _investmentWalletModel =
            InvestmentWalletModel.fromJson(investmentWallets);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }
}
