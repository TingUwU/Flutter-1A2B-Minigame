import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1A2B 森林探險',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        // 主題色改為湖水綠，更搭配森林背景
        primarySwatch: Colors.teal, 
        fontFamily: 'Courier',
      ),
      home: const StartScreen(), 
    );
  }
}

// ==========================================
// 畫面一：初始設定頁面 (森林版)
// ==========================================
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _selectedDigits = 4; 
  int _selectedMaxGuesses = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 1. 滿版的森林背景
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/forest_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          // 2. 半透明的毛玻璃選單卡片，確保文字清晰
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 讓卡片高度貼合內容
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🐾 1A2B 森林探險',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 40),
                
                const Text('請選擇遊戲位數：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: _selectedDigits,
                  style: const TextStyle(fontSize: 22, color: Colors.teal, fontWeight: FontWeight.bold),
                  items: List.generate(5, (index) => DropdownMenuItem(
                    value: index + 4, 
                    child: Text('${index + 4} 位數')
                  )),
                  onChanged: (val) => setState(() => _selectedDigits = val!),
                ),
                const SizedBox(height: 25),

                const Text('請選擇挑戰次數限制：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: _selectedMaxGuesses,
                  style: const TextStyle(fontSize: 22, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10 次 (魔鬼)')),
                    DropdownMenuItem(value: 15, child: Text('15 次 (困難)')),
                    DropdownMenuItem(value: 20, child: Text('20 次 (普通)')),
                    DropdownMenuItem(value: 999, child: Text('無限次 (休閒)')),
                  ],
                  onChanged: (val) => setState(() => _selectedMaxGuesses = val!),
                ),
                
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BullsAndCowsGame(
                          digitLength: _selectedDigits,
                          maxGuesses: _selectedMaxGuesses,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('出發探險！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 畫面二：遊戲主畫面 (森林版)
// ==========================================
class BullsAndCowsGame extends StatefulWidget {
  final int digitLength; 
  final int maxGuesses; 

  const BullsAndCowsGame({super.key, required this.digitLength, required this.maxGuesses});

  @override
  State<BullsAndCowsGame> createState() => _BullsAndCowsGameState();
}

class _BullsAndCowsGameState extends State<BullsAndCowsGame> {
  late String _secretCode;
  final TextEditingController _guessController = TextEditingController();
  final List<String> _guessHistory = [];
  late ConfettiController _confettiController;
  
  double _rabbitProgress = 0.0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _generateSecretCode();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _guessController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _generateSecretCode() {
    List<int> digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    digits.shuffle();
    _secretCode = digits.take(widget.digitLength).join('');
    print("偷偷告訴你，答案是: $_secretCode"); 
  }

  void _checkGuess() {
    if (_isGameOver) return;

    String guess = _guessController.text;
    if (guess.length != widget.digitLength) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('請輸入完整的 ${widget.digitLength} 位數字！')));
      return;
    }
    if (guess.split('').toSet().length != widget.digitLength) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('數字不能重複喔！請重新輸入。')));
      return;
    }

    int a = 0, b = 0;
    for (int i = 0; i < widget.digitLength; i++) {
      if (guess[i] == _secretCode[i]) {
        a++; 
      } else if (_secretCode.contains(guess[i])) {
        b++; 
      }
    }

    setState(() {
      _guessHistory.insert(0, '第 ${_guessHistory.length + 1} 步：$guess  ➡️  ${a}A${b}B');
      _guessController.clear();
      _rabbitProgress = a / widget.digitLength;

      if (a == widget.digitLength) {
        _isGameOver = true;
        _playWinVideoSequence(); 
      } else if (_guessHistory.length >= widget.maxGuesses) {
        _isGameOver = true;
        _showEndDialog(isWin: false);
      }
    });
  }

  void _giveUp() {
    setState(() {
      _isGameOver = true;
      _showEndDialog(isWin: false, isGiveUp: true);
    });
  }

  void _showEndDialog({required bool isWin, bool isGiveUp = false}) {
    String title = isWin ? '🎉 恭喜過關！' : (isGiveUp ? '🏳️ 放棄挑戰' : '💀 挑戰失敗');
    String content = isWin 
        ? '兔子成功吃到了紅蘿蔔！\n總共花了 ${_guessHistory.length} 步。' 
        : '次數用盡或已放棄！\n正確答案是：$_secretCode';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(content, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: const Text('回到森林入口', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRabbit() {
    return Image.asset('assets/rabbit.png', width: 50, height: 50);
  }

  @override
  Widget build(BuildContext context) {
    String remainingText = widget.maxGuesses > 100 ? "無限" : "${widget.maxGuesses - _guessHistory.length}";
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.digitLength} 位數挑戰 (剩餘 $remainingText 次)'),
        backgroundColor: Colors.teal.withOpacity(0.95), // 微透明的綠色導覽列
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. 滿版森林背景
          Positioned.fill(child: Image.asset('assets/forest_bg.png', fit: BoxFit.cover)),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 2. 升級版軌道 (加上半透明底色保護)
                const SizedBox(height: 10),
                Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6), // 軌道專屬的保護色，讓黑線不被吃掉
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 25, 
                        left: 20,   
                        right: 35,  
                        child: Container(height: 2, color: Colors.black87),
                      ),
                      ...List.generate(widget.digitLength - 1, (index) {
                        int aCount = index + 1;
                        double progress = aCount / widget.digitLength; 
                        return Positioned(
                          bottom: 6, 
                          left: (progress * (MediaQuery.of(context).size.width - 90)) + 20, 
                          child: Column(
                            children: [
                              Container(width: 2, height: 8, color: Colors.black87), 
                              const SizedBox(height: 2),
                              Text('${aCount}A', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal)),
                            ],
                          ),
                        );
                      }),
                      const Positioned(
                        bottom: 12,
                        right: 10,
                        child: Text('🥕', style: TextStyle(fontSize: 30)),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                        bottom: 27, // 精準踩在線上
                        left: _rabbitProgress * (MediaQuery.of(context).size.width - 90),
                        child: _buildRabbit(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // 3. 輸入框與按鈕
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _guessController,
                        keyboardType: TextInputType.number,
                        maxLength: widget.digitLength,
                        enabled: !_isGameOver, 
                        decoration: InputDecoration(
                          hintText: '輸入 ${widget.digitLength} 個數字...',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.95), 
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          counterText: '', 
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 55, 
                      child: ElevatedButton(
                        onPressed: _isGameOver ? null : _checkGuess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, 
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 3,
                        ),
                        child: const Text('猜！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 4. 歷史紀錄方塊
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85), 
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.15),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, color: Colors.teal, size: 22),
                              SizedBox(width: 8),
                              Text('探險足跡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), 
                            itemCount: _guessHistory.length,
                            itemBuilder: (context, index) {
                              bool isLatest = index == 0; 
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // 讓紀錄置中對齊，畫面更平衡
                                  children: [
                                    Text(
                                      _guessHistory[index],
                                      style: TextStyle(
                                        fontSize: isLatest ? 22 : 18, 
                                        color: isLatest ? Colors.teal : Colors.black87, 
                                        fontWeight: isLatest ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),

                // 5. 放棄按鈕
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isGameOver ? null : _giveUp,
                    icon: const Icon(Icons.visibility),
                    label: const Text('放棄挑戰，看答案', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.white.withOpacity(0.9), 
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 6. 彩帶特效
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 6, 
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 🎬 勝利動畫播放流程與組件 (修復版)
// ==========================================

extension WinVideoExtension on _BullsAndCowsGameState {
  void _playWinVideoSequence() async {
    await showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const WinVideoPlayerDialog(),
    );

    // 💡 加上安全機制：確保對話框關閉後，當前畫面還存活著，才繼續執行
    if (!mounted) return;

    _confettiController.play();
    _showEndDialog(isWin: true);
  }
}

class WinVideoPlayerDialog extends StatefulWidget {
  const WinVideoPlayerDialog({super.key});

  @override
  State<WinVideoPlayerDialog> createState() => _WinVideoPlayerDialogState();
}

class _WinVideoPlayerDialogState extends State<WinVideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPopped = false; // 🔒 關鍵防呆開關：記錄「是否已經關閉過」

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/rabbit_win.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();

        _controller.addListener(() {
          // 💡 嚴格檢查：影片有長度、進度到底了，而且「還沒被關閉過」
          if (_controller.value.isInitialized &&
              _controller.value.duration > Duration.zero &&
              _controller.value.position >= _controller.value.duration &&
              !_isPopped) {
            
            _isPopped = true; // 馬上鎖上開關，拒絕後續的重複觸發
            
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, 
      elevation: 0,
      child: _isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), 
                child: VideoPlayer(_controller),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.white), 
            ),
    );
  }
}