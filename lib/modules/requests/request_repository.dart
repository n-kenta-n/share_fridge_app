import 'package:share_fridge_app/modules/requests/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestRepository {
  final supabase = Supabase.instance.client;

  Future<bool> sendRequest(User user, String toUserEmail) async {
    bool isSuccess = false;

    // まずリクエストが既にあるか確認
    final existing =
        await supabase
            .from('requests')
            .select('id')
            .eq('from_user_id', user.id)
            .eq('to_user_email', toUserEmail)
            .or('status.eq.pending,status.eq.accepted')
            .maybeSingle();

    // 既にリクエストが存在する場合何もしない
    if (existing != null) {
      return isSuccess;
    }

    // なければ insert
    await supabase.from('requests').insert({
      'from_user_id': user.id,
      'from_user_email': user.email,
      'from_user_name': user.userMetadata?['name'],
      'to_user_email': toUserEmail,
      'status': 'pending',
    });

    isSuccess = true;
    return isSuccess;
  }

  Future<List<Request>> fetchRequests(int page, int number, User user) async {
    final start = number * (page - 1);
    final end = start + number - 1;

    final requests = await supabase
        .from('requests')
        .select('*')
        .eq('to_user_email', user.email!)
        .or('status.eq.pending,status.eq.accepted')
        .range(start, end)
        .order('created_at', ascending: false);

    return requests
        .map(
          (request) => Request.fromJson({
            'id': request['id'],
            'createdAt': request['created_at'],
            'fromUserId': request['from_user_id'],
            'fromUserEmail': request['from_user_email'],
            'fromUserName': request['from_user_name'],
            'toUserEmail': request['to_user_email'],
            'toUserName': request['to_user_name'],
            'status': request['status'],
          }),
        )
        .toList();
  }

  Future<void> acceptRequest(Request request, User currentUser) async {
    await Supabase.instance.client
        .from('requests')
        .update({
          'status': 'accepted',
          'to_user_name': currentUser.userMetadata?['name'],
        })
        .eq('id', request.id);
  }

  Future<void> rejectRequest(Request request) async {
    await Supabase.instance.client
        .from('requests')
        .update({'status': 'rejected'})
        .eq('id', request.id);
  }
}
