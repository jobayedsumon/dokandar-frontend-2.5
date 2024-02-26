import 'package:dokandar/data/api/api_client.dart';
import 'package:dokandar/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  InvestmentRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getFlexiblePackageList(int offset) async {
    return await apiClient.getData(
        '${AppConstants.investmentPackagesUri}?type=flexible&offset=$offset&limit=10');
  }

  Future<Response> getLockedInPackageList(int offset) async {
    return await apiClient.getData(
        '${AppConstants.investmentPackagesUri}?type=locked-in&offset=$offset&limit=10');
  }

  Future<Response> getInvestmentPackage(int id) async {
    return await apiClient
        .getData('${AppConstants.investmentPackageViewUri}/$id');
  }

  Future<Response> investInPackage(data) async {
    return await apiClient.postData(AppConstants.investmentInvestUri, data);
  }

  Future<Response> getMyInvestment(int offset) async {
    return await apiClient
        .getData('${AppConstants.myInvestmentUri}?offset=$offset&limit=10');
  }

  Future<Response> getMyInvestmentPackage(int id) async {
    return await apiClient.getData('${AppConstants.myInvestmentViewUri}/$id');
  }

  Future<Response> redeemInvestment(int id) async {
    return await apiClient.postData(AppConstants.redeemInvestmentUri, {
      'investment_id': id,
    });
  }
}
