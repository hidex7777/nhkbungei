##### もろもろ設定
$bungei = '文芸選評'
# 46分×60秒録音
$recording_seconds = 46 * 60
# vlcのインストールディレクトリ
$vlcexe = 'C:\Program Files\VideoLAN\VLC\vlc.exe'
# らじるらじるでストリーム放送しているURL
$openurl = 'https://nhkradioakr1-i.akamaihd.net/hls/live/511633/1-r1/1-r1-01.m3u8'
# M4Aファイルを保存するディレクトリ
$destdir = 'E:\music\nhk-bungei\'

# 起動した日時
$date = Get-Date
$time = $date.ToString("HHmmss")
$yobi = [String]$date.ToString("dddd")

# 次回放送は？
# - 土曜11時05分～50分

function getNextCast{
  if ($yobi -eq "土曜日") {
    if ([int]$time -lt 110400) {
      # echo "次回は今日の昼"
      [DateTime]$val = (Get-Date -Hour 11 -Minute 04 -Second 30)
      return $val
    } else {
      # echo "次回は一週間後の土曜"
      [DateTime]$val = (Get-Date $date.AddDays(7) -Hour 11 -Minute 04 -Second 30)
      return $val
    }
  } elseif ($yobi -eq "日曜日") {
    # echo "次回は6日後の土曜"
    [DateTime]$val = (Get-Date $date.AddDays(6) -Hour 11 -Minute 04 -Second 30)
    return $val
  } elseif ($yobi -eq "月曜日") {
    # echo "次回は5日後の土曜"
    [DateTime]$val = (Get-Date $date.AddDays(5) -Hour 11 -Minute 04 -Second 30)
    return $val
  } elseif ($yobi -eq "火曜日") {
    # echo "次回は4日後の土曜"
    [DateTime]$val = (Get-Date $date.AddDays(4) -Hour 11 -Minute 04 -Second 30)
    return $val
  } elseif ($yobi -eq "水曜日") {
    # echo "次回は3日後の土曜"
    [DateTime]$val = (Get-Date $date.AddDays(3) -Hour 11 -Minute 04 -Second 30)
    return $val
  } elseif ($yobi -eq "木曜日") {
    # echo "次回は2日後の土曜"
    [DateTime]$val = (Get-Date $date.AddDays(2) -Hour 11 -Minute 04 -Second 30)
    return $val
  } elseif ($yobi -eq "金曜日") {
    # echo "次回は1日後の土曜"
    [DateTime]$val = (Get-Date $date.AddDays(1) -Hour 11 -Minute 04 -Second 30)
    return $val
  }
}

function getSleepSecond([DateTime]$nc){
  # 次回まで何秒なのか
  $ss = ([DateTime]$nc - $date).TotalSeconds
  return $ss
}

function startRec{
  Start-Process -FilePath $vlcexe -ArgumentList "-I dummy $openurl :sout=#transcode{acodec=mp3,ab=128}:file{dst=$destfile,no-overwrite} --run-time=$recording_seconds vlc://quit" -Wait
}

# ====main procedure====
# 次回放送日時を取得する
[DateTime]$next_casting = getNextCast

# ファイル名決定
$destfile = $destdir + $bungei + "　" + $next_casting.AddSeconds(30).ToString("yyyyMMdd-HHmm") + ".mp3"

# 次回放送日時まで待機する
$sleep_seconds = getSleepSecond $next_casting
Start-Sleep -s $sleep_seconds

# 次回放送日時の30秒前に録音実行
startRec
