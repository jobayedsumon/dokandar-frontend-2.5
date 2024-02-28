import 'package:dokandar/controller/auth_controller.dart';
import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/data/model/response/investment_model.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_app_bar.dart';
import 'package:dokandar/view/base/custom_button.dart';
import 'package:dokandar/view/base/menu_drawer.dart';
import 'package:dokandar/view/screens/investment/widget/my_investment_view.dart';
import 'package:dokandar/view/screens/investment/widget/my_withdrawal_list.dart';
import 'package:dokandar/view/screens/investment/widget/withdraw_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repository/investment_repo.dart';
import '../../../helper/price_converter.dart';

class MyInvestmentScreen extends StatefulWidget {
  const MyInvestmentScreen({Key? key}) : super(key: key);

  @override
  MyInvestmentScreenState createState() => MyInvestmentScreenState();
}

class MyInvestmentScreenState extends State<MyInvestmentScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.put(InvestmentController(
          investmentRepo: InvestmentRepo(
              apiClient: Get.find(), sharedPreferences: Get.find())));
      Get.find<InvestmentController>().getMyInvestment(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(
          title: 'My Investment',
          backButton: ResponsiveHelper.isDesktop(context)),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<InvestmentController>(
        builder: (investmentController) {
          InvestmentWalletModel? investmentWallet =
              investmentController.investmentWalletModel;
          return _isLoggedIn
              ? Column(children: [
                  Container(
                    color: ResponsiveHelper.isDesktop(context)
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Column(children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            Text('My Investment',
                                style: robotoBold.copyWith(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor)),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: investmentWallet != null
                                        ? Column(
                                            children: [
                                              Text(
                                                  'Total Profit: ${PriceConverter.convertPrice(investmentWallet.profit)}',
                                                  style: robotoBold.copyWith(
                                                      fontSize: 16,
                                                      color: Colors.green)),
                                              const SizedBox(height: 5),
                                              Text(
                                                  'Total Redeemed: ${PriceConverter.convertPrice(investmentWallet.redeemed)}',
                                                  style: robotoBold.copyWith(
                                                      fontSize: 16,
                                                      color: Colors.green)),
                                              const SizedBox(height: 5),
                                              Text(
                                                  'Total Withdrawal: ${PriceConverter.convertPrice(investmentWallet.withdrawal)}',
                                                  style: robotoBold.copyWith(
                                                      fontSize: 16,
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              const SizedBox(height: 5),
                                              Text(
                                                  'Total Transferred: ${PriceConverter.convertPrice(investmentWallet.transfer)}',
                                                  style: robotoBold.copyWith(
                                                      fontSize: 16,
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              const SizedBox(height: 5),
                                              Text(
                                                  'Current Balance: ${PriceConverter.convertPrice(investmentWallet.balance)}',
                                                  style: robotoBold.copyWith(
                                                      fontSize: 18,
                                                      color: Colors.green)),
                                            ],
                                          )
                                        : const SizedBox()),
                                //Send to wallet and withdraw buttons
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    width: ResponsiveHelper.isDesktop(context)
                                        ? 200
                                        : 150,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Theme.of(
                                                                  context)
                                                              .cardColor
                                                              .withOpacity(0.5),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: const Icon(
                                                            Icons.clear),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  GetBuilder<
                                                          InvestmentController>(
                                                      builder:
                                                          (investmentController) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                      ),
                                                      width: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? context.width * 0.3
                                                          : context.width * 0.8,
                                                      height: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? context.height * 0.4
                                                          : context.height *
                                                              0.4,
                                                      padding: const EdgeInsets
                                                          .all(Dimensions
                                                              .paddingSizeLarge),
                                                      child: Column(children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const SizedBox(
                                                                      height: Dimensions
                                                                          .paddingSizeLarge),
                                                                  Center(
                                                                    child: Text(
                                                                        'Transfer to D-Wallet'
                                                                            .tr,
                                                                        style: robotoBold.copyWith(
                                                                            fontSize:
                                                                                22,
                                                                            color:
                                                                                Theme.of(context).primaryColor)),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: Dimensions
                                                                          .paddingSizeSmall),
                                                                  Text(
                                                                      'You can transfer your investment available balance to your D-Wallet'
                                                                          .tr,
                                                                      style: robotoRegular.copyWith(
                                                                          fontSize: Dimensions
                                                                              .fontSizeSmall),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  const SizedBox(
                                                                      height: Dimensions
                                                                          .paddingSizeLarge),
                                                                  TextFormField(
                                                                    controller:
                                                                        investmentController
                                                                            .transferAmountController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Amount'
                                                                              .tr,
                                                                      hintText:
                                                                          'Enter amount'
                                                                              .tr,
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: Dimensions
                                                                .paddingSizeLarge),
                                                        CustomButton(
                                                          width: 200,
                                                          buttonText:
                                                              'Transfer'.tr,
                                                          onPressed: () {
                                                            if (investmentController
                                                                .transferAmountController
                                                                .text
                                                                .isEmpty) {
                                                              Get.snackbar(
                                                                  'Error'.tr,
                                                                  'Enter transfer amount'
                                                                      .tr,
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .BOTTOM);
                                                              return;
                                                            }
                                                            investmentController
                                                                .transferToDWallet();
                                                          },
                                                        ),
                                                      ]),
                                                    );
                                                  })
                                                ]);
                                          });
                                    },
                                    fontSize: 16,
                                    buttonText: 'Transfer to D-Wallet'),
                                const SizedBox(width: 10),
                                CustomButton(
                                  buttonText: 'Withdraw Request',
                                  fontSize: 16,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const WithdrawDialogue();
                                        });
                                  },
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 200
                                      : 150,
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                      Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Align(
                            alignment: ResponsiveHelper.isDesktop(context)
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: Container(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 300
                                  : Dimensions.webMaxWidth,
                              color: ResponsiveHelper.isDesktop(context)
                                  ? Colors.transparent
                                  : Theme.of(context).cardColor,
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: Theme.of(context).primaryColor,
                                indicatorWeight: 3,
                                labelColor: Theme.of(context).primaryColor,
                                unselectedLabelColor:
                                    Theme.of(context).disabledColor,
                                unselectedLabelStyle: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: Dimensions.fontSizeSmall),
                                labelStyle: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).primaryColor),
                                tabs: [
                                  Tab(text: 'My Investments'.tr),
                                  Tab(text: 'My Withdrawals'.tr),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: const [
                      MyInvestmentView(),
                      MyWithdrawalList(),
                    ],
                  )),
                ])
              : Container();
        },
      ),
    );
  }
}
