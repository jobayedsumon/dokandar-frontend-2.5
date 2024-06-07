import 'package:dokandar/controller/auth_controller.dart';
import 'package:dokandar/controller/investment_controller.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/custom_app_bar.dart';
import 'package:dokandar/view/base/menu_drawer.dart';
import 'package:dokandar/view/screens/investment/widget/investment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repository/investment_repo.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({Key? key}) : super(key: key);

  @override
  InvestmentScreenState createState() => InvestmentScreenState();
}

class InvestmentScreenState extends State<InvestmentScreen>
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
      Get.find<InvestmentController>().getFlexiblePackages(1);
      Get.find<InvestmentController>().getLockedInPackages(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
          title: 'Investment', backButton: ResponsiveHelper.isDesktop(context)),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<InvestmentController>(
        builder: (investmentController) {
          return _isLoggedIn
              ? Column(children: [
                  Container(
                    color: ResponsiveHelper.isDesktop(context)
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Column(children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeSmall),
                              child: Text('Investment',
                                  style: robotoBold.copyWith(
                                      fontSize: 24,
                                      color: Theme.of(context).primaryColor)),
                            ))
                          : const SizedBox(),
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
                                    Theme.of(context).primaryColor,
                                unselectedLabelStyle: robotoRegular.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall),
                                labelStyle: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).primaryColor),
                                tabs: [
                                  Tab(text: 'Short Term'.tr),
                                  Tab(text: 'Long Term'.tr),
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
                      InvestmentView(type: 'flexible'),
                      InvestmentView(type: 'locked-in'),
                    ],
                  )),
                ])
              : Container();
        },
      ),
    );
  }
}
