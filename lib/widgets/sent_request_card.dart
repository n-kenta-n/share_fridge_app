import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modules/requests/request.dart';
import 'accept_bottom_sheet.dart';

final DateFormat outputFormat = DateFormat('yyyy/MM/dd');

class SentRequestCard extends StatelessWidget {
  const SentRequestCard({super.key, required this.request});

  final Request request;

  /*
  void _showMyBottomSheet(BuildContext context, Request request) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AcceptBottomSheet(request: request),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          // _showMyBottomSheet(context, request);
        },
        child: Container(
          padding: const EdgeInsets.all(7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(7),
                child:
                    (request.status == 'pending')
                        ? Text('承認待ち', style: textTheme.titleLarge)
                        : (request.status == 'accepted')
                        ? Text('承認されました', style: textTheme.titleLarge)
                        : Text('否認されました', style: textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'to: ${request.toUserEmail}',
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
