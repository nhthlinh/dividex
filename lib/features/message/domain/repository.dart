import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/shared/models/paging_model.dart';

abstract class ChatRepository {
  Future<PagingModel<List<Message>>> getMessages(int page, int pageSize, String groupId);
  Future<Message> sendMessage(String content, String groupId);
  Future<void> updateMessage(String messageId, String content);
  Future<void> deleteMessage(String messageId);
}