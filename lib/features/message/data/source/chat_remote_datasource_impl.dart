import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/data/source/chat_remote_datasource.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDatasourceImpl implements ChatRemoteDataSource {
  final DioClient dio;

  ChatRemoteDatasourceImpl(this.dio);

  @override
  Future<PagingModel<List<Message>>> getMessages(int page, int pageSize, String groupId) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        '/messages/group/$groupId',
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      return PagingModel.fromJson(
        response.data,
        (jsonList) => (jsonList['content'] as List)
            .map((item) => Message.fromJson(item))
            .toList(),
      );
    });
  }

  @override
  Future<Message> sendMessage(String content, String groupId) async {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/messages/group/$groupId',
        data: {'content': content},
      );
      return Message.fromJson(response.data['data']);
    });
  }

  @override
  Future<void> updateMessage(String messageId, String content) async {
    return apiCallWrapper(() async {
      await dio.put(
        '/messages/$messageId',
        data: {'content': content},
      );
    });
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    return apiCallWrapper(() async {
      await dio.delete(
        '/messages/$messageId',
      );
    });
  }
}