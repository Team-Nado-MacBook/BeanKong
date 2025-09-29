# 경북대 빈강의실 앱 (MVP)

## 개요
경북대 학생들을 위한 캠퍼스 내 빈강의실 안내 앱입니다.  
- 실시간 빈강의실 정보 제공 (공개 시간표 + 학생 체크인 기반)  
- 지도 기반 UI로 가장 가까운 강의실 바로 확인 가능  
- 학습, 자습, 휴식 등 캠퍼스 내 시간 활용 최적화  

## 기능
1. **빈강의실 조회**
   - 공개 시간표 크롤링
   - 학생 체크인 기록 기반 점유 확률 계산
2. **지도 UI**
   - 현재 위치 기준 빈강의실 표시
   - 거리순 정렬 및 즐겨찾기 기능
3. **사용자 체크인**
   - 빈강의실 사용 여부 기록
   - 점유 정보 업데이트에 활용
  
## 사용 기술
	- SwiftUI (모바일)
	- Apple Maps SDK
	- Firebase Realtime Database

## 커밋 컨벤션
  ``` <type>(<scope>): <short description> ```

type 예시
	•	feat: 새로운 기능 추가
	•	fix: 버그 수정
	•	docs: 문서/README 수정
	•	style: 코드 포맷, 들여쓰기 등
	•	refactor: 코드 리팩토링
	•	test: 테스트 추가/수정
	•	chore: 빌드/설정/패키지 관련 변경

커밋 메시지 예시
	•	feat(map): 지도 기반 빈강의실 표시 기능 추가
	•	fix(api): 체크인 데이터 동기화 버그 수정
	•	docs: README 설치 방법 업데이트
	•	refactor(components): ClassroomCard 컴포넌트 리팩토링
