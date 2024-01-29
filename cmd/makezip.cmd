REM Create nested file structure and zip it
REM useful for creating Lambda deployment zip files
REM reference https://7-zip.opensource.jp/chm/cmdline/commands/add.htm
REM 1. create some data
mkdir TEST
cd TEST
echo > root.txt
mkdir nested
cd nested
echo > one.txt
echo > two.txt
echo > three.txt
REM 2. return to root directory
cd ..
REM 3. create the archive
7z a archive.zip .\nested\*
7z a archive.zip root.txt