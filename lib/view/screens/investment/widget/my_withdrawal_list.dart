import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/data/model/response/investment_model.dart';
import 'package:dokandar/helper/date_converter.dart';
import 'package:dokandar/helper/price_converter.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/footer_view.dart';
import 'package:dokandar/view/base/no_data_screen.dart';
import 'package:dokandar/view/base/paginated_list_view.dart';
import 'package:dokandar/view/screens/investment/widget/investment_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyWithdrawalList extends StatelessWidget {
  const MyWithdrawalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<InvestmentController>(builder: (investmentController) {
        PaginatedWithdrawalModel? paginatedWithdrawalModel;
        if (investmentController.withdrawalModel != null) {
          paginatedWithdrawalModel = investmentController.withdrawalModel;
        }

        return paginatedWithdrawalModel != null
            ? paginatedWithdrawalModel.withdrawals!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await investmentController.getMyInvestment(1,
                          isUpdate: true);
                    },
                    child: Scrollbar(
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: FooterView(
                            child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: ResponsiveHelper.isDesktop(context)
                                        ? 0
                                        : 100),
                                child: PaginatedListView(
                                  scrollController: scrollController,
                                  onPaginate: (int? offset) {
                                    investmentController.getMyInvestment(
                                      offset!,
                                      isUpdate: true,
                                    );
                                  },
                                  totalSize: paginatedWithdrawalModel.totalSize,
                                  offset: paginatedWithdrawalModel.offset,
                                  itemView: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing:
                                          ResponsiveHelper.isDesktop(context)
                                              ? Dimensions
                                                  .paddingSizeExtremeLarge
                                              : Dimensions.paddingSizeLarge,
                                      mainAxisSpacing:
                                          ResponsiveHelper.isDesktop(context)
                                              ? Dimensions
                                                  .paddingSizeExtremeLarge
                                              : 0,
                                      mainAxisExtent:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 150
                                              : 120,
                                      crossAxisCount:
                                          ResponsiveHelper.isMobile(context)
                                              ? 1
                                              : 2,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: ResponsiveHelper.isDesktop(context)
                                        ? const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeLarge)
                                        : const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                    itemCount: paginatedWithdrawalModel
                                        .withdrawals!.length,
                                    itemBuilder: (context, index) {
                                      WithdrawalModel? withdrawalModel =
                                          paginatedWithdrawalModel!
                                              .withdrawals![index];

                                      return Container(
                                        padding:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.all(
                                                    Dimensions.paddingSizeSmall)
                                                : null,
                                        margin:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.only(
                                                    bottom: Dimensions
                                                        .paddingSizeSmall)
                                                : null,
                                        decoration: ResponsiveHelper.isDesktop(
                                                context)
                                            ? BoxDecoration(
                                                color: Colors.blueGrey.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.05),
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 5))
                                                ],
                                              )
                                            : null,
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Payment Method Details'),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            'Withdrawal Method: ${toBeginningOfSentenceCase(withdrawalModel.methodDetails!.methodType)}',
                                                            style: robotoBold),
                                                        const SizedBox(
                                                            height: 5),
                                                        withdrawalModel
                                                                    .methodDetails!
                                                                    .methodType ==
                                                                'bank'
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'Account Name: ${withdrawalModel.methodDetails!.accountName}',
                                                                      style:
                                                                          robotoBold),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                      'Account Number: ${withdrawalModel.methodDetails!.accountNumber}',
                                                                      style:
                                                                          robotoBold),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                      'Bank Name: ${withdrawalModel.methodDetails!.bankName}',
                                                                      style:
                                                                          robotoBold),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                      'Branch Name: ${withdrawalModel.methodDetails!.branchName}',
                                                                      style:
                                                                          robotoBold),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                      'Routing Number: ${withdrawalModel.methodDetails!.routingNumber}',
                                                                      style:
                                                                          robotoBold),
                                                                ],
                                                              )
                                                            : Text(
                                                                'Phone Number: ${withdrawalModel.methodDetails!.mobileNumber}',
                                                                style:
                                                                    robotoBold)
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Withdrawal Amount: ',
                                                        style: robotoBold),
                                                    Text(
                                                      PriceConverter.convertPrice(
                                                          withdrawalModel
                                                                  .withdrawalAmount
                                                              as double?),
                                                      style: robotoBold.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                Row(
                                                  children: [
                                                    Text('Requested At: ',
                                                        style: robotoBold),
                                                    Text(
                                                      DateConverter
                                                          .dateTimeStringToDateTime(
                                                              withdrawalModel
                                                                      .createdAt
                                                                  as String),
                                                      style: robotoBold.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                withdrawalModel.paidAt != null
                                                    ? Row(
                                                        children: [
                                                          Text('Paid At: ',
                                                              style: robotoBold
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          18)),
                                                          Text(
                                                            DateConverter.dateTimeStringToDateTime(
                                                                withdrawalModel
                                                                        .paidAt
                                                                    as String),
                                                            style: robotoBold
                                                                .copyWith(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ],
                                                      )
                                                    : Text('Pending',
                                                        style:
                                                            robotoBold.copyWith(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 18)),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall),
                                                (index ==
                                                            paginatedWithdrawalModel
                                                                    .withdrawals!
                                                                    .length -
                                                                1 ||
                                                        ResponsiveHelper
                                                            .isDesktop(context))
                                                    ? const SizedBox()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 70),
                                                        child: Divider(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          height: Dimensions
                                                              .paddingSizeLarge,
                                                        ),
                                                      ),
                                              ]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                : NoDataScreen(text: 'No Withdrawal Found'.tr, showFooter: true)
            : InvestmentShimmer(investmentController: investmentController);
      }),
    );
  }
}
