import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/requests/request_list_provider.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import '../modules/requests/request.dart';

class AcceptBottomSheet extends ConsumerStatefulWidget {
  const AcceptBottomSheet({super.key, required this.request});

  final Request request;

  @override
  AcceptBottomSheetState createState() => AcceptBottomSheetState();

  static void show(BuildContext context, Request request) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AcceptBottomSheet(request: request),
    );
  }
}

class AcceptBottomSheetState extends ConsumerState<AcceptBottomSheet> {
  String? _selectedOption = 'reject';

  Future<void> _acceptRequest(Request request) async {
    final currentUser = ref.read(currentUserProvider);
    await ref
        .read(receivedRequestsProvider.notifier)
        .acceptRequest(request, currentUser!);
  }

  Future<void> _rejectRequest(Request request) async {
    await ref.read(receivedRequestsProvider.notifier).rejectRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('アクションを選択してください', style: textTheme.titleLarge),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          RadioListTile<String>(
            title: Text('承認する'),
            value: 'accept',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('承認しない'),
            value: 'reject',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectedOption == 'accept'
                      ? _acceptRequest(widget.request)
                      : _rejectRequest(widget.request);
                  Navigator.pop(context);
                },
                child: Text('決定'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
