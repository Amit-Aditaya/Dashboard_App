import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/data/controller/home/home_controller.dart';
import 'package:flutex_admin/data/repo/home/home_repo.dart';
import 'package:flutex_admin/data/services/api_service.dart';
import 'package:flutex_admin/view/components/app-bar/action_button_icon_widget.dart';
import 'package:flutex_admin/view/components/circle_image_button.dart';
import 'package:flutex_admin/view/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/view/components/will_pop_widget.dart';
import 'package:flutex_admin/view/screens/home/widget/dashboard_card.dart';
import 'package:flutex_admin/view/screens/home/widget/drawer.dart';
import 'package:flutex_admin/view/screens/home/widget/home_estimates_card.dart';
import 'package:flutex_admin/view/screens/home/widget/home_invoices_card.dart';
import 'package:flutex_admin/view/screens/home/widget/home_proposals_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(HomeRepo(apiClient: Get.find()));
    final controller = Get.put(HomeController(homeRepo: Get.find()));
    controller.isLoading = true;

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: '',
      child: GetBuilder<HomeController>(builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 50,
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }),
            centerTitle: true,
            title: CachedNetworkImage(
                imageUrl: controller.homeModel.overview?.perfexLogo ?? '',
                fit: BoxFit.cover,
                height: 30,
                errorWidget: (ctx, object, trx) {
                  return Image.asset(
                    MyImages.appLogo,
                    fit: BoxFit.cover,
                    height: 30,
                  );
                },
                placeholder: (ctx, trx) {
                  return Image.asset(
                    MyImages.appLogo,
                  );
                }),
            actions: [
              ActionButtonIconWidget(
                pressed: () => Get.toNamed(RouteHelper.settingsScreen),
                icon: Icons.settings,
                size: 35,
                iconColor: Colors.white,
              ),
            ],
          ),
          drawer: const HomeDrawer(),
          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: ColorResources.primaryColor,
                  onRefresh: () async {
                    await controller.initialData(shouldLoad: false);
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Dimensions.space10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorResources.blueGreyColor,
                                radius: 32,
                                child: CircleImageWidget(
                                  imagePath: controller
                                          .homeModel.staff?.profileImage ??
                                      '',
                                  isAsset: false,
                                  isProfile: true,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              const SizedBox(width: Dimensions.space20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: '${LocalStrings.welcome.tr} ',
                                      style: regularLarge.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                    TextSpan(
                                      text:
                                          '${controller.homeModel.staff?.firstName ?? ''} ${controller.homeModel.staff?.lastName ?? ''}',
                                      style: regularLarge.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  ])),
                                  const SizedBox(height: Dimensions.space5),
                                  Text(
                                    controller.homeModel.staff?.email ?? '',
                                    style: regularSmall.copyWith(
                                        color: ColorResources.blueGreyColor),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('dashboard_data')
                                .doc('statistics')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                int? totalInvoice =
                                    snapshot.data!['totalInvoices'];
                                int? invoicesAwaitingPayment =
                                    snapshot.data!['invoicesAwaitingPayment'];

                                int? notCompletedTasks =
                                    snapshot.data!['notCompletedTasks'];
                                int? totalTasks = snapshot.data!['totalTasks'];

                                int? convertedLeads =
                                    snapshot.data!['convertedLeads'];
                                int? totalLeads = snapshot.data!['totalLeads'];

                                int? projectsInProgress =
                                    snapshot.data!['projectsInProgress'];
                                int? totalProjects =
                                    snapshot.data!['totalProjects'];

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DashboardCard(
                                          currentValue:
                                              invoicesAwaitingPayment ?? 0,
                                          totalValue: totalInvoice ?? 0,
                                          percent:
                                              (((invoicesAwaitingPayment ?? 0) /
                                                          (totalInvoice ?? 0)) *
                                                      100)
                                                  .toString(),
                                          icon: Icons.attach_money_rounded,
                                          title: LocalStrings
                                              .invoicesAwaitingPayment.tr,
                                        ),
                                        DashboardCard(
                                          currentValue: convertedLeads ?? 0,
                                          totalValue: totalLeads ?? 0,
                                          percent: (((convertedLeads ?? 0) /
                                                      (totalLeads ?? 0)) *
                                                  100)
                                              .toString(),
                                          icon: Icons.move_up_rounded,
                                          title: LocalStrings.convertedLeads.tr,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        DashboardCard(
                                          currentValue: notCompletedTasks ?? 0,
                                          totalValue: totalTasks ?? 0,
                                          percent: (((notCompletedTasks ?? 0) /
                                                      (totalTasks ?? 0)) *
                                                  100)
                                              .toString(),
                                          icon: Icons.task_outlined,
                                          title: LocalStrings.notCompleted.tr,
                                        ),
                                        DashboardCard(
                                          currentValue: projectsInProgress ?? 0,
                                          totalValue: totalProjects ?? 0,
                                          percent: (((projectsInProgress ?? 0) /
                                                      (totalProjects ?? 0)) *
                                                  100)
                                              .toString(),
                                          icon:
                                              Icons.dashboard_customize_rounded,
                                          title: LocalStrings
                                              .projectsInProgress.tr,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        CarouselSlider(
                          items: const [
                            HomeInvoicesCard(),
                            HomeEstimatesCard(),
                            HomeProposalsCard(),
                          ],
                          options: CarouselOptions(
                            height: 450.0,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: false,
                            onPageChanged: (index, i) {
                              currentPageIndex = index;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.space10),
                        Center(
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    3,
                                    (index) => Container(
                                          margin: const EdgeInsets.all(3),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: index == currentPageIndex
                                                  ? ColorResources.primaryColor
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: ColorResources
                                                      .primaryColor,
                                                  width: 1)),
                                        )))),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
