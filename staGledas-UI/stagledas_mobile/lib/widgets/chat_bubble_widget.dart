import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stagledas_mobile/models/poruka.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class ChatBubbleWidget extends StatelessWidget {
  final Poruka poruka;

  const ChatBubbleWidget({super.key, required this.poruka});

  @override
  Widget build(BuildContext context) {
    final isSentByMe = poruka.posiljateljId == Authorization.id;
    final otherUser = isSentByMe ? poruka.primatelj : poruka.posiljatelj;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSentByMe) ...[
            _buildAvatar(otherUser?.slika),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSentByMe
                        ? const Color(0xFF4AB3EF).withOpacity(0.2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isSentByMe ? 16 : 4),
                      bottomRight: Radius.circular(isSentByMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    poruka.sadrzaj ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDate(poruka.datumSlanja),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (isSentByMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        poruka.procitano == true
                            ? Icons.done_all
                            : Icons.done,
                        size: 14,
                        color: poruka.procitano == true
                            ? const Color(0xFF4AB3EF)
                            : Colors.grey.shade400,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isSentByMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? slika) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: slika != null && slika.isNotEmpty
          ? MemoryImage(base64Decode(slika))
          : null,
      child: slika == null || slika.isEmpty
          ? const Icon(Icons.person, size: 18, color: Colors.white)
          : null,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(date);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Jucer ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('dd.MM. HH:mm').format(date);
    }
  }
}
