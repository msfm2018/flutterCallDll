import 'dart:ffi' as ffi;
import 'package:flutter/material.dart';
import 'package:call/call.dart';
import 'package:ffi/ffi.dart';

// c定义
typedef CFuncNative = ffi.Void Function();
typedef CFuncDart = void Function();
//c 定义
//c 输入参数
// DllExport void cPrint(char* str);
typedef CFuncNativePara = ffi.Void Function(ffi.Pointer<ffi.Int8>);
typedef CFuncDartPara = void Function(ffi.Pointer<ffi.Int8>);
//c 返回数据

//  DllExport char* rstring(char* str)
typedef CFuncNativeR = ffi.Pointer<ffi.Int8> Function(ffi.Pointer<ffi.Int8>);
typedef CFuncDartR = ffi.Pointer<ffi.Int8> Function(ffi.Pointer<ffi.Int8>);
//DllExport char* getName(); 返回数据
typedef CFuncNativeR2 = ffi.Pointer<ffi.Int8> Function();
typedef CFuncDartR2 = ffi.Pointer<ffi.Int8> Function();
//------------------------------------
typedef Native_greetingString = ffi.Pointer<ffi.Int8> Function();

typedef FFI_greetingString = ffi.Pointer<ffi.Int8> Function();
//delphi 定义
typedef DelphiApi = ffi.Void Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Int8>);
typedef DelphiLocal = void Function(int, int, ffi.Pointer<ffi.Int8>);

//
// function retString(i, j: Integer; info: PansiChar):pansichar; stdcall;
typedef DelphiApiResultValue = ffi.Pointer<ffi.Int8> Function(ffi.Int8, ffi.Int8, ffi.Pointer<ffi.Int8>);
typedef DelphiApiLocalResultValue = ffi.Pointer<ffi.Int8> Function(int, int, ffi.Pointer<ffi.Int8>);

void main() {
  runApp(const MyApp());
}

late ffi.DynamicLibrary globalLibray;

Future<ffi.DynamicLibrary> startDelphiApp() async {
  // 调起delphi form
  var delphiDll = getDyLibModule('assets/abc.dll');
  return delphiDll;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  c调用
    var cdll = getDyLibModule('assets/test1.dll');
    var messageBox = cdll.lookupFunction<CFuncNative, CFuncDart>('func');
    messageBox();
//c调用
    var cprint = cdll.lookupFunction<CFuncNativePara, CFuncDartPara>('cPrint1');
    String start = 'Hello World!你好来自flutter';
    cprint(start.toNativeUtf8().cast<ffi.Int8>());

//c调用 返回数据
    var rstring = cdll.lookupFunction<CFuncNativeR, CFuncDartR>('rstring');
    String start1 = 'C!你好来自flutter';
    var vvvv = rstring(start1.toNativeUtf8().cast<ffi.Int8>());

    print(vvvv.cast<Utf8>().toDartString());

    // //c调用 返回数据
    var rstring2 = cdll.lookupFunction<CFuncNativeR2, CFuncDartR2>('getName');

    var vvvv2 = rstring2();

    print(vvvv2.toString());
    // print(vvvv2.cast<Utf8>().toDartString());

    // late final _getNamePtr = cdll.lookup<ffi.NativeFunction<ffi.Pointer<ffi.Int8> Function()>>('getName');
    // late final _getName = _getNamePtr.asFunction<ffi.Pointer<ffi.Int8> Function()>();
    // // print("[Dart]: 有返回值 -> " + _getName().cast<Utf8>().toDartString());
    // print("[Dart]: 有返回值 -> " + _getName().toString());

//查找目标函数
    FFI_greetingString greetingFunc = cdll.lookupFunction<Native_greetingString, FFI_greetingString>("greetString");

//调用 greetString 函数，并将结果转为 Dart String.
    ffi.Pointer<ffi.Int8> result = greetingFunc();
    String greeting = result.cast<Utf8>().toDartString();

//打印结果
    print("greeting=$greeting");

//c调用 返回数据

    //调用delphi 传递参数
    //调起delphi form
    startDelphiApp().then(
      (value) {
        globalLibray = value;
        var setCaption = value.lookupFunction<DelphiApi, DelphiLocal>('setCaption');
        String start = 'Hello World!你好来自flutter';
        setCaption(7, 2, start.toNativeUtf8().cast<ffi.Int8>());
      },
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String txt = '准备';
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  var delphiadd1 = globalLibray.lookupFunction<DelphiApiResultValue, DelphiApiLocalResultValue>('retString');
                  String start1 = '返回信息：：Hello World!你好来自flutter';
                  var rstring = delphiadd1(7, 2, start1.toNativeUtf8().cast<ffi.Int8>());
                  setState(() {
                    txt = rstring.cast<Utf8>().toDartString();
                  });

                  // print(txt);
                  //  print(rstring);
                },
                child: Text('调用动态库数据')),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter ',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$txt ',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
