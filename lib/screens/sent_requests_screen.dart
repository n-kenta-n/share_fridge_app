import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modules/requests/request_list_provider.dart';
import '../widgets/sent_request_card.dart';

class SentRequestsScreen extends ConsumerStatefulWidget {
  const SentRequestsScreen({super.key});

  @override
  SentRequestsState createState() => SentRequestsState();
}

class SentRequestsState extends ConsumerState<SentRequestsScreen> {
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
      ref.read(sentRequestsProvider.notifier).fetchNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestList = ref.watch(sentRequestsProvider);

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
              error: (e, _) => Center(child: Text('Error: $e')),
              data:
                  (requests) => ListView.builder(
                    controller: _scrollController,
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return SentRequestCard(request: request);
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
