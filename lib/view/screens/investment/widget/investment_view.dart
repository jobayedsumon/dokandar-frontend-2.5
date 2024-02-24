import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/data/model/response/investment_model.dart';
import 'package:dokandar/helper/date_converter.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/helper/route_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_image.dart';
import 'package:dokandar/view/base/footer_view.dart';
import 'package:dokandar/view/base/no_data_screen.dart';
import 'package:dokandar/view/base/paginated_list_view.dart';
import 'package:dokandar/view/screens/investment/investment_details_screen.dart';
import 'package:dokandar/view/screens/investment/widget/investment_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvestmentView extends StatelessWidget {
  final String type;
  const InvestmentView({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<InvestmentController>(builder: (investmentController) {
        PaginatedInvestmentModel? paginatedInvestmentModel;
        if(investmentController.flexibleInvestmentModel != null && investmentController.lockedInInvestmentModel != null) {
          paginatedInvestmentModel = type == 'flexible' ? investmentController.flexibleInvestmentModel : investmentController.lockedInInvestmentModel;
        }

        return paginatedInvestmentModel != null ? paginatedInvestmentModel.packages!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            if(type == 'flexible') {
              await investmentController.getFlexiblePackages(1, isUpdate: true);
            }else {
              await investmentController.getLockedInPackages(1, isUpdate: true);
            }
          },
          child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveHelper.isDesktop(context) ? 0 : 100),
                  child: PaginatedListView(
                    scrollController: scrollController,
                    onPaginate: (int? offset) {
                      if(type == 'flexible') {
                        investmentController.getFlexiblePackages(offset!, isUpdate: true);
                      }else {
                        investmentController.getLockedInPackages(offset!, isUpdate: true);
                      }
                    },
                    totalSize: type == 'flexible' ? investmentController.flexibleInvestmentModel!.totalSize : investmentController.lockedInInvestmentModel!.totalSize,
                    offset: type == 'flexible' ? investmentController.flexibleInvestmentModel!.offset : investmentController.lockedInInvestmentModel!.offset,
                    itemView: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtremeLarge : Dimensions.paddingSizeLarge,
                        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtremeLarge : 0,
                        // childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.5,
                        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 130 : 100,
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemCount: paginatedInvestmentModel.packages!.length,
                      itemBuilder: (context, index) {

                        return InkWell(
                          // onTap: () {
                          //   Get.toNamed(
                          //     RouteHelper.getOrderDetailsRoute(paginatedInvestmentModel!.packages![index].id),
                          //     // arguments: InvestmentDetailsScreen(
                          //     //   packageId: paginatedInvestmentModel.packages![index].id,
                          //     //   investmentModel: paginatedInvestmentModel.packages![index],
                          //     // ),
                          //   );
                          // },
                          hoverColor: Colors.transparent,
                          child: Container(
                            padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
                            margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall) : null,
                            decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                            ) : null,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Row(children: [

                                Stack(children: [
                                  Container(
                                    height: ResponsiveHelper.isDesktop(context) ? 80 : 60, width: ResponsiveHelper.isDesktop(context) ? 80 : 60, alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      child: CustomImage(
                                        image: '${paginatedInvestmentModel!.packages![index].image != null ? paginatedInvestmentModel.packages![index].image : ''}',
                                        height: ResponsiveHelper.isDesktop(context) ? 80 : 60,
                                        width: ResponsiveHelper.isDesktop(context) ? 80 : 60, fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      Text(
                                        'Package ID:',
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                      Text('#${paginatedInvestmentModel.packages![index].id}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    ResponsiveHelper.isDesktop(context) ? Padding(
                                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        ),
                                        child: Text(paginatedInvestmentModel.packages![index].status != null ? 'Active' : 'Inactive', style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                        )),
                                      ),
                                    ) : const SizedBox(),

                                    Text(
                                      DateConverter.dateTimeStringToDateTime(paginatedInvestmentModel.packages![index].createdAt!),
                                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  !ResponsiveHelper.isDesktop(context) ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    ),
                                    child: Text(paginatedInvestmentModel.packages![index].status != null ? 'Active': 'Inactive', style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                    )),
                                  ) : const SizedBox(),
                                  const SizedBox(height: Dimensions.paddingSizeSmall)
                                ]),

                              ]),

                              (index == paginatedInvestmentModel.packages!.length-1 || ResponsiveHelper.isDesktop(context)) ? const SizedBox() : Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: Divider(
                                  color: Theme.of(context).disabledColor, height: Dimensions.paddingSizeLarge,
                                ),
                              ),

                            ]),
                          ),
                        );
                      },),
                  ),
                ),
              ),
            ),
          )),
        ) : NoDataScreen(text: 'No Investment Project Found'.tr, showFooter: true) : InvestmentShimmer(investmentController: investmentController);
      }),
    );
  }
}
