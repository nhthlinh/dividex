import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/domain/repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatUseCase {
  final ChatRepository repository;

  ChatUseCase(this.repository);

  Future<PagingModel<List<Message>>> getMessages(int page, int pageSize, String groupId) {
    return repository.getMessages(page, pageSize, groupId);
  }

  Future<Message> sendMessage(String content, String groupId) {
    return repository.sendMessage(content, groupId);
  }

  Future<void> updateMessage(String messageId, String content) {
    return repository.updateMessage(messageId, content);
  }

  Future<void> deleteMessage(String messageId) {
    return repository.deleteMessage(messageId);
  }
}
