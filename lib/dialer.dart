import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:audioplayer/audioplayer.dart';
import 'global.dart';

class DialerPage extends StatefulWidget {
  const DialerPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DialerState();
}

class _NumberButton extends ElevatedButton {
  _NumberButton({Key? key, required this.txt, required this.sink})
      : super(
          key: key,
          onPressed: () => sink._onButtonPressed(txt),
          child: Text(
            txt,
            style: const TextStyle(fontSize: 30),
          ),
          style: ElevatedButton.styleFrom(
            // maximumSize: Size.square(35),
            primary: Colors.teal,
            onPrimary: Colors.white,
            shape: const CircleBorder(
                //side: BorderSide(color: Colors.pink),
                ),
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 40, fontStyle: FontStyle.italic),
          ),
        );
  Widget withMargin(double margin) {
    return Container(
      child: this,
      margin: EdgeInsets.all(margin),
    );
  }

  final String txt;
  final _DialerState sink;
}

class _DialerState extends State<DialerPage> {
  String dialString = "";
  String state = "Input"; // Input / Calling ...
  final TextEditingController _controller = TextEditingController();
  // AudioPlayer _audioPlayer = AudioPlayer();
  // AudioPlayer audioPlugin = AudioPlayer();
  final AudioCache _audioPlayer = AudioCache();

  bool _inputFilter(String s) {
    for (int i = 0; i < s.length; i++) {
      if (s.codeUnitAt(i) >= 48 && s.codeUnitAt(i) <= 57 ||
          s[i] == "*" ||
          s[i] == "#" ||
          s[i] == "," ||
          s[i] == ":" ||
          s[i] == "@") {
      } else {
        return false;
      }
    }
    return true;
  }

  Future<void> playDTMFTone(String btn) async {
    print("playDTMFTone $btn");
    // Global().saveToPreference(); //test!!
    if (btn == "*") {
      btn = "star";
    } else if (btn == "#") {
      btn = "pound";
    }
    _audioPlayer.play("DTMF-$btn-3.wav", mode: PlayerMode.LOW_LATENCY);
  }

  Future<void> playBeep() async {
    print("playBeep");
    _audioPlayer.play("invalid.mp3", mode: PlayerMode.LOW_LATENCY);
  }

  @override
  void initState() {
    super.initState();
    Global().registerCallback("Dialer", () {
      setState(
        () {},
      );
    });
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      String textNumbers = "";
      var oldSize = dialString.length;
      for (int i = 0; i < text.length; i++) {
        if (_inputFilter(text[i])) {
          textNumbers += text[i];
          if (textNumbers.length > oldSize) {
            playDTMFTone(text[i]);
          }
          // print("${text[i]} (${text.codeUnitAt(i)}) is leagle");
        } else {
          playBeep();
          print("${text[i]} is inleagle, beep!");
        }
      }
      print("_controller listener after filter:$text");
      setState(() {
        dialString = textNumbers;
        if (textNumbers != text) _controller.text = dialString;
      });
      // _controller.value = _controller.value.copyWith(
      //   text: text.substring(0, 3),
      //   selection:
      //       TextSelection(baseOffset: text.length, extentOffset: text.length),
      //   composing: TextRange.empty,
      // );
    });
  }

  @override
  void dispose() {
    Global().unregisterCallback("Dialer");
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed(String v) {
    if (_inputFilter(v)) {
      playDTMFTone(v);
      setState(() {
        dialString += v;
        _controller.text = dialString;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const String keysList = "123456789*0#";
    var routerParam = ModalRoute.of(context)?.settings.arguments;
    // state = Global().sip.isInProgress() ? 'Calling' : 'Input';
    state = 'Input';
    print("dialer build with routerParam: ${routerParam}");
    return Scaffold(
      appBar: AppBar(title: const Text('Dialer')),
      body: KeyboardListener(
        autofocus: true,
        // onKeyEvent: (value) {
        //   if (value.character != null) {
        //     print("onKeyEvent 0: ${value.character}");
        //     _onButtonPressed(value.character ?? "");
        //   }
        // },
        focusNode: FocusNode(),
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("Config button clicked!");
                        Navigator.popAndPushNamed(context, '/configer');
                      },
                      child: Text(
                        "<< ${Global().currentAccount()?.desc}",
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                        primary: const Color.fromARGB(255, 30, 135, 233),
                        onPrimary: Colors.white,
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color: () {
                        return Colors.green;
                        // return Global().sip.registered()
                        //     ? Colors.green
                        //     : Colors.grey;
                      }(),
                      size: 18.0,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  readOnly: state == "Calling",
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Characters allowed: 0-9 * # , : @",
                  ),
                ),
              ),
              Offstage(
                offstage: state != 'Calling', //callingOffstage,
                child: Column(
                  children: [
                    const Text(
                      "state",
                      // "$state(${Global().sip.currentCall?.state.toString()}): $dialString",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Text("00:56"),
                  ],
                ),
              ),
              const SizedBox.square(
                dimension: 10.0,
              ),
              GridView(
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(30.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                children: keysList
                    .split("")
                    .map((e) => _NumberButton(txt: e, sink: this))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (dialString.isNotEmpty) {
                          dialString =
                              dialString.substring(0, dialString.length - 1);
                          _controller.text = dialString;
                        }
                      });
                    },
                    child: const Icon(Icons.backspace),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(100),
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 50.0,
                  ),
                  () {
                    var nextIcon = const Icon(Icons.disabled_by_default);
                    var nextColor =
                        MaterialStateProperty.all<Color>(Colors.green);
                    if (state == 'Input') {
                      nextIcon = const Icon(Icons.dialer_sip);
                      nextColor =
                          MaterialStateProperty.all<Color>(Colors.green);
                    } else if (state == "Calling") {
                      nextIcon = const Icon(Icons.phone_disabled);
                      nextColor = MaterialStateProperty.all<Color>(Colors.red);
                    }
                    return ElevatedButton(
                        onPressed: () {
                          if (state == "Input") {
                            // Global().sip.call(dialString);
                          } else {
                            // Global().sip.hangup();
                          }
                        },
                        child: nextIcon,
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100)),
                          backgroundColor: nextColor,
                        ));
                  }(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
