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

  @override
  void didUpdateWidget(InsightChatTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messages.length != widget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
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
    if (text.trim().isEmpty) return;
    widget.onSendPrompt(text);
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showBanner) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "AI has access to your March spending • Balance: ₦250,000",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onDismissBanner,
                  child: const Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: widget.messages.length + (widget.isAiTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= widget.messages.length) {
                return _buildTypingIndicator(context);
              }
              return _buildMessageBubble(context, widget.messages[index]);
            },
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.suggestedPrompts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final prompt = widget.suggestedPrompts[index];
              return GestureDetector(
                onTap: () => _send(prompt),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    prompt,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _inputController,
                  onSubmitted: _send,
                  style: GoogleFonts.inter(fontSize: 15, letterSpacing: 0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ask about POS fees, airtime, transfers...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _send(_inputController.text),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aiAvatar(context),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Typing…",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aiAvatar(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE5483B),
      ),
      alignment: Alignment.center,
      child: Text(
        "A",
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:
            message.isUser
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message.text,
        style: GoogleFonts.inter(
          fontSize: 15,
          height: 1.4,
          letterSpacing: 0,
          color:
              message.isUser
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children:
            message.isUser
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
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      message.timestamp,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  ),
                ],
      ),
    );
  }
}
