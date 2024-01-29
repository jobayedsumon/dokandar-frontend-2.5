import 'dart:async';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/base/custom_dialog.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/screens/address/address_screen.dart';
import 'package:sixam_mart/view/screens/chat/conversation_screen.dart';
import 'package:sixam_mart/view/screens/checkout/widget/congratulation_dialogue.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/address_bottom_sheet.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/navbar_custom_painter.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/parcel_bottom_sheet.dart';
import 'package:sixam_mart/view/screens/favourite/favourite_screen.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';
import 'package:sixam_mart/view/screens/menu/menu_screen_new.dart';
import 'package:sixam_mart/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen({Key? key, required this.pageIndex, this.fromSplash = false}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();


  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();

    if(_isLogin){
      if(Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 && Get.find<AuthController>().getEarningPint().isNotEmpty
          && !ResponsiveHelper.isDesktop(Get.context)){
        Future.delayed(const Duration(seconds: 1), () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      const SizedBox(),
      const OrderScreen(),
      const MenuScreenNew()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<LocationController>().checkLocationActive();
    if(widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheet(),
        ).then((value) {
          Get.find<LocationController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return GetBuilder<SplashController>(
      builder: (splashController) {
        return WillPopScope(
          onWillPop: () async {
            if (_pageIndex != 0) {
              _setPage(0);
              return false;
            } else {
              if(splashController.isRefreshing) {
                showCustomSnackBar('please_wait_until_refresh_complete'.tr, isError: true);
                return false;
              }
              if(!ResponsiveHelper.isDesktop(context) && Get.find<SplashController>().module != null && Get.find<SplashController>().configModel!.module == null) {
                Get.find<SplashController>().setModule(null);
                return false;
              }else {
                if(_canExit) {
                  return true;
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  ));
                  _canExit = true;
                  Timer(const Duration(seconds: 2), () {
                    _canExit = false;
                  });
                  return false;
                }
              }
            }
          },
          child: GetBuilder<OrderController>(
            builder: (orderController) {
              List<OrderModel> runningOrder = orderController.runningOrderModel != null ? orderController.runningOrderModel!.orders! : [];

              List<OrderModel> reversOrder =  List.from(runningOrder.reversed);

              return Scaffold(
                key: _scaffoldKey,
                body: ExpandableBottomSheet(
                  background: Stack(children: [
                    PageView.builder(
                        controller: _pageController,
                        itemCount: _screens.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _screens[index];
                        },
                      ),

                      ResponsiveHelper.isDesktop(context) || keyboardVisible ? const SizedBox() : Align(
                        alignment: Alignment.bottomCenter,
                        child: GetBuilder<SplashController>(
                          builder: (splashController) {
                            bool isParcel = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isParcel!;

                            _screens = [
                              const HomeScreen(),
                              isParcel ? const AddressScreen(fromDashboard: true) : const FavouriteScreen(),
                              const SizedBox(),
                              const OrderScreen(),
                              const MenuScreenNew()
                            ];
                            return Container(
                              width: size.width, height: GetPlatform.isIOS ? 80 : 65,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                              ),
                              child: Stack(children: [
                                // CustomPaint(size: Size(size.width, GetPlatform.isIOS ? 95 : 80), painter: BNBCustomPainter()),

                                Center(
                                  heightFactor: 0.6,
                                  child: ResponsiveHelper.isDesktop(context) ? null : (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? null
                                    : (orderController.showBottomSheet && orderController.runningOrderModel != null && orderController.runningOrderModel!.orders!.isNotEmpty && _isLogin) ? const SizedBox() : Container(
                                      width: 60, height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).cardColor, width: 5),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, -2), spreadRadius: 0)]
                                      ),
                                      // margin: EdgeInsets.only(bottom: GetPlatform.isIOS ? 0 : Dimensions.paddingSizeLarge),
                                      child: FloatingActionButton(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          if(isParcel) {
                                            showModalBottomSheet(
                                              context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                              builder: (con) => ParcelBottomSheet(parcelCategoryList: Get.find<ParcelController>().parcelCategoryList),
                                            );
                                          } else {
                                            Get.toNamed(RouteHelper.getCartRoute());
                                          }
                                        },
                                        elevation: 0,
                                        child: isParcel
                                            ? Icon(CupertinoIcons.add, size: 34, color: Theme.of(context).cardColor)
                                            : CartWidget(color: Theme.of(context).cardColor, size: 22),
                                      ),
                                  ),
                                ),

                                ResponsiveHelper.isDesktop(context) ? const SizedBox() : (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? const SizedBox()
                                : (orderController.showBottomSheet && orderController.runningOrderModel != null && orderController.runningOrderModel!.orders!.isNotEmpty && _isLogin) ? const SizedBox() : Center(
                                  child: SizedBox(
                                      width: size.width, height: 80,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        BottomNavItem(
                                          title: 'home'.tr, selectedIcon: Images.homeSelect,
                                          unSelectedIcon: Images.homeUnselect, isSelected: _pageIndex == 0,
                                          onTap: () => _setPage(0),
                                        ),
                                        BottomNavItem(
                                          title: isParcel ? 'address'.tr : 'favourite'.tr,
                                          selectedIcon: isParcel ? Images.addressSelect : Images.favouriteSelect,
                                          unSelectedIcon: isParcel ? Images.addressUnselect : Images.favouriteUnselect,
                                          isSelected: _pageIndex == 1, onTap: () => _setPage(1),
                                        ),
                                        Container(width: size.width * 0.2),
                                        BottomNavItem(
                                          title: 'orders'.tr, selectedIcon: Images.orderSelect, unSelectedIcon: Images.orderUnselect,
                                          isSelected: _pageIndex == 3, onTap: () => _setPage(3),
                                        ),
                                        BottomNavItem(
                                          title: 'menu'.tr, selectedIcon: Images.menu, unSelectedIcon: Images.menu,
                                          isSelected: _pageIndex == 4, onTap: () => _setPage(4),
                                        ),
                                      ]),
                                  ),
                                ),
                              ],
                              ),
                            );
                          }
                        ),
                      ),
                    ]),

                  persistentContentHeight: (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? 0 : 100 ,

                  onIsContractedCallback: () {
                    if(!orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },
                  onIsExtendedCallback: () {
                    if(orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },

                  enableToggle: true,

                  expandableContent: (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active && !ResponsiveHelper.isDesktop(context)) ?  const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) || !_isLogin || orderController.runningOrderModel == null
                  || orderController.runningOrderModel!.orders!.isEmpty || !orderController.showBottomSheet) ? const SizedBox()
                  : Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if(orderController.showBottomSheet){
                        orderController.showRunningOrders();
                      }
                    },
                    child: RunningOrderViewWidget(reversOrder: reversOrder, onOrderTap: () {
                      _setPage(3);
                      if(orderController.showBottomSheet){
                        orderController.showRunningOrders();
                      }
                    }),
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(height: 3, decoration: BoxDecoration(color: status ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}

