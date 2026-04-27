# 🐾 1A2B 森林探險 (Forest Adventure)

<p align="center">
  <img width="1536" height="250" alt="concept" src="https://github.com/user-attachments/assets/2ee83aea-b45d-4604-ab39-a137a2218df8" />
</p>

> A cross-platform number guessing game built with Flutter. It combines complete Bulls and Cows game logic with a highly polished UI/UX, featuring frosted glass card designs, native video transitions, and confetti effects. Available on iOS and Android.

這是一款基於 Flutter 開發的經典 1A2B 猜數字遊戲。玩家將跟著可愛的探險兔深入森林，透過邏輯推理找出正確的密碼，成功過關還能解鎖專屬的吃紅蘿蔔動畫！🥕

## ✨ 遊戲特色 (Features)

* **🎯 經典核心玩法**：支援自訂 4~8 位數密碼長度，以及多種難度（挑戰次數）選擇，內建完整的防呆機制（防止重複數字與字數不足）。
* **🎨 精緻視覺體驗**：採用現代感十足的「毛玻璃 (Glassmorphism)」半透明卡片設計，確保在色彩豐富的森林背景下，文字依然清晰易讀。
* **🐰 動態進度回饋**：揚棄傳統文字進度條，改用「探險兔」在軌道上動態跳躍。刻度會根據玩家選擇的位數自動計算並精準對齊。
* **🎬 豐富過場動畫**：整合跨平台原生影片播放器，在成功通關時無縫銜接專屬的兔子動畫，並搭配華麗的 Confetti 粒子彩帶特效。
* **📱 雙平台完美適配**：支援 iOS 與 Android 雙系統，並客製化了雙平台的專屬 App Icon（包含 Android Adaptive Icons）與在地化中文名稱。

## 🛠️ 技術棧 (Tech Stack)

* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** Dart
* **Key Packages:**
  * `video_player`: 處理勝利過場動畫的非同步播放與進度監聽。
  * `confetti`: 實作過關時的彩帶噴發物理特效。
  * `flutter_launcher_icons`: 自動化生成與配置雙平台 App 圖示。

## 🚀 本地端執行 (Getting Started)

1. 確認已安裝 Flutter 開發環境。
2. 將此專案 Clone 到本地端：
   ```bash
   git clone [https://github.com/TingUwU/Flutter-1A2B-Minigame.git](https://github.com/TingUwU/Flutter-1A2B-Minigame.git)
   ```
3. 進入專案目錄並獲取套件
   ```bash
   cd Flutter-1A2B-Minigame
   flutter pub get
   ```
4. 啟動 iOS 或 Android 模擬器，執行專案：
   ```bash
   flutter run
   ```
