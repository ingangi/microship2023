import 'package:flutter/material.dart';
import 'package:microship2023/config.dart';
import 'global.dart';

class Configer extends StatefulWidget {
  const Configer({Key? key}) : super(key: key);

  @override
  State<Configer> createState() => _ConfigerState();
}

class _ConfigerState extends State<Configer> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final TextEditingController _regTimerController = TextEditingController();
  bool transportTCP = true;
  bool transportUDP = false;
  bool transportTLS = false;

  void _applyChanges() {
    print("apply changes, desc: ${_descController.text}");
    print("apply changes, domain: ${_domainController.text}");
    print("apply changes, name: ${_nameController.text}");
    print("apply changes, passwd: ${_pswdController.text}");
    print("apply changes, regtimer: ${_regTimerController.text}");
    print("apply changes, transportTCP: $transportTCP");
    print("apply changes, transportUDP: $transportUDP");
    print("apply changes, transportTLS: $transportTLS");
    Config newConfig = Config();
    newConfig.accounts = [];
    newConfig.accounts!.add(Account(
        userName: _nameController.text,
        passWord: _pswdController.text,
        domain: _domainController.text,
        desc: _descController.text));
    newConfig.registerTimer = int.parse(_regTimerController.text);
    newConfig.transport = transportTCP
        ? Transport.tcp
        : (transportUDP ? Transport.udp : Transport.tls);
    if (Global().config!.merge(newConfig)) {
      Global().saveToPreference();
      print("config changed!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    Global().registerCallback("Configer", () {
      setState(() {
        _descController.text = Global().currentAccount()!.desc!;
        _domainController.text = Global().currentAccount()!.domain!;
        _nameController.text = Global().currentAccount()!.userName!;
        _pswdController.text = Global().currentAccount()!.passWord!;
        _regTimerController.text = Global().config!.registerTimer.toString();
        transportTCP = Global().config!.transport == Transport.tcp;
        transportUDP = Global().config!.transport == Transport.udp;
        transportTLS = Global().config!.transport == Transport.tls;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configer"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Text("Describe:"),
              Expanded(
                child: TextFormField(
                  readOnly: false,
                  controller: _descController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text("Domain:"),
              Expanded(
                child: TextFormField(
                  readOnly: false,
                  controller: _domainController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text("UserName:"),
              Expanded(
                child: TextFormField(
                  readOnly: false,
                  controller: _nameController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text("Password:"),
              Expanded(
                child: TextFormField(
                  readOnly: false,
                  controller: _pswdController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              )
            ],
          ),
          const Divider(
            height: 10.0,
            color: Colors.blueGrey,
            indent: 50,
            endIndent: 50,
          ),
          Row(
            children: [
              const Text("Register Every:"),
              Expanded(
                child: TextFormField(
                  readOnly: false,
                  controller: _regTimerController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              const Text("Seconds"),
            ],
          ),
          GridView(
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(30.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              // mainAxisSpacing: 15,
              // crossAxisSpacing: 15,
            ),
            children: [
              const Text("SIP Transport:"),
              Checkbox(
                value: transportTCP,
                activeColor: Colors.blue,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      transportTCP = true;
                      transportUDP = false;
                      transportTLS = false;
                    });
                  }
                  print("checkbox tcp value change to $value");
                },
              ),
              const Text("TCP"),
              Container(),
              Checkbox(
                value: transportUDP,
                activeColor: Colors.blue,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      transportUDP = true;
                      transportTCP = false;
                      transportTLS = false;
                    });
                  }
                  print("checkbox udp value change to $value");
                },
              ),
              const Text("UDP"),
              Container(),
              Checkbox(
                value: transportTLS,
                activeColor: Colors.blue,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      transportTLS = true;
                      transportUDP = false;
                      transportTCP = false;
                    });
                  }
                  print("checkbox tls value change to $value");
                },
              ),
              const Text("TLS"),
            ],
          ),
        ],
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          heroTag: "btnCancel",
          onPressed: () {
            print("Configer cancel pressed.");
            Navigator.popAndPushNamed(context, '/dialer',
                arguments: 'configer_canceld');
          },
          tooltip: 'Cancel, will ignore any changes you made',
          child: const Icon(Icons.cancel),
        ),
        FloatingActionButton(
          heroTag: "btnOK",
          onPressed: () {
            print("Configer OK pressed.");
            _applyChanges();
            Navigator.popAndPushNamed(context, '/dialer',
                arguments: 'configer_applied');
          },
          tooltip: 'OK, will apply changes you made',
          child: const Icon(Icons.circle),
        )
      ],
    );
  }
}
