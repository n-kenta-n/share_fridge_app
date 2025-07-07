import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/requests/request_list_provider.dart';
import 'package:share_fridge_app/modules/requests/request_repository.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import '../modules/requests/request.dart';

class AcceptBottomSheet extends ConsumerStatefulWidget {
  const AcceptBottomSheet({super.key, required this.request});

  final Request request;

  @override
  AcceptBottomSheetState createState() => AcceptBottomSheetState();
}

class AcceptBottomSheetState extends ConsumerState<AcceptBottomSheet> {
  String? _selectedOption = 'reject';

  Future<void> _acceptRequest(Request request) async {
    final currentUser = ref.read(currentUserProvider);
    await RequestRepository().acceptRequest(request, currentUser!);
  }

  Future<void> _rejectRequest(Request request) async {
    await RequestRepository().rejectRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('アクションを選択してください', style: textTheme.titleLarge),
          SizedBox(height: 16),
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
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectedOption == 'accept'
                      ? _acceptRequest(widget.request)
                      : _rejectRequest(widget.request);
                  ref.invalidate(requestListProvider); // Providerの強制的な更新
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
