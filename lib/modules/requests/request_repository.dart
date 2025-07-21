import 'package:share_fridge_app/modules/requests/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestRepository {
  final supabase = Supabase.instance.client;

  Future<Request?> sendRequest(User user, String toUserEmail) async {
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
      return null;
    }

    // なければ insert
    final request = await supabase.from('requests').insert({
      'from_user_id': user.id,
      'from_user_email': user.email,
      'from_user_name': user.userMetadata?['name'],
      'to_user_email': toUserEmail,
      'status': 'pending',
    }).select().single();

    return Request.fromJson({
      'id': request['id'],
      'createdAt': request['created_at'],
      'fromUserId': request['from_user_id'],
      'fromUserEmail': request['from_user_email'],
      'fromUserName': request['from_user_name'],
      'toUserEmail': request['to_user_email'],
      'toUserName': request['to_user_name'],
      'status': request['status'],
    });
  }

  Future<List<Request>> fetchReceivedRequests(
    int page,
    int number,
    User user,
  ) async {
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

  Future<List<Request>> fetchSentRequests(
    int page,
    int number,
    User user,
  ) async {
    final start = number * (page - 1);
    final end = start + number - 1;

    final requests = await supabase
        .from('requests')
        .select('*')
        .eq('from_user_id', user.id)
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

  Future<Request> acceptRequest(Request request, User currentUser) async {
    final toUser =
        await Supabase.instance.client
            .from('requests')
            .select('from_user_id')
            .eq('id', request.id)
            .maybeSingle();

    final fridge =
        await Supabase.instance.client
            .from('prime_fridges')
            .select('fridge_id')
            .eq('user_id', currentUser.id)
            .maybeSingle();

    final toUserId = toUser?['from_user_id'];
    final fridgeId = fridge?['fridge_id'];

    // shared_fridgesテーブルに挿入
    await Supabase.instance.client.from('shared_fridges').insert({
      'user_id': toUserId,
      'shared_fridge_id': fridgeId,
    });

    // リクエストを更新
    final response =
        await Supabase.instance.client
            .from('requests')
            .update({
              'status': 'accepted',
              'to_user_name': currentUser.userMetadata?['name'],
            })
            .eq('id', request.id)
            .select();

    final acceptedRequest = response.first;

    return Request.fromJson({
      'id': acceptedRequest['id'],
      'createdAt': acceptedRequest['created_at'],
      'fromUserId': acceptedRequest['from_user_id'],
      'fromUserEmail': acceptedRequest['from_user_email'],
      'fromUserName': acceptedRequest['from_user_name'],
      'toUserEmail': acceptedRequest['to_user_email'],
      'toUserName': acceptedRequest['to_user_name'],
      'status': acceptedRequest['status'],
    });
  }

  Future<Request> rejectRequest(Request request) async {
    // リクエストを更新
    final response =
        await Supabase.instance.client
            .from('requests')
            .update({'status': 'rejected'})
            .eq('id', request.id)
            .select();

    final rejectedRequest = response.first;

    return Request.fromJson({
      'id': rejectedRequest['id'],
      'createdAt': rejectedRequest['created_at'],
      'fromUserId': rejectedRequest['from_user_id'],
      'fromUserEmail': rejectedRequest['from_user_email'],
      'fromUserName': rejectedRequest['from_user_name'],
      'toUserEmail': rejectedRequest['to_user_email'],
      'toUserName': rejectedRequest['to_user_name'],
      'status': rejectedRequest['status'],
    });
  }
}
