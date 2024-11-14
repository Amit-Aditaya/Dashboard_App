import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/view/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/view/components/overview_card.dart';
import 'package:flutex_admin/view/screens/invoice/widget/invoice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  @override
  void initState() {
    // Get.put(ApiClient(sharedPreferences: Get.find()));
    // Get.put(InvoiceRepo(apiClient: Get.find()));
    // final controller = Get.put(InvoiceController(invoiceRepo: Get.find()));
    // Get.put(HomeRepo(apiClient: Get.find()));
    // final homeController = Get.put(HomeController(homeRepo: Get.find()));
    // controller.isLoading = true;
    // super.initState();
    // handleScroll();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   controller.initialData();
    //   homeController.initialData();
    // });
  }

  bool showFab = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.invoices.tr,
        ),
        // floatingActionButton: AnimatedSlide(
        //   offset: showFab ? Offset.zero : const Offset(0, 2),
        //   duration: const Duration(milliseconds: 300),
        //   child: AnimatedOpacity(
        //     opacity: showFab ? 1 : 0,
        //     duration: const Duration(milliseconds: 300),
        //     child: CustomFAB(
        //         isShowIcon: true,
        //         isShowText: false,
        //         press: () {
        //           Get.toNamed(RouteHelper.addInvoiceScreen);
        //         }),
        //   ),
        // ),
        body: RefreshIndicator(
          color: ColorResources.primaryColor,
          onRefresh: () async {
            // await controller.initialData(shouldLoad: false);
            // await homeController.initialData();
          },
          child: Column(
            children: [
              ExpansionTile(
                title: Row(
                  children: [
                    Container(
                      width: Dimensions.space3,
                      height: Dimensions.space15,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: Dimensions.space5),
                    Text(
                      LocalStrings.invoiceSummery.tr,
                      style: regularLarge.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                  ],
                ),
                shape: const Border(),
                initiallyExpanded: true,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('invoiceSummary')
                          .doc('summary')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          //return const SizedBox();
                          var data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          Map<String, int> intMap =
                              Map<String, int>.fromIterable(
                            data.keys,
                            value: (key) => data[key] as int,
                          );
                          List<int> valuesList = intMap.values.toList();
                          List<String> keysList = intMap.keys.toList();
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space15),
                            child: SizedBox(
                              height: 80,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return OverviewCard(
                                        name: keysList[index],
                                        number: valuesList[index].toString(),
                                        color: ColorResources.blueColor);
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: Dimensions.space5),
                                  itemCount: valuesList.length),
                            ),
                          );
                        }
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(Dimensions.space15),
                child: Row(
                  children: [
                    Text(
                      LocalStrings.invoices.tr,
                      style: regularLarge.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sort_outlined,
                            size: Dimensions.space15,
                            color: ColorResources.blueGreyColor,
                          ),
                          const SizedBox(width: Dimensions.space5),
                          Text(
                            LocalStrings.filter.tr,
                            style: lightSmall.copyWith(
                                color: ColorResources.blueGreyColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('invoices')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space15),
                          child: ListView.separated(
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                //       return const SizedBox();
                                final invoice = snapshot.data!.docs[index];
                                return InvoiceCard(
                                  index: index,
                                  status: invoice['status'],
                                  dueDate: invoice['due_date'],
                                  amount: invoice['amount'],
                                  id: invoice['id'],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Dimensions.space10),
                              itemCount: snapshot.data!.docs.length),
                        ),
                      );
                    }
                  })

              // controller.invoicesModel.data!.isNotEmpty
              //     ? Expanded(
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: Dimensions.space15),
              //           child: ListView.separated(
              //               controller: scrollController,
              //               itemBuilder: (context, index) {
              //                 return InvoiceCard(
              //                   index: index,
              //                   invoiceModel:
              //                       controller.invoicesModel,
              //                 );
              //               },
              //               separatorBuilder: (context, index) =>
              //                   const SizedBox(
              //                       height: Dimensions.space10),
              //               itemCount: controller
              //                   .invoicesModel.data!.length),
              //         ),
              //       )
              //     : const NoDataWidget(),
            ],
          ),
        ));
  }
}
