import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/view/components/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.index,
    required this.id,
    required this.dueDate,
    required this.amount,
    required this.status,
    //  required this.invoiceModel,
  });
  final int index;
  // final InvoicesModel invoiceModel;
  final String id;
  final String dueDate;
  final double amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.toNamed(RouteHelper.invoiceDetailsScreen,
        //     arguments: invoiceModel.data![index].id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.invoiceTextStatusColor(status),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(Dimensions.space15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          id,
                          style: regularLarge,
                        ),
                        Text(
                          '\$$amount',
                          style: regularLarge,
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: status,
                          prefix: const Icon(
                            Icons.check_circle_outline_rounded,
                            color: ColorResources.secondaryColor,
                            size: 14,
                          ),
                          edgeInsets: EdgeInsets.zero,
                          textStyle: lightDefault.copyWith(
                              color: ColorResources.blueGreyColor),
                        ),
                        const SizedBox(width: Dimensions.space10),
                        TextIcon(
                          text: dueDate,
                          prefix: const Icon(
                            Icons.calendar_month,
                            color: ColorResources.secondaryColor,
                            size: 14,
                          ),
                          edgeInsets: EdgeInsets.zero,
                          textStyle: lightDefault.copyWith(
                              color: ColorResources.blueGreyColor),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
