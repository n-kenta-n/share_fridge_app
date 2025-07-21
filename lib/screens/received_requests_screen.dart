import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modules/requests/request_list_provider.dart';
import '../widgets/received_request_card.dart';

class ReceivedRequestsScreen extends ConsumerStatefulWidget {
  const ReceivedRequestsScreen({super.key});

  @override
  ReceivedRequestsState createState() => ReceivedRequestsState();
}

class ReceivedRequestsState extends ConsumerState<ReceivedRequestsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(receivedRequestsProvider.notifier).fetchNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestList = ref.watch(receivedRequestsProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false, // 左に自動で出る、戻るアイコンを無効にする
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: requestList.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Error: $error'),
              data:
                  (requests) => ListView.builder(
                    controller: _scrollController,
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return ReceivedRequestCard(request: request);
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
