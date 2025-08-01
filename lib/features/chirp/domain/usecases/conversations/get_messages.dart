import 'package:academia/core/core.dart';
import 'package:dartz/dartz.dart';
import '../../entities/conversations/message.dart';
import '../../repositories/conversations/message_repository.dart';

class GetMessages implements UseCase<List<Message>, String> {
  final MessageRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(String conversationId) async {
    return await repository.getMessages(conversationId);
  }
}
