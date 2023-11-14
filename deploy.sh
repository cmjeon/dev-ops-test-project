#!/bin/sh

echo "> 현재 구동 중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl demo | grep java | awk '{print $1}')

