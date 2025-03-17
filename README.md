# README - 編譯與執行指南

## 環境需求
- Linux 作業系統
- GNU Compiler Collection (GCC)
- Flex (Lex)
- Bison (Yacc)
- GNAT (Ada 編譯器)
- Smalltalk 編譯器（如 GNU Smalltalk）

## 安裝必要工具
在終端機執行以下指令安裝必要的編譯工具：

```sh
sudo apt update
sudo apt install gcc flex bison gnat gnu-smalltalk
```

## 編譯與執行方式

### 1. 編譯 Ada 程式 (`test1.ada`)
```sh
gnatmake test1.ada -o test1
./test1
```

### 2. 編譯 Lex & Yacc 程式 (`lex.l`, `lex.yy.c`)
```sh
flex lex.l
bison -d parser.y
gcc -o scanner lex.yy.c parser.tab.c -lfl
./scanner
```

### 3. 執行 Smalltalk 程式 (`*.st`)
```sh
gst example.st
```

### 4. 編譯與執行 C 程式 (`lex.yy.c`)
```sh
gcc -o scanner lex.yy.c -lfl
./scanner
```

## 目錄與檔案說明
| 檔案名稱      | 說明 |
|--------------|------|
| `test1.ada`  | Ada 程式碼 |
| `source.l`   | Lex (Flex) 描述檔 |
| `sigma.st`   | Smalltalk 程式碼 |
| `scanner`    | 可執行的 Scanner |
| `lex.yy.c`   | 由 Flex 生成的 C 程式碼 |
| `lex.l`      | Lex (Flex) 語法檔案 |
| `HelloWorld.st` | Smalltalk Hello World |
| `fib.st`     | Smalltalk 費氏數列程式 |
| `example.st` | Smalltalk 範例程式 |

## 其他說明
- 確保您的程式碼符合語法規則，避免編譯錯誤。
- 如果遇到權限問題，可使用 `chmod +x <檔案名稱>` 給予執行權限。
- 若有額外需求，請檢查 `man` 手冊，例如：`man flex`。



