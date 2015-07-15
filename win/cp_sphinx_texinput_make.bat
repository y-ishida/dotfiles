@rem 管理者権限でバッチファイルを実行すると、
@rem カレントディレクトリがシステムディレクトリで実行されてしまう。
@rem そこで、まずカレントディレクトリを移動しないと想定どおりの動作とならないので注意！
cd /d %~dp0

@rem SphinxInstaller-1.2.3.20141115-py2.7-win32.zip では下記パスでOK
copy sphinx_texinput_make.bat "%ProgramFiles(x86)%\Sphinx\eggs\sphinx-1.2.3-py2.7.egg\sphinx\texinputs\make.bat"

