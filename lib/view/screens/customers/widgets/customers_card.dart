import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomersCard extends StatelessWidget {
  const CustomersCard({
    super.key,
    required this.index,
    required this.customerName,
    required this.customerPhone,
    required this.active,
    //   required this.customerModel,
  });
  final int index;
//  final CustomersModel customerModel;
  final String customerName;
  final String customerPhone;
  final String active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(RouteHelper.customerDetailsScreen,
        //     arguments: customerModel.data![index].userId!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space5),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.cardRadius),
              color: Theme.of(context).cardColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space10),
                // leading: CircleAvatarWithInitialLetter(
                //   initialLetter: customerModel.data![index].company ?? '',
                // ),
                title: Text(customerName,
                    overflow: TextOverflow.ellipsis,
                    style: regularDefault.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color)),
                subtitle: Text(
                  customerPhone,
                  style: regularSmall.copyWith(color: ColorResources.blueColor),
                ),
                trailing: Container(
                    padding: const EdgeInsets.all(Dimensions.space5),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.cardRadius),
                        side: BorderSide(
                            color: active == 'Active'
                                ? ColorResources.greenColor
                                : ColorResources.redColor),
                      ),
                    ),
                    child: Text(
                      active == 'Active'
                          ? LocalStrings.active.tr
                          : LocalStrings.notActive.tr,
                      style: regularSmall.copyWith(
                          color: active == 'Active'
                              ? ColorResources.greenColor
                              : ColorResources.redColor),
                    )))),
      ),
    );
  }
}
