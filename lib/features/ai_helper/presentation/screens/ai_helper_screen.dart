import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';

class AiHelperScreen extends StatefulWidget {
  const AiHelperScreen({super.key});

  @override
  State<AiHelperScreen> createState() => _AiHelperScreenState();
}

class _AiHelperScreenState extends State<AiHelperScreen> {
  bool _isChatMode = false;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.5-flash');
  }

  void _startChat([String? initialPrompt]) {
    setState(() {
      _isChatMode = true;
      if (_messages.isEmpty) {
        _messages.add({'role': 'ai', 'text': "Hi! I'm your Fandom AI Helper. What would you like to know?"});
      }
    });
    if (initialPrompt != null) {
      _controller.text = initialPrompt;
      _sendMessage();
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final prompt = [Content.text(text)];
      final response = await _model.generateContent(prompt);
      
      setState(() {
        _messages.add({'role': 'ai', 'text': response.text ?? 'No response.'});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'Oops, something went wrong: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A), // Dark background matching the image
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_isChatMode) {
              setState(() => _isChatMode = false);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'AI Fan Helper',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: _isChatMode ? _buildChatView() : _buildDashboardView(),
      ),
    );
  }

  Widget _buildDashboardView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 1),
          // AI Avatar
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 80,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 32),
          // Greeting Text
          const Text(
            "Hi! I'm your Fandom AI Helper",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ask me anything about your\nfavourite fandoms!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 48),
          // Buttons
          _buildPrimaryButton(
            title: 'Ask a question',
            onPressed: _startChat,
          ),
          const SizedBox(height: 16),
          _buildSecondaryButton(
            title: 'Suggested Questions',
            onPressed: () {
              _startChat('Can you suggest some popular questions about fandoms?');
            },
          ),
          const SizedBox(height: 16),
          _buildSecondaryButton(
            title: 'FAQ',
            onPressed: () {
              _startChat('What are the most frequently asked questions here?');
            },
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF6C4DFF) : const Color(0xFF1A1D2D),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Text(
                    msg['text'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your question...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF1A1D2D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF6C4DFF),
                onPressed: _isLoading ? null : _sendMessage,
                child: const Icon(Icons.send, color: Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({required String title, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C4DFF), // Purple color
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({required String title, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A1D2D), // Slightly lighter dark background
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
