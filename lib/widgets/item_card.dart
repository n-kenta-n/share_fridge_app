import 'package:flutter/material.dart';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:intl/intl.dart';
import 'package:share_fridge_app/screens/update_item_screen.dart';
import 'package:share_fridge_app/widgets/dynamic_padding.dart';

final DateFormat outputFormat = DateFormat('MM/dd');

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DynamicPadding(
      left: 0.03,
      top: 0.03,
      right: 0.03,
      bottom: 0.03,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return UpdateItemScreen(item: item);
                },
              ),
            );
          },
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(20),
            child: DynamicPadding(
              left: 0.04,
              top: 0.04,
              right: 0.04,
              bottom: 0.04,
              child: Row(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final zeroThree = c.maxHeight * 0.03;
                        final one = c.maxHeight * 0.1;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: zeroThree,
                                top: one,
                                right: zeroThree,
                                bottom: one,
                              ),
                              child: Text(
                                item.itemName,
                                style: textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(zeroThree),
                              child:
                                  // 少数がない場合は整数表示
                                  item.amount == item.amount.toInt()
                                      ? Text(
                                        '${item.amount.toStringAsFixed(0)} ${item.unit}',
                                        style: textTheme.bodySmall,
                                      )
                                      : Text(
                                        '${item.amount.toString()} ${item.unit}',
                                        style: textTheme.bodySmall,
                                      ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(zeroThree),
                              child:
                                  item.limitDate != null
                                      ? Text(
                                        '${outputFormat.format(item.limitDate!)} まで',
                                        style: textTheme.bodySmall,
                                      )
                                      : Text(
                                        '期限なし',
                                        style: textTheme.bodySmall,
                                      ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // 右半分：画像
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // 親ウィジェットの縦サイズ（maxHeight）を基準にする
                      final size = constraints.maxHeight * 0.7; // 例: 親高さの70%
                      return SizedBox(
                        height: size,
                        width: size, // 正方形にするため高さと同じ
                        child:
                            item.imageUrl == null
                                ? Container(
                                  color: Color(0xFFCFCFCF),
                                  child: Center(
                                    child: Text(
                                      '画像なし',
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                )
                                : Image.network(item.imageUrl!),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
