import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/data/model/response/investment_model.dart';
import 'package:dokandar/helper/date_converter.dart';
import 'package:dokandar/helper/price_converter.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_image.dart';
import 'package:dokandar/view/base/footer_view.dart';
import 'package:dokandar/view/base/no_data_screen.dart';
import 'package:dokandar/view/base/paginated_list_view.dart';
import 'package:dokandar/view/screens/investment/widget/investment_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../my_investment_details_screen.dart';

class MyInvestmentView extends StatelessWidget {
  const MyInvestmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<InvestmentController>(builder: (investmentController) {
        PaginatedMyInvestmentModel? paginatedMyInvestmentModel;
        if (investmentController.myInvestmentModel != null) {
          paginatedMyInvestmentModel = investmentController.myInvestmentModel;
        }

        return paginatedMyInvestmentModel != null
            ? paginatedMyInvestmentModel.investments!.isNotEmpty
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
                                        isUpdate: true);
                                  },
                                  totalSize:
                                      paginatedMyInvestmentModel.totalSize,
                                  offset: paginatedMyInvestmentModel.offset,
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
                                      // childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.5,
                                      mainAxisExtent:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 180
                                              : 160,
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
                                    itemCount: paginatedMyInvestmentModel
                                        .investments!.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                            RouteHelper
                                                .getMyInvestmentDetailsRoute(
                                                    paginatedMyInvestmentModel!
                                                        .investments![index]
                                                        .id),
                                            arguments:
                                                MyInvestmentDetailsScreen(
                                              packageId:
                                                  paginatedMyInvestmentModel
                                                      .investments![index].id,
                                              myInvestmentModel:
                                                  paginatedMyInvestmentModel
                                                      .investments![index],
                                            ),
                                          );
                                        },
                                        hoverColor: Colors.transparent,
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          margin: const EdgeInsets.only(
                                              bottom:
                                                  Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.05),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5))
                                            ],
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(children: [
                                                  Stack(children: [
                                                    Container(
                                                      height: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 100
                                                          : 60,
                                                      width: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 200
                                                          : 100,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusSmall),
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.2),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusSmall),
                                                        child: CustomImage(
                                                          image:
                                                              '${paginatedMyInvestmentModel!.investments![index].package!.image != null ? paginatedMyInvestmentModel.investments![index].package!.image : ''}',
                                                          height: ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? 100
                                                              : 60,
                                                          width: ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? 200
                                                              : 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeSmall),
                                                  Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              paginatedMyInvestmentModel
                                                                  .investments![
                                                                      index]
                                                                  .package!
                                                                  .name!,
                                                              style: robotoRegular.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge),
                                                            ),
                                                            const SizedBox(
                                                                width: Dimensions
                                                                    .paddingSizeExtraSmall),
                                                          ]),
                                                          const SizedBox(
                                                              height: Dimensions
                                                                  .paddingSizeSmall),
                                                          ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      bottom: Dimensions
                                                                          .paddingSizeSmall),
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            Dimensions
                                                                                .paddingSizeSmall,
                                                                        vertical:
                                                                            Dimensions.paddingSizeExtraSmall),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimensions.radiusSmall),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child: Text(
                                                                        PriceConverter.convertPrice(paginatedMyInvestmentModel
                                                                            .investments![index]
                                                                            .package!
                                                                            .amount as double?),
                                                                        style: robotoMedium.copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeExtraSmall,
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        )),
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .calculate,
                                                                  size: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                              const SizedBox(
                                                                  width: Dimensions
                                                                      .paddingSizeSmall),
                                                              Text(
                                                                '${paginatedMyInvestmentModel.investments![index].package!.yearlyInterestRate!}%',
                                                                style: robotoRegular.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: Dimensions
                                                                  .paddingSizeSmall),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.money,
                                                                  size: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                              const SizedBox(
                                                                  width: Dimensions
                                                                      .paddingSizeSmall),
                                                              Text(
                                                                  '${PriceConverter.convertPrice(paginatedMyInvestmentModel.investments![index].profitEarned)} Profit Earned',
                                                                  style: robotoMedium
                                                                      .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    color: Colors
                                                                        .green,
                                                                  )),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: Dimensions
                                                                  .paddingSizeSmall),
                                                          paginatedMyInvestmentModel
                                                                      .investments![
                                                                          index]
                                                                      .package!
                                                                      .type ==
                                                                  'flexible'
                                                              ? paginatedMyInvestmentModel
                                                                          .investments![
                                                                              index]
                                                                          .redeemedAt ==
                                                                      null
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .timelapse,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                        const SizedBox(
                                                                            width:
                                                                                Dimensions.paddingSizeSmall),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            'Redeemed At: ${DateConverter.dateTimeStringToDateTime(paginatedMyInvestmentModel.investments![index].redeemedAt!)}',
                                                                            style:
                                                                                robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                              : Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                        size:
                                                                            15,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeSmall),
                                                                    Text(
                                                                      '${paginatedMyInvestmentModel.investments![index].package!.durationInMonths!} Months',
                                                                      style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ]),
                                                  ),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeSmall),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        !ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .paddingSizeSmall,
                                                                    vertical:
                                                                        Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .radiusSmall),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.1),
                                                                ),
                                                                child: Text(
                                                                    PriceConverter.convertPrice(paginatedMyInvestmentModel
                                                                            .investments![
                                                                                index]
                                                                            .package!
                                                                            .amount
                                                                        as double?),
                                                                    style: robotoMedium
                                                                        .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeExtraSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    )),
                                                              )
                                                            : const SizedBox(),
                                                        const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeSmall)
                                                      ]),
                                                ]),
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
                : NoDataScreen(
                    text: 'No Investment Project Found'.tr, showFooter: true)
            : InvestmentShimmer(investmentController: investmentController);
      }),
    );
  }
}
