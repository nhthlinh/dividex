import 'dart:async';
import 'dart:convert';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/home/presentation/pages/setting_page.dart';
import 'package:Dividex/features/message/domain/usecase.dart';
import 'package:Dividex/features/message/presentation/bloc/chat_bloc.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:Dividex/features/message/data/model/message_model.dart';

class ChatService {
  final String apiBase;
  final String wsUrl;
  final String token;
  final String roomId;

  IOWebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _eventsController =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get events => _eventsController.stream;

  Timer? _reconnectTimer;
  bool _connected = false;
  bool get connected => _connected;

  ChatService({
    required this.apiBase,
    required this.wsUrl,
    required this.token,
    required this.roomId,
  });

  Future<void> connect() async {
    // Close existing
    await disconnect();

    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      _connected = true;
      _channel!.stream.listen(
        (message) {
          _handleWsMessage(message);
        },
        onDone: () {
          _connected = false;
          _scheduleReconnect();
          _addEvent({"type": "connection", "connected": false});
        },
        onError: (err) {
          _connected = false;
          _scheduleReconnect();
          _addEvent({"type": "connection", "connected": false});
        },

        cancelOnError: true,
      );

      _connected = true;
      _addEvent({"type": "connection", "connected": true});
    } catch (e) {
      _connected = false;
      _scheduleReconnect();
    }
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    if (_channel != null) {
      try {
        _channel!.sink.close(status.goingAway);
      } catch (_) {}
      _channel = null;
    }
    _connected = false;
    _addEvent({"type": "connection", "connected": false});
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;
    _reconnectTimer = Timer(Duration(seconds: 10), () async {
      await connect();
    });
  }

  void _handleWsMessage(dynamic message) {
    // Expect server to send JSON events like { type: 'new_message', message: {...} }
    try {
      final Map<String, dynamic> data = jsonDecode(message);
      _addEvent(data);
    } catch (e) {
      // ignore non-json
    }
  }

  void _addEvent(Map<String, dynamic> ev) {
    if (!_eventsController.isClosed) {
      _eventsController.add(ev);
    }
  }

  Future<Message> sendMessageHttp(String text) async {
    final useCase = await getIt.getAsync<ChatUseCase>();
    final message = await useCase.sendMessage(text, roomId);
    return message;
  }

  void sendTyping(bool isTyping) {
    if (_channel == null) return;
    final ev = jsonEncode({
      'type': 'typing',
      'room_id': roomId,
      'typing': isTyping,
    });
    try {
      _channel!.sink.add(ev);
    } catch (_) {}
  }

  void dispose() {
    _eventsController.close();
    disconnect();
  }
}

class ChatProvider extends ChangeNotifier {
  final ChatService service;

  List<Message> messages = [];
  bool isTyping = false;
  bool partnerTyping = false;
  bool sending = false;

  bool hasMore = false;
  bool isLoadingMore = false;

  StreamSubscription? _sub;

  ChatProvider({required this.service}) {
    _sub = service.events.listen((ev) {
      _handleEvent(ev);
    });
    service.connect();
  }

  void setMessages(List<Message> msgs) {
    messages = msgs;
    notifyListeners();
  }

  void updateMessage(String id, String newContent, String? status) {
    final index = messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      messages[index] = messages[index].copyWith(content: newContent, status: status);
      notifyListeners();
    }
  }

  void removeMessage(String id) {
    messages.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void setHasMore(bool value) {
    hasMore = value;
    notifyListeners();
  }

  void setLoadingMore(bool value) {
    isLoadingMore = value;
    notifyListeners();
  }

  void _handleEvent(Map<String, dynamic> ev) {
    print("message in socket: $ev");
    final type = ev['type'];
    if (type == 'connection') {
      debugPrint("WS connected = ${ev['connected']}");
      notifyListeners();
      return;
    }
    if (type == 'message') {
      final msg = Message.fromJson(ev);
      if (msg.createdAt == null) return;
      messages.insert(0, msg); // newest at top
      notifyListeners();
    }
    if (type == 'typing') {
      partnerTyping = ev['typing'] == true;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    sending = true;
    notifyListeners();
    try {
      await service.sendMessageHttp(text);
    } catch (e) {
      // handle error (show toast)
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  void setTyping(bool t) {
    isTyping = t;
    service.sendTyping(t);
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    service.dispose();
    super.dispose();
  }
}

class ChatPage extends StatefulWidget {
  final String roomName;
  final String roomId;

  const ChatPage({super.key, required this.roomName, required this.roomId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;
  int page = 1;

  bool get isConnected => context.watch<ChatProvider>().service.connected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final loadedBloc = context.read<LoadedMessageBloc>();
    loadedBloc.add(InitialEvent(widget.roomId));

    // Lắng nghe state từ bloc và gán vào ChatProvider
    loadedBloc.stream.listen((state) {
      final prov = context.read<ChatProvider>();
      prov.setMessages(state.messages);
      prov.setHasMore(state.page < state.totalPage);
      prov.setLoadingMore(false);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final prov = context.read<ChatProvider>();
    final loadedBloc = context.read<LoadedMessageBloc>();

    // nếu đang gần đầu
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (prov.hasMore && !prov.isLoadingMore) {
        prov.setLoadingMore(true);
        page++;

        loadedBloc.add(LoadMoreMessageEvent(widget.roomId, page, 100));

        Future.delayed(Duration(milliseconds: 100), _onScroll);
      }
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final prov = Provider.of<ChatProvider>(context, listen: false);
      prov.service.connect();
    }
  }

  void _onTextChanged(String v) {
    final prov = Provider.of<ChatProvider>(context, listen: false);
    prov.setTyping(true);
    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 2), () {
      prov.setTyping(false);
    });
  }

  Future<void> _send() async {
    final prov = Provider.of<ChatProvider>(context, listen: false);
    final t = _controller.text.trim();
    if (t.isEmpty) return;
    _controller.clear();
    prov.setTyping(false);
    await prov.sendMessage(t);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleLayout(
      title: widget.roomName + (isConnected ? " 🟢" : " 🔴"),
      showBack: true,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: _messagesList(),
          ),
          if (context.watch<ChatProvider>().partnerTyping) _typingLine(),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _messagesList() {
    return Consumer<ChatProvider>(
      builder: (c, prov, _) {
        final msgs = prov.messages;
        if (msgs.isEmpty) return Center(child: Text(''));

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 50) {
              if (prov.hasMore && !prov.isLoadingMore) {
                prov.setLoadingMore(true);
                page++;
                context.read<LoadedMessageBloc>().add(
                  LoadMoreMessageEvent(widget.roomId, page, 5),
                );
              }
            }
            return false;
          },
          child: ListView.builder(
            reverse: true,
            itemCount: msgs.length + (prov.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (prov.hasMore && index == msgs.length) {
                return Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                );
              }
              final m = msgs[index];
              return _messageBubble(m);
            },
          ),
        );
      },
    );
  }

  Widget _messageBubble(Message m) {
    final intl = AppLocalizations.of(context)!;
    final myId = HiveService.getUser().id ?? '';
    final isMine = m.user?.id == myId;
    final color = isMine ? AppThemes.primary5Color : Colors.grey[200];

    final radius = isMine
        ? BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    /// Xử lý nội dung hiển thị theo status
    String displayText = m.content ?? '';
    bool isDeleted = m.status == "DELETED";
    bool isEdited = m.status == "EDITED";

    if (isDeleted) {
      displayText = intl.messageDeleted;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine) ...[_avatar(m), SizedBox(width: 8)],

          Expanded(
            child: InkWell(
              onTap: () => isMine && !isDeleted ? messageAction(m) : null,
              child: Column(
                crossAxisAlignment: isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Nếu là "EDITED" thì hiển thị chú thích bên trên
                  if (isEdited && !isDeleted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        intl.edited,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  Container(
                    decoration: BoxDecoration(
                      color: isDeleted ? Colors.grey[300] : color,
                      borderRadius: radius,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(
                      displayText,
                      softWrap: true,
                      style: TextStyle(
                        color: isDeleted ? Colors.black45 : Colors.black87,
                        fontStyle: isDeleted
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    _formatTime(m.createdAt ?? DateTime.now()),
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          if (isMine) ...[SizedBox(width: 8), _avatar(m)],
        ],
      ),
    );
  }

  Widget _avatar(Message m) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRouteNames.friendProfile,
          pathParameters: {'id': m.user?.id ?? ''},
        );
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.grey,
        backgroundImage: (m.user?.avatar?.publicUrl.isNotEmpty ?? false)
            ? NetworkImage(m.user!.avatar!.publicUrl)
            : NetworkImage(
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(m.user?.fullName ?? '')}&background=random&color=fff&size=128',
              ),
      ),
    );
  }

  void messageAction(Message m) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    showCustomDialog(
      context: context,
      content: Column(
        children: [
          SettingOption(
            label: intl.edit,
            context: context,
            onTap: () {
              Navigator.pop(context); // Close the dialog
              _editController.text = m.content ?? '';

              showCustomDialog(
                context: context,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        intl.enterMessage,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          height: 16 / 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: _editController,
                      keyboardType: TextInputType.text,
                      isReadOnly: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: intl.accept,
                          onPressed: () {
                            final newContent = _editController.text;
                            // 1. Gửi event lên bloc
                            context.read<ChatBloc>().add(
                              UpdateMessageEvent(m.id!, newContent),
                            );
                            // 2. Cập nhật ngay message trong ChatProvider
                            final prov = context.read<ChatProvider>();
                            prov.updateMessage(
                              m.id!,
                              newContent,
                              "EDITED"
                            ); // bạn cần thêm method này trong ChatProvider
                            Navigator.pop(context); // Close the edit dialog
                          },
                          size: ButtonSize.medium,
                          customColor: AppThemes.primary3Color,
                        ),

                        CustomButton(
                          text: intl.cancel,
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          size: ButtonSize.medium,
                          type: ButtonType.secondary,
                          customColor: AppThemes.errorColor,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SettingOption(
            label: intl.delete,
            context: context,
            onTap: () {
              Navigator.pop(context); // đóng dialog
              // 1. Gửi event lên bloc
              context.read<ChatBloc>().add(DeleteMessageEvent(m.id!));
              // 2. Cập nhật ngay khỏi provider để UI cập nhật
              // context.read<ChatProvider>().removeMessage(m.id!);
              final prov = context.read<ChatProvider>();
              prov.updateMessage(
                m.id!,
                "",
                "DELETED"
              ); // bạn cần thêm method này trong ChatProvider
            },
          ),
        ],
      ),
    );
  }

  Widget _typingLine() {
    final intl = AppLocalizations.of(context)!;
    return Consumer<ChatProvider>(
      builder: (c, prov, _) {
        if (!prov.partnerTyping) return SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(intl.partnerTyping),
          ),
        );
      },
    );
  }

  Widget _inputBar() {
    final intl = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _onTextChanged,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: intl.enterMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Consumer<ChatProvider>(
              builder: (c, prov, _) {
                return IconButton(
                  onPressed: prov.sending ? null : _send,
                  icon: prov.sending
                      ? CircularProgressIndicator()
                      : Icon(Icons.send),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;

    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');

    if (isToday) {
      return '$h:$m';
    } else {
      final d = dt.day.toString().padLeft(2, '0');
      final mo = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      return '$d/$mo/$y $h:$m';
    }
  }
}
