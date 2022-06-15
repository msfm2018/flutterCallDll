#include "pch.h"
#include "b.h"
#include <crtdbg.h>



int show(char* str)
{

	return 0;
}

 DllExport void func()
{
	printf("ok\n");
	MessageBox(0, L"c result ", L"def", 0);

}


 DllExport const char* getName()
 {
	 return "My name is ´ó¸ç´ó";
 }

 DllExport void cPrint(char* str)
 {
	 //UTF8->char*
	 WCHAR* strA;
	 
	 int i = MultiByteToWideChar(CP_UTF8, 0, (char*)str, -1, NULL, 0);
	 strA = new WCHAR[i];
	 MultiByteToWideChar(CP_UTF8, 0, (char*)str, -1, strA, i);
	 i = WideCharToMultiByte(CP_ACP, 0, strA, -1, NULL, 0, NULL, NULL);
	 char* strB = new char[i];
	 WideCharToMultiByte(CP_ACP, 0, strA, -1, strB, i, NULL, NULL);
	 OutputDebugStringW(strA);

	 delete[]strA;
	 delete[]strB;
 }


 DllExport void  cPrint1(char* str) {
	 printf("[CPP]: %s", str);
	
 }

 DllExport char* rstring(char* str)
 {
	 //
	 return str;
	
 }
