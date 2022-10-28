import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // useMaterial3: true
      ),
      home: const JankenPage(),
    );
  }
}

class JankenPage extends StatefulWidget {
  const JankenPage({Key? key}) : super(key: key);

  @override
  _JankenPageState createState() => _JankenPageState();
}

class _JankenPageState extends State<JankenPage> {
  //自分の手
  String myHand = '✊';
  // コンピューターの手
  String computerHand = '✊';
  //勝敗結果を表示する文字列
  String result = "";
  // じゃんけんの回数
  int jankenCount = 0;
  //勝った回数カウント
  int victoryCount = 0;

  // 関数の定義も、State の {} の中で行います。
  void selectHand(String selectedHand) {
    setState(() {
      myHand = selectedHand; // myHand に 引数として受けとった selectedHand を代入します。
      generateComputerHand();
      judge();
      jankenCount ++;

      if(result == "勝ち") {
        victoryCount ++;
      }
    });
    if(jankenCount == 5) {
      _showResult();
    }
  }

  // コンピューターの手をランダムで決める
  void generateComputerHand() {
    Random().nextInt(3);
    // randomNumberに一時的に値を格納します。
    final randomNumber = Random().nextInt(3);
    computerHand = randomNumberToHand(randomNumber);
  }

  // 生成されたランダムな数字を ✊, ✌️, 🖐 に変換する
  String randomNumberToHand(int randomNumber) {
    // () のなかには条件となる値を書きます。
    switch (randomNumber) {
      case 0: // 入ってきた値がもし 0 だったら。
        return '✊'; // ✊を返す。
      case 1: // 入ってきた値がもし 1 だったら。
        return '✌️'; // ✌️を返す。
      case 2: // 入ってきた値がもし 2 だったら。
        return '✋'; // 🖐を返す。
      default: // 上で書いてきた以外の値が入ってきたら。
        return '✊'; // ✊を返す。（0, 1, 2 以外が入ることはないが念のため）
    }
  }

  Color returnResultColor(String result) {
    switch (result) {
      case "引き分け":
        return Colors.black;
      case "勝ち":
        return Colors.red;
      case "負け":
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  // 勝敗を判定する関数
  void judge() {
    // 引き分けの場合
    if (myHand == computerHand) {
      result = '引き分け';
      // 勝ちの場合
    } else if (myHand == '✊' && computerHand == '✌️' ||
        myHand == '✌️' && computerHand == '✋' ||
        myHand == '✋' && computerHand == '✊') {
      result = '勝ち';
      // 負けの場合
    } else {
      result = '負け';
    }
  }

  Future _showResult() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("結果"),
          content: Text("$victoryCount回\n勝ちました！"),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              child: Text("もどる"),
              onPressed: () {
                Navigator.pop(context);
                jankenCount = 0;
                victoryCount = 0;
                //ジャンケンの手をリセット
                myHand = '✊';
                computerHand = '✊';
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("じゃんけん")),
      body: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 20,vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 30),
                Text(
                  jankenCount.toString(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              result,
              style: TextStyle(
                  color: returnResultColor(result),
                  fontWeight: FontWeight.bold,
                  fontSize: 50
              ),
            ),
            const SizedBox(height: 100,),
            //computer hand
            Text(
              computerHand,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 100),
            //myhand
            Text(
              myHand,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //ぐー
                jankenButton(onPressed: () => selectHand("✊"), hand: "✊"),
                //ちょき
                jankenButton(onPressed: () => selectHand("✌️"), hand: "✌️"),
                //パー
                jankenButton(onPressed: () => selectHand("✋"), hand: "✋"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget jankenButton({required onPressed, required hand}) {
    return SizedBox(
      height: 80,
      width: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        child: Text(hand,style: const TextStyle(fontSize: 40),),
      ),
    );
  }
}