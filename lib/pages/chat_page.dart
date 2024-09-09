import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/components/rounded_close_button.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key}); // コンストラクタを変更

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late final SupabaseService supabaseService;
  late final String userId;
  String myId = '';

  @override
  void initState() {
    super.initState();

    supabaseService = ref.read(supabaseServiceProvider);
    userId = supabaseService.supabase.auth.currentUser!.id;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await supabaseService.sendMessage(
          userId, _messageController.text, userId);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(S.of(context).supportPageName),
        leading: const RoundedCloseButton(),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: boxWidth),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: supabaseService.streamMessages(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // データ取得中の場合の処理（例：ローディングインジケーターを表示）
                          return const Center(
                            child: SizedBox(
                              width: 60,
                              child: SizedBox(
                                height: 60,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          // エラーが発生した場合の処理
                          return Text(S.of(context).unknownError);
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          // データがない場合の処理
                          return Text(S.of(context).noDataFound);
                        }

                        final messages = snapshot.data!;

                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final bool isMyMessage =
                                message['sender_id'] == userId;
                            return Align(
                              alignment: isMyMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isMyMessage
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                  borderRadius: isMyMessage
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.zero,
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.zero,
                                          bottomRight: Radius.circular(15),
                                        ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isMyMessage
                                          ? message['message_text']
                                          : message['message_text'] +
                                              " 👩🏻‍🦰",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: isMyMessage
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer),
                                    ),
                                    Text(
                                      timeago.format(
                                          DateTime.parse(message['created_at']),
                                          locale: 'en_short'),
                                      style: TextStyle(
                                          color: isMyMessage
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 50.0),
                  // ここで下側に余白を追加
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer),
                            labelText: S.of(context).typeAMessage,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(outlineInputBorderColor)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.send_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer, // ここでアイコンの色を設定
                              ),
                              onPressed: sendMessage,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
