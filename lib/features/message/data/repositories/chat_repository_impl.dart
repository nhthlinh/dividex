import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/data/source/chat_remote_datasource.dart';
import 'package:Dividex/features/message/domain/repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<PagingModel<List<Message>>> getMessages(
    int page,
    int pageSize,
    String groupId,
  ) {
    return remoteDataSource.getMessages(page, pageSize, groupId);
  }

  @override
  Future<Message> sendMessage(String content, String groupId) {
    return remoteDataSource.sendMessage(content, groupId);
  }

  @override
  Future<void> updateMessage(String messageId, String content) {
    return remoteDataSource.updateMessage(messageId, content);
  }

  @override
  Future<void> deleteMessage(String messageId) {
    return remoteDataSource.deleteMessage(messageId);
  }
}