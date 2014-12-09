set CURRENT_PATH=%~dp0
rem set CURRENT_PATH=%CURRENT_PATH%:~0,-1%
set CLASSPATH=%CURRENT_PATH%\..\WEB-INF\lib\*;%CURRENT_PATH%\websocketchat-0.0.1-SNAPSHOT.jar

"%JAVA_HOME%\bin\java" -cp %CLASSPATH% org.lasti.websocketchat.App
