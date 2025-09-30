import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modules/requests/request.dart';
import 'accept_bottom_sheet.dart';

final DateFormat outputFormat = DateFormat('yyyy/MM/dd');

class ReceivedRequestCard extends StatelessWidget {
  const ReceivedRequestCard({super.key, required this.request});

  final Request request;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          AcceptBottomSheet.show(context, request);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child:
                    (request.status == 'pending')
                        ? Text('承認待ち', style: textTheme.titleLarge)
                        : (request.status == 'accepted')
                        ? Text('承認済み', style: textTheme.titleLarge)
                        : Text('否認済み', style: textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'from: ${request.fromUserName}',
                  style: textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
