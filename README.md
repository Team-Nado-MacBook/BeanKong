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

- feat: 새로운 기능 추가
- fix: 버그 수정
- docs: 문서/README 수정
- style: 코드 포맷, 들여쓰기 등
- refactor: 코드 리팩토링
- test: 테스트 추가/수정
- chore: 빌드/설정/패키지 관련 변경

커밋 메시지 예시

- feat(map): 지도 기반 빈강의실 표시 기능 추가
- fix(api): 체크인 데이터 동기화 버그 수정
- docs: README 설치 방법 업데이트
- refactor(components): ClassroomCard 컴포넌트 리팩토링

# BeanKong 데이터 구조



## **1. BuildingEntity (건물)**



| **속성** | **타입**     | **설명**                          |
| -------- | ------------ | --------------------------------- |
| id       | String       | 고유 식별자 (JSON name 값과 동일) |
| name     | String       | 건물 이름                         |
| lat      | Double       | 건물 위도                         |
| lng      | Double       | 건물 경도                         |
| rooms    | [RoomEntity] | 건물 내 강의실 목록 (1:N 관계)    |

## **2. RoomEntity (강의실)**

| **속성**  | **타입**         | **설명**                      |
| --------- | ---------------- | ----------------------------- |
| id        | String           | 고유 식별자 (건물명-호실번호) |
| room      | String           | 강의실 번호                   |
| building  | BuildingEntity   | 소속 건물 (N:1 관계)          |
| schedules | [ScheduleEntity] | 강의실 시간표 (1:N 관계)      |

## **3. ScheduleEntity (시간표)**



| **속성** | **타입**   | **설명**                            |
| -------- | ---------- | ----------------------------------- |
| day      | String     | 요일 (mon, tue, wen, thu, fri, sat) |
| classes  | [String]   | 해당 요일 강의 리스트               |
| room     | RoomEntity | 소속 강의실 (N:1 관계)              |

## **4. JSON 데이터 예시**



```
[
    {
        "name": "산격동 캠퍼스 대학원동",
        "lat": 35.900309,
        "lng": 128.6054241,
        "rooms": [
            {
                "room": "301",
                "mon": ["2B","3A","3B","7A","7B","8A"],
                "tue": ["1A","1B"],
                "wen": null,
                "thu": ["3A","3B"],
                "fri": null,
                "sat": null
            }
        ]
    }
]
```

## **5. 관계 구조 요약**

```
BuildingEntity
 └─ rooms : [RoomEntity]
       └─ schedules : [ScheduleEntity]
```

