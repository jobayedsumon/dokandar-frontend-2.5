class PaginatedInvestmentModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<InvestmentModel>? packages;

  PaginatedInvestmentModel(
      {this.totalSize, this.limit, this.offset, this.packages});

  PaginatedInvestmentModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
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

class PaginatedMyInvestmentModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<MyInvestmentModel>? investments;

  PaginatedMyInvestmentModel(
      {this.totalSize, this.limit, this.offset, this.investments});

  PaginatedMyInvestmentModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
    if (json['investments'] != null) {
      investments = [];
      json['investments'].forEach((v) {
        investments!.add(MyInvestmentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (investments != null) {
      data['investments'] = investments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyInvestmentModel {
  int? id;
  int? customerId;
  int? investmentId;
  String? redeemedAt;
  String? createdAt;
  String? updatedAt;
  double? profitEarned;
  InvestmentModel? package;

  MyInvestmentModel({
    this.id,
    this.customerId,
    this.investmentId,
    this.redeemedAt,
    this.createdAt,
    this.updatedAt,
    this.profitEarned,
    this.package,
  });

  MyInvestmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    investmentId = json['investment_id'];
    redeemedAt = json['redeemed_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profitEarned = json['profit_earned'];
    package = json['package'] != null
        ? InvestmentModel.fromJson(json['package'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['investment_id'] = investmentId;
    data['redeemed_at'] = redeemedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profit_earned'] = profitEarned;
    if (package != null) {
      data['package'] = package!.toJson();
    }
    return data;
  }
}

class InvestmentWalletModel {
  double? profit;
  double? redeemed;
  double? withdrawal;
  double? transfer;
  double? balance;

  InvestmentWalletModel({
    this.profit,
    this.redeemed,
    this.withdrawal,
    this.transfer,
    this.balance,
  });

  InvestmentWalletModel.fromJson(Map<String, dynamic> json) {
    profit = json['profit'];
    redeemed = json['redeemed'];
    withdrawal = json['withdrawal'];
    transfer = json['transfer'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profit'] = profit;
    data['redeemed'] = redeemed;
    data['withdrawal'] = withdrawal;
    data['transfer'] = transfer;
    data['balance'] = balance;
    return data;
  }
}

class PaginatedWithdrawalModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<WithdrawalModel>? withdrawals;

  PaginatedWithdrawalModel(
      {this.totalSize, this.limit, this.offset, this.withdrawals});

  PaginatedWithdrawalModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
    if (json['withdrawals'] != null) {
      withdrawals = [];
      json['withdrawals'].forEach((v) {
        withdrawals!.add(WithdrawalModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (withdrawals != null) {
      data['withdrawals'] = withdrawals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WithdrawalModel {
  int? id;
  int? customerId;
  int? withdrawalAmount;
  String? withdrawalMethodDetails;
  String? paidAt;
  String? createdAt;
  String? updatedAt;
  MethodDetails? methodDetails;

  WithdrawalModel({
    this.id,
    this.customerId,
    this.withdrawalAmount,
    this.withdrawalMethodDetails,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
    this.methodDetails,
  });

  WithdrawalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    withdrawalAmount = json['withdrawal_amount'];
    withdrawalMethodDetails = json['withdrawal_method_details'];
    paidAt = json['paid_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    methodDetails = json['method_details'] != null
        ? MethodDetails.fromJson(json['method_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['withdrawal_amount'] = withdrawalAmount;
    data['withdrawal_method_details'] = withdrawalMethodDetails;
    data['paid_at'] = paidAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (methodDetails != null) {
      data['method_details'] = methodDetails!.toJson();
    }
    return data;
  }
}

class MethodDetails {
  String? methodType;
  String? mobileNumber;
  String? bankName;
  String? branchName;
  String? accountName;
  String? accountNumber;
  String? routingNumber;

  MethodDetails({
    this.methodType,
    this.mobileNumber,
    this.bankName,
    this.branchName,
    this.accountName,
    this.accountNumber,
    this.routingNumber,
  });

  MethodDetails.fromJson(Map<String, dynamic> json) {
    methodType = json['method_type'];
    mobileNumber = json['mobile_number'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    routingNumber = json['routing_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method_type'] = methodType;
    data['mobile_number'] = mobileNumber;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['routing_number'] = routingNumber;
    return data;
  }
}
