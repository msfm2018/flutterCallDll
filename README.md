# dllFlutterCall
 
 
 dependencies:
 
  ffi: ^2.0.0
  
  path: ^1.8.0
  
  ffigen: ^6.0.1



ffigen:

  name: NativeLibrary
  
  description: Bindings to `primitives_library/primitives.h`.
  
  output: 'generated_bindings.dart'
  
  headers:
  
    entry-points:
    
      - 'primitives_library/primitives.h'
 
 
ffigen使用

dart run ffigen.
 
gcc --share print.c -o print.dll


调用
  libraryPath = path.join(Directory.current.path, 'primitives_library', 'v.dll');
  
  var open = DynamicLibrary.open(libraryPath);
  
  num ix = cf.NativeLibrary(open).sum(1, 33);

![image](https://github.com/msfm2018/dllFlutterCall/blob/main/index.png)
