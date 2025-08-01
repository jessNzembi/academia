import 'package:academia/features/chirp/chirp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:academia/config/router/routes.dart';
import '../../bloc/conversations/messaging_bloc.dart';
import '../../bloc/conversations/messaging_state.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        BlocBuilder<MessagingBloc, MessagingState>(
          builder: (context, state) {
            if (state is MessagingLoadingState) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is MessagingErrorState) {
              return SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.connect_without_contact,
                          size: 80,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        Text(
                          "Don't hold back unleash your vibes",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is ConversationsLoaded || state is MessagesLoaded) {
              final conversations = state is ConversationsLoaded
                  ? (state).conversations
                  : (state as MessagesLoaded).conversations;

              if (conversations.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No messages yet',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Search for a friend and unleash your vibes into their existence'",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Search feature coming soon!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  showCloseIcon: true,
                                ),
                                snackBarAnimationStyle: AnimationStyle(
                                  curve: Curves.bounceIn,
                                ),
                              );
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Find Friends'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverList.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: conversation.user.avatarUrl != null
                            ? NetworkImage(conversation.user.avatarUrl!)
                            : null,
                        child: conversation.user.avatarUrl == null
                            ? Text(
                                conversation.user.name
                                    .split(' ')
                                    .map((n) => n[0])
                                    .join(''),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                              )
                            : null,
                      ),
                      title: Text(
                        conversation.user.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      trailing: conversation.unreadCount > 0
                          ? Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                conversation.unreadCount.toString(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            )
                          : null,
                      onTap: () {
                        ChatRoute(
                          conversationId: conversation.id,
                        ).push(context);
                      },
                    ),
                  );
                },
              );
            }
            return const SliverFillRemaining(
              child: Center(child: Text('Something went wrong')),
            );
          },
        ),
      ],
    );
  }
}
