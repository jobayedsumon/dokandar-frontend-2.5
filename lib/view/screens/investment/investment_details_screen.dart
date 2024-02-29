import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/helper/price_converter.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_app_bar.dart';
import 'package:dokandar/view/base/custom_button.dart';
import 'package:dokandar/view/base/menu_drawer.dart';
import 'package:dokandar/view/screens/investment/widget/investment_payment_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/api_client.dart';
import '../../../data/model/response/investment_model.dart';
import '../../../data/repository/investment_repo.dart';
import '../../base/custom_image.dart';

class InvestmentDetailsScreen extends StatefulWidget {
  final InvestmentModel? investmentModel;
  final int? packageId;

  const InvestmentDetailsScreen(
      {Key? key, required this.investmentModel, required this.packageId})
      : super(key: key);

  @override
  InvestmentDetailsScreenState createState() => InvestmentDetailsScreenState();
}

class InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.put(InvestmentController(
        investmentRepo: InvestmentRepo(
            apiClient: Get.find<ApiClient>(),
            sharedPreferences: Get.find<SharedPreferences>())));
    Get.find<InvestmentController>()
        .getInvestmentPackageDetails(widget.packageId ?? 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Investment Package Details'.tr,
          onBackPressed: () {
            Get.back();
          }),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child:
            GetBuilder<InvestmentController>(builder: (investmentController) {
          InvestmentModel? investmentModel =
              investmentController.investmentModel;
          return investmentModel != null
              ? CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            color: const Color(0xFF171A29),
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeLarge),
                            alignment: Alignment.center,
                            child: Center(
                              child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall),
                                  child: Row(children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        child: CustomImage(
                                          fit: BoxFit.cover,
                                          height: 240,
                                          width: 590,
                                          image: investmentModel.image!,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeLarge),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  child: Column(children: [
                                    Center(
                                      child: SizedBox(
                                        width: Dimensions.webMaxWidth,
                                        child: Align(
                                          alignment: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? Alignment.centerLeft
                                              : Alignment.center,
                                          child: Container(
                                            width: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? 300
                                                : Dimensions.webMaxWidth,
                                            color: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? Colors.transparent
                                                : Theme.of(context).cardColor,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: Dimensions
                                                      .paddingSizeLarge),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        investmentModel.name!,
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeOverLarge,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeSmall),
                                                      Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                investmentModel
                                                                        .amount!
                                                                    as double?),
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  ListTileWidget(
                                                      title: 'Return',
                                                      value:
                                                          '${investmentModel.monthlyInterestRate!}%',
                                                      icon: Icons.calculate),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  ListTileWidget(
                                                      title: 'Project Type',
                                                      value: investmentModel
                                                                  .type ==
                                                              'flexible'
                                                          ? 'Flexible'
                                                          : 'Locked In',
                                                      icon: Icons
                                                          .settings_applications),
                                                  investmentModel.type ==
                                                          'locked-in'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: ListTileWidget(
                                                              title: 'Duration',
                                                              value: investmentModel
                                                                  .durationInMonths
                                                                  .toString(),
                                                              icon: Icons
                                                                  .calendar_today),
                                                        )
                                                      : Container(),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Daily Profit',
                                              style: TextStyle(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),
                                            Text(
                                              PriceConverter.convertPrice(
                                                  investmentModel.dailyProfit!),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Monthly Profit',
                                              style: TextStyle(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),
                                            Text(
                                              PriceConverter.convertPrice(
                                                  investmentModel
                                                      .monthlyProfit!),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'About This Project',
                                        style: TextStyle(
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Text(investmentModel.about ?? ''),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraLarge),
                                      investmentModel.isInvestedByCurrentUser
                                          ? const Text(
                                              'Already Invested',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            )
                                          : CustomButton(
                                              color: Colors.green,
                                              buttonText: 'Invest Now',
                                              width: 200,
                                              onPressed: () {
                                                Get.dialog(
                                                  Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: SizedBox(
                                                      width: 500,
                                                      child: SingleChildScrollView(
                                                          child: InvestmentPaymentDialogue(
                                                              packageId:
                                                                  investmentModel
                                                                      .id)),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraLarge),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : const SizedBox();
        }),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          ],
        )
      ],
    );
  }
}
