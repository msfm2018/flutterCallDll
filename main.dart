import 'dart:convert'; // for JSON decoding
import 'dart:ffi';
import 'dart:io'; // for Platform.isWindows
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'dart:ffi' as ffi;

typedef GetStartMenuAppsC = Pointer<Utf16> Function();
typedef GetStartMenuAppsDart = Pointer<Utf16> Function();

// extern "C" __declspec(dllexport) const wchar_t* GetStartMenuApps()

// typedef GetExeIconC = Pointer<Uint8> Function(Pointer<Utf16> exePath, Pointer<Int32> size);
// typedef GetExeIconDart = Pointer<Uint8> Function(Pointer<Utf16> exePath, Pointer<Int32> size);

late DynamicLibrary _dylib;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> _iconCache = {};
  List<Map<String, String>> apps = [];
  // late DynamicLibrary _dylib;
  @override
  void initState() {
    super.initState();
    fetchStartMenuApps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchStartMenuApps() async {
    _dylib = Platform.isWindows
        ? DynamicLibrary.open('assets/applist.dll') // Replace with your DLL path
        : DynamicLibrary.process();

    final getStartMenuApps = _dylib.lookupFunction<GetStartMenuAppsC, GetStartMenuAppsDart>('GetStartMenuApps');

    final Pointer<Utf16> resultPointer = getStartMenuApps();

    String result1 = resultPointer.toDartString();

    List<dynamic> jsonList = jsonDecode(result1);

    setState(() {
      apps = jsonList
          .map((json) => {
                'name': json['name'] as String, // Cast to String
                'path': json['path'] as String, // Cast to String
              })
          .toList();
    });
  }

  final List<Map<String, String>> users = [
    {'name': 'John Doe', 'avatar': 'https://www.example.com/avatar1.png'},
    {'name': 'Jane Smith', 'avatar': 'https://www.example.com/avatar2.png'},
    {'name': 'Bob Johnson', 'avatar': 'https://www.example.com/avatar3.png'},
    {'name': 'Alice Brown', 'avatar': 'https://www.example.com/avatar4.png'},
    {'name': 'Charlie Davis', 'avatar': 'https://www.example.com/avatar5.png'},
    // Add more users as needed
  ];

  bool isLeftPanelVisible = true;
  void runExecutable(String name) async {
    String executablePath = name;

    // 启动程序并捕获输出
    Process process = await Process.start(executablePath, []);

    // 捕获标准输出
    process.stdout.transform(utf8.decoder).listen((data) {});

    // 捕获标准错误
    process.stderr.transform(utf8.decoder).listen((data) {});

    // 等待进程退出并获取退出代码
    await process.exitCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Layout Example'),
      ),
      body: Row(
        children: [
          // Left side: Scrollable ListView with Avatar and Name
          if (isLeftPanelVisible)
            Container(
                width: 200,
                child: ListView.builder(
                  itemCount: apps.length, // 假设 apps 是一个包含程序信息的列表
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(apps[index]['name']!), // 显示程序名称
                      subtitle: Text(apps[index]['path']!), // 显示程序路径
                      onTap: () {
                        runExecutable(apps[index]['path']!); // 点击运行程序
                      },
                    );
                  },
                )),

          // Right side: Two panels
          Expanded(
            child: Column(
              children: [
                // Upper panel with scrollable list
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.blue[100],
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the vertical padding for spacing
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(users[index]['avatar']!),
                            ),
                            title: Text(users[index]['name']!),
                            subtitle: Text('Additional info for ${users[index]['name']}'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('User Tapped'),
                                  content: Text('You tapped ${users[index]['name']}'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Lower panel with toggle button
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lower Panel',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLeftPanelVisible = !isLeftPanelVisible;
                            });
                          },
                          child: Text(isLeftPanelVisible ? 'Hide Left Panel' : 'Show Left Panel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
