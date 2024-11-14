import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/view/screens/home/widget/custom_linerprogress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeInvoicesCard extends StatelessWidget {
  const HomeInvoicesCard({
    super.key,
    // required this.invoices,
  });
  //final List<DataField>? invoices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.space12),
              child: TextIcon(
                text: LocalStrings.invoices.tr,
                prefix: const Icon(
                  Icons.assignment_outlined,
                  size: 20,
                ),
                spacing: 10,
                edgeInsets: EdgeInsets.zero,
                textStyle: regularExtraLarge,
              ),
            ),
            const SizedBox(height: Dimensions.space5),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('dashboard_data')
                    .doc('statistics')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final invoices = snapshot.data!['invoices'];
                    Map<String, int> intMap = Map<String, int>.fromIterable(
                      invoices.keys,
                      value: (key) => invoices[key] as int,
                    );
                    List<int> valuesList = intMap.values.toList();
                    List<String> keysList = intMap.keys.toList();

                    //    return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15),
                      child: SizedBox(
                        height: 350,
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CustomLinerProgress(
                                name: keysList[index].capitalize!.tr,
                                color: ColorResources.invoiceTextStatusColor(
                                    keysList[index].capitalize!),
                                value: valuesList[index].toDouble() / 100,
                                data: valuesList[index].toString(),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: Dimensions.space2),
                            itemCount: invoices.length ?? 0),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
