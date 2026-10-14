import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../models/insight_models.dart';

class InsightChatTab extends StatefulWidget {
  final List<ChatMessage> messages;
  final List<String> suggestedPrompts;
  final bool isAiTyping;
  final bool showBanner;
  final VoidCallback onDismissBanner;
  final ValueChanged<String> onSendPrompt;

  const InsightChatTab({
    super.key,
    required this.messages,
    required this.suggestedPrompts,
    required this.isAiTyping,
    required this.showBanner,
    required this.onDismissBanner,
    required this.onSendPrompt,
  });

  @override
  State<InsightChatTab> createState() => _InsightChatTabState();
}

class _InsightChatTabState extends State<InsightChatTab> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasInputText = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      final hasText = _inputController.text.trim().isNotEmpty;
      if (hasText != _hasInputText) {
        setState(() => _hasInputText = hasText);
      }
    });
  }

  @override
  void didUpdateWidget(InsightChatTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messages.length != widget.messages.length ||
        oldWidget.isAiTyping != widget.isAiTyping) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;
    widget.onSendPrompt(clean);
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        if (widget.showBanner) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2A2111), const Color(0xFF1B1710)]
                    : [const Color(0xFFFFF9ED), const Color(0xFFFBF4E4)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFB57510).withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB57510).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    color: Color(0xFFB57510),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AI Financial Advisor Active",
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1F1A12),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Synced with March spend • Balance: ₦250,000",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onDismissBanner,
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: widget.messages.length + (widget.isAiTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= widget.messages.length) {
                return _buildTypingIndicator(context);
              }
              return _buildMessageBubble(context, widget.messages[index]);
            },
          ),
        ),
        // Suggested prompt chips
        Container(
          height: 38,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.suggestedPrompts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final prompt = widget.suggestedPrompts[index];
              return InkWell(
                onTap: () => _send(prompt),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1A14) : const Color(0xFFF5EFE3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFB57510).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 13,
                        color: Color(0xFFB57510),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        prompt,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Chat text input bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181510) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : const Color(0xFFE5DECE),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 4),
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFB57510),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  onSubmitted: _send,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintText: "Ask Zengly AI about fees, budget, transfers...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _send(_inputController.text),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD49B28), Color(0xFFB57510)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB57510).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aiAvatar(context),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF211D16) : const Color(0xFFF6F3EB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFB57510)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Zengly AI is analyzing...",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aiAvatar(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFE5A93C), Color(0xFFB57510)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB57510).withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.76,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: message.isUser
            ? null
            : (isDark ? const Color(0xFF211D16) : const Color(0xFFF6F3EB)),
        gradient: message.isUser
            ? const LinearGradient(
                colors: [Color(0xFFC98C1E), Color(0xFFB57510)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(message.isUser ? 18 : 4),
          bottomRight: Radius.circular(message.isUser ? 4 : 18),
        ),
        border: message.isUser
            ? null
            : Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.45,
              color: message.isUser
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF1E1A14)),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              message.timestamp,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: message.isUser
                    ? Colors.white70
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: message.isUser
            ? [
                Flexible(child: bubble),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(AppImages.dummyPerson),
                ),
              ]
            : [
                _aiAvatar(context),
                const SizedBox(width: 8),
                Flexible(child: bubble),
              ],
      ),
    );
  }
}
