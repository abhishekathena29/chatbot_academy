import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiApi with ChangeNotifier {
  static const geminiKey = "";
  final List<Map<String, dynamic>> chat = [];

  Future<String> chatWithGemini() async {
    try {
      final res = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "system_instruction": {
            "parts": {
              "text":
                  "You are great cook so give great receipe details or any cooking detail whenver I ask."
            }
          },
          "contents": chat,
        }),
      );

      if (res.statusCode == 200) {
        String val = jsonDecode(res.body)['candidates'][0]['content']['parts']
            [0]['text'];
        // content = content.trim();
        // print(res.body);
        chat.add({
          "role": "model",
          "parts": [
            {"text": val},
          ]
        });
        notifyListeners();
        return res.body;

        // return content;
      }
      // print('internal error');
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
