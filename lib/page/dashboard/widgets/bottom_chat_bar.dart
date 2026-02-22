import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class BottomChatBar extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final VoidCallback? onSend;
  final bool isActive;
  final bool isLoading;

  const BottomChatBar({
    super.key,
    this.focusNode,
    this.controller,
    this.onSend,
    this.isActive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
      padding: EdgeInsets.fromLTRB(
        isActive ? 12 : 20,
        8,
        isActive ? 12 : 20,
        isActive ? 12 : 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isActive ? 16 : 30),
                border: Border.all(
                  color: Colors.black.withOpacity(isActive ? 0.1 : 0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isActive ? 0.04 : 0.06),
                    blurRadius: isActive ? 10 : 20,
                    offset: isActive ? const Offset(0, 2) : const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                onSubmitted: (_) => onSend?.call(),
                decoration: const InputDecoration(
                  hintText: 'Chat with Heracle AI...',
                  hintStyle: TextStyle(
                    color: HeracleTheme.textGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isLoading ? null : onSend,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1D1B20),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
