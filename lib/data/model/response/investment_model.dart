class PaginatedInvestmentModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<InvestmentModel>? packages;

  PaginatedInvestmentModel({this.totalSize, this.limit, this.offset, this.packages});

  PaginatedInvestmentModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['packages'] != null) {
      packages = [];
      json['packages'].forEach((v) {
        packages!.add(InvestmentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class InvestmentModel {

  int? id;
  String? name;
  String? type;
  int? amount;
  double? monthlyInterestRate;
  int? durationInMonths;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? about;
  double? monthlyProfit;
  double? dailyProfit;

  InvestmentModel({
    this.id,
    this.name,
    this.type,
    this.amount,
    this.monthlyInterestRate,
    this.durationInMonths,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.about,
    this.monthlyProfit,
    this.dailyProfit,
});

  InvestmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    amount = json['amount'];
    monthlyInterestRate = json['monthly_interest_rate'];
    durationInMonths = json['duration_in_months'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    about = json['about'];
    monthlyProfit = json['monthly_profit'];
    dailyProfit = json['daily_profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['amount'] = amount;
    data['monthly_interest_rate'] = monthlyInterestRate;
    data['duration_in_months'] = durationInMonths;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['about'] = about;
    data['monthly_profit'] = monthlyProfit;
    data['daily_profit'] = dailyProfit;
    return data;
  }
}
