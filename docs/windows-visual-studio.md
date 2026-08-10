# Visual Studio 简记

## 工程文件

- `.sln` 描述 solution 及其项目关系。
- `.vcxproj` 描述单个 Visual C++ 项目的构建配置、源文件与依赖。

背景资料：<https://stackoverflow.com/questions/7133796/what-are-sln-and-vcproj-files-and-what-do-they-contain>

## 编辑体验

- 在 Extensions 中安装 Catppuccin 主题。
- 使用 VsVim 提供 Vim 键位。
- 字体在 Tools -> Options 中调整。

## MSBuild

在开发者 PowerShell 或已经初始化 Visual Studio 环境变量的终端中运行：

```powershell
msbuild .\01-ErrorShow.vcxproj `
  /t:ClangTidy `
  -t:Rebuild `
  -p:Configuration=Release `
  -p:Platform=X64
```

该流程可以生成 `compile_commands.json`。Clang Power Tools 也提供类似功能，但此前使用体验
不稳定。

Visual Studio 2022 Community 的 MSBuild 通常位于：

```text
C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe
```

参考：

- <https://learn.microsoft.com/en-us/visualstudio/msbuild/walkthrough-using-msbuild?view=vs-2022>
- <https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2022>
- <https://stackoverflow.com/questions/39798321/generate-clang-compilation-database-for-a-visual-studio-project>
- <https://stackoverflow.com/questions/6319274/how-do-i-run-msbuild-from-the-command-line-using-windows-sdk-7-1>
