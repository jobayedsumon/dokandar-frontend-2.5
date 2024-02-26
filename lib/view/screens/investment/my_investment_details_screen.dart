import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/helper/date_converter.dart';
import 'package:dokandar/helper/price_converter.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_app_bar.dart';
import 'package:dokandar/view/base/custom_button.dart';
import 'package:dokandar/view/base/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/api_client.dart';
import '../../../data/model/response/investment_model.dart';
import '../../../data/repository/investment_repo.dart';
import '../../base/custom_image.dart';

class MyInvestmentDetailsScreen extends StatefulWidget {
  final MyInvestmentModel? myInvestmentModel;
  final int? packageId;

  const MyInvestmentDetailsScreen(
      {Key? key, required this.myInvestmentModel, required this.packageId})
      : super(key: key);

  @override
  MyInvestmentDetailsScreenState createState() =>
      MyInvestmentDetailsScreenState();
}

class MyInvestmentDetailsScreenState extends State<MyInvestmentDetailsScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.put(InvestmentController(
        investmentRepo: InvestmentRepo(
            apiClient: Get.find<ApiClient>(),
            sharedPreferences: Get.find<SharedPreferences>())));
    Get.find<InvestmentController>()
        .getMyInvestmentPackageDetails(widget.packageId ?? 0);
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
          MyInvestmentModel? myInvestmentModel =
              investmentController.myInvestmentDetailsModel;
          return myInvestmentModel != null
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
                                          image:
                                              myInvestmentModel.package!.image!,
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
                          Container(
                            color: Colors.transparent,
                            child: Column(children: [
                              Center(
                                child: SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: Align(
                                    alignment:
                                        ResponsiveHelper.isDesktop(context)
                                            ? Alignment.centerLeft
                                            : Alignment.center,
                                    child: Container(
                                      width: ResponsiveHelper.isDesktop(context)
                                          ? 300
                                          : Dimensions.webMaxWidth,
                                      color: ResponsiveHelper.isDesktop(context)
                                          ? Colors.transparent
                                          : Theme.of(context).cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: Dimensions.paddingSizeLarge),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  myInvestmentModel
                                                      .package!.name!,
                                                  style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeOverLarge,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                Text(
                                                  PriceConverter.convertPrice(
                                                      myInvestmentModel.package!
                                                          .amount! as double?),
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
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
                                                    '${myInvestmentModel.package!.monthlyInterestRate!}%',
                                                icon: Icons.calculate),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),
                                            ListTileWidget(
                                                title: 'Project Type',
                                                value: myInvestmentModel
                                                            .package!.type ==
                                                        'flexible'
                                                    ? 'Flexible'
                                                    : 'Locked In',
                                                icon: Icons
                                                    .settings_applications),
                                            myInvestmentModel.package!.type ==
                                                    'locked-in'
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: ListTileWidget(
                                                        title: 'Duration',
                                                        value: myInvestmentModel
                                                            .package!
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
                            child: Container(
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
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Text(
                                        PriceConverter.convertPrice(
                                            myInvestmentModel
                                                .package!.dailyProfit!),
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
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Text(
                                        PriceConverter.convertPrice(
                                            myInvestmentModel
                                                .package!.monthlyProfit!),
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
                                        'Total Profit Earned',
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Text(
                                          PriceConverter.convertPrice(
                                              myInvestmentModel.profitEarned!),
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          myInvestmentModel.redeemedAt != null
                              ? SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Redeemed At',
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Text(
                                          DateConverter
                                              .dateTimeStringToDateTime(
                                                  myInvestmentModel
                                                      .redeemedAt!),
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ],
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About This Project',
                                  style: TextStyle(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                Text(myInvestmentModel.package!.about!),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge),
                                myInvestmentModel.redeemedAt == null &&
                                        myInvestmentModel.package!.type ==
                                            'flexible'
                                    ? CustomButton(
                                        buttonText: 'Redeem Now'.tr,
                                        width: 200,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Redeem Now'),
                                                content: const Text(
                                                    'Are you sure you want to redeem this investment?'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      CustomButton(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        width: 50,
                                                        buttonText: 'No',
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                      ),
                                                      CustomButton(
                                                        width: 50,
                                                        buttonText: 'Yes',
                                                        onPressed: () {
                                                          investmentController
                                                              .redeemInvestment(
                                                                  myInvestmentModel
                                                                      .id!);
                                                          Get.back();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : Container(),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraLarge),
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
