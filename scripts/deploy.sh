#!/bin/bash
cd /var/jenkins_home/dev-ops-test-project

# 환경변수 DOCKER_APP_NAME : 컨테이너 메인 이름
DOCKER_APP_NAME=dev-ops-test-project
LOG_FILE=./deploy.log

if [ -z "$SPRING_PROFILES_ACTIVE" ]; then
  echo "SPRING_PROFILES_ACTIVE is required (dev or prod)." >> $LOG_FILE
  exit 1
fi

export SPRING_PROFILES_ACTIVE

# 배포 시작한 날짜와 시간을 기록
echo "배포 시작일자 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> $LOG_FILE
echo "프로파일 : ${SPRING_PROFILES_ACTIVE}" >> $LOG_FILE

echo "배포 시작 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> $LOG_FILE
docker-compose -p ${DOCKER_APP_NAME} -f docker-compose.yml up -d --build

sleep 30

# 사용하지 않는 이미지 삭제
docker image prune -af

echo "배포 종료  : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> $LOG_FILE
echo "===================== 배포 완료 =====================" >> $LOG_FILE
echo >> $LOG_FILE
