# Claude Code Team Mode Setup

Claude Code에서 멀티에이전트 팀 모드를 운영하기 위한 설정 패키지.

Leader(Claude 본체)가 전략/리뷰만 담당하고, 전문 Teammate(서브에이전트)들이 실제 코드 작업을 수행하는 구조.

## Features

- **Fast-track 워크플로우** — 태스크 크기(S/M/L)에 따라 Phase를 자동 조절
- **Superpowers 기반 플로우** — brainstorming → planning → subagent-driven development → review → finish
- **Agency-agents 레지스트리** — 150+ 에이전트 중 소프트웨어 개발 core만 추출한 매핑 테이블
- **5단계 검증 Gate** — IDENTIFY → RUN → READ → VERIFY → CLAIM
- **체계적 디버깅** — 근본 원인 우선, 3회 실패 시 STOP
- **세션 복구** — `/resume`으로 중단된 작업 이어가기

## File Structure

```
├── CLAUDE.md              # 4행 글로벌 라우터 (팀 모드 트리거)
├── agents.md              # 에이전트 ↔ subagent_type 매핑 (~100행)
├── commands/
│   ├── team.md            # /team — 팀 모드 전체 워크플로우
│   ├── status.md          # /status — 진행 상태 요약
│   ├── resume.md          # /resume — 세션 복구
│   ├── review.md          # /review — 코드 리뷰 트리거
│   └── finish.md          # /finish — 마무리 + 머지
├── templates/
│   ├── decisions.md       # 의사결정 로그 템플릿
│   ├── progress.md        # 진행 추적 템플릿
│   └── handoff.md         # 인수인계 템플릿
├── install.sh             # 설치 스크립트 (외부 에이전트/스킬/서브에이전트 포함)
├── uninstall.sh           # 제거 스크립트 (외부 에이전트/스킬/서브에이전트 포함)
└── README.md
```

## Installation

```bash
chmod +x install.sh
./install.sh
```

`~/.claude/`에 모든 파일이 설치됩니다. 기존 파일은 자동 백업됩니다.

설치 시 아래 외부 레포도 자동으로 클론 & 설치됩니다:

| 레포 | 설치 경로 | 용도 |
|------|----------|------|
| [agency-agents](https://github.com/msitarzewski/agency-agents) | `~/.claude/agents/` | 에이전트 페르소나 (150+) |
| [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | `~/.claude/skills/` | Claude 스킬 컬렉션 |
| [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | `~/.claude/subagents/` | 서브에이전트 정의 (127+) |

재실행하면 `git pull`로 최신 버전으로 업데이트됩니다.

설치 완료 후 `~/.claude/subagent-index.md`가 자동 생성됩니다. 외부 레포에서 추가/변경된 에이전트·스킬·서브에이전트의 이름과 용도가 이 파일에 반영되어, `agents.md` 매핑 테이블과의 불일치를 방지합니다.

## Usage

### Commands

```
/team      — 팀 모드 시작 (Phase 0부터)
/status    — 현재 진행 상태 확인
/resume    — 중단된 세션 복구
/review    — 코드 리뷰 트리거
/finish    — 마무리 (머지/PR/유지/폐기)
```

### Quick Start

1. 아무 프로젝트 폴더에서 Claude Code를 실행
2. "팀모드로 로그인 기능 만들어줘" 라고 입력 (또는 `/team` 입력)
3. Claude가 Leader 역할로 전환되어 Phase 0부터 자동 진행

### Example: Small 태스크 (버그 수정)

```
사용자: 팀으로 로그인 버튼 색상 버그 수정해줘

Leader: [Small로 판단] Phase 0 → 3 → 5 경로로 진행합니다.
        Phase 0: tracking 파일 생성 + feature branch 생성
        Phase 3: frontend-developer teammate 1명 스폰 → 계획 보고 → 승인 → 구현 → 검증
        Phase 5: 4가지 옵션 제시 (머지/PR/유지/폐기)
```

### Example: Medium 태스크 (새 기능)

```
사용자: 팀으로 사용자 프로필 페이지 만들어줘

Leader: [Medium으로 판단] Phase 0 → 1 → 2 → 3 → 4 → 5 경로로 진행합니다.
        Phase 0: 초기화
        Phase 1: 브레인스토밍 — "어떤 정보를 보여줄까요?" 등 질문
                 → 2-3개 접근법 제시 → 사용자 승인
        Phase 2: agents.md에서 에이전트 선택
                 → 태스크 분해 (API teammate + UI teammate)
                 → 사용자 승인
        Phase 3: teammate별 구현 (계획 보고 → 승인 → 구현 → 검증)
        Phase 4: code-reviewer 스폰 → 전체 코드 리뷰
        Phase 5: 마무리
```

### Example: Large 태스크 (아키텍처 변경)

```
사용자: 팀으로 인증 시스템을 JWT에서 세션 기반으로 전환해줘

Leader: [Large로 판단] 전체 Phase + spec/plan 리뷰어 포함.
        Phase 0: 초기화
        Phase 1: 브레인스토밍 → architect-reviewer가 설계 검토 (max 3회)
                 → 사용자 최종 승인
        Phase 2: 계획 수립 → code-reviewer가 계획 검토 (max 3회)
                 → 사용자 최종 승인
        Phase 3: 태스크별 전문 teammate 순차 스폰
                 (각 태스크: 2단계 리뷰 — spec 준수 + 코드 품질)
        Phase 4: 전체 코드 리뷰 (max 3회 사이클)
        Phase 5: 마무리
```

### 세션이 끊겼을 때

```
사용자: /resume

Leader: decisions.md, progress.md, handoff.md를 읽고
        "Phase 3, Task 4부터 이어가겠습니다" → 자동 복구
```

### 팀 모드 없이 단독 커맨드 사용

팀 모드가 아니어도 개별 커맨드를 독립적으로 사용할 수 있습니다:

```
/review    — 현재 변경사항에 대해 코드 리뷰만 실행
/finish    — 현재 브랜치를 머지/PR 처리
```

### Tips

- **"팀모드", "팀으로", "team" 등의 키워드**만 말하면 자동으로 팀 모드 진입
- Leader는 코드를 직접 읽거나 쓰지 않음 — 모든 코드 작업은 teammate가 수행
- 각 teammate는 반드시 **계획 보고 → 승인 → 구현** 순서를 따름
- 문제 발생 시 teammate가 3회 실패하면 자동 교체됨
- `agents.md`는 Phase 2에서만 로드되므로 토큰 낭비 없음

## Workflow (S/M/L Fast-track)

| 크기 | 기준 | 경로 |
|------|------|------|
| **Small** | 파일 1-3개, 단순 수정 | Phase 0 → 3 → 5 (teammate 1명) |
| **Medium** | 파일 4-10개, 새 기능 | Phase 0 → 1 → 2 → 3 → 4 → 5 |
| **Large** | 파일 10개+, 아키텍처 | 전체 Phase + spec/plan 리뷰어 |

### Phase 상세

| Phase | 내용 | 종료 조건 |
|-------|------|----------|
| 0 | 초기화 (tracking 파일 + feature branch) | 파일 생성 완료 |
| 1 | 브레인스토밍 (소크라테스식 질문) | 사용자 승인 (Large: + spec-review) |
| 2 | 에이전트 탐색 + 계획 수립 | 사용자 승인 (Large: + plan-review) |
| 3 | 구현 (Subagent-Driven) | 모든 태스크 Done + 테스트 통과 |
| 4 | 코드 리뷰 (max 3회) | Critical/Important 해결 |
| 5 | 마무리 (머지/PR/유지/폐기) | 사용자 선택 + 실행 완료 |

## Uninstall

```bash
chmod +x uninstall.sh
./uninstall.sh
```

CLAUDE.md와 백업은 유지됩니다.

## Sources & References

이 셋업은 아래 프로젝트들의 아이디어를 통합하여 만들었습니다.

| 프로젝트 | 역할 | 라이센스 |
|----------|------|---------|
| [wy.claude.md](https://github.com/wykim7/wy.claude.md) | 원본 팀 모드 셋업 (워크플로우 기반) | MIT |
| [superpowers](https://github.com/obra/superpowers) | 검증 Gate, 디버깅 규칙, TDD | MIT |
| [agency-agents](https://github.com/msitarzewski/agency-agents) | 에이전트 레지스트리 원본 | MIT |
| [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | subagent_type 매핑 참조 | MIT |
| [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | 스킬 탐색 소스 | Apache 2.0 |

### Original Setup & Workflow
- **[wy.claude.md](https://github.com/wykim7/wy.claude.md)** — MIT License
  이 프로젝트의 원본. Leader/Teammate 구조, Phase 기반 워크플로우, CLAUDE.md + commands/team.md + templates/ 파일 구조, 기록 파일 3종(decisions/progress/handoff), teammate 교체 규칙, coordinator 계층, 세션 복구 등 팀 모드의 핵심 설계를 정의.
  본 셋업은 이 워크플로우를 기반으로 superpowers의 검증 규칙, agency-agents의 에이전트 레지스트리를 통합하고 Fast-track, 토큰 최적화 등을 추가한 확장 버전.

### Verification & Quality Rules
- **[superpowers](https://github.com/obra/superpowers)** (99.9k+ stars) — MIT License
  AI 코딩 에이전트를 위한 스킬 프레임워크.
  본 셋업에서 참조한 요소: 5단계 검증 Gate(IDENTIFY→RUN→READ→VERIFY→CLAIM), 체계적 디버깅 4규칙, TDD RED-GREEN-REFACTOR, 2단계 리뷰(spec 준수 + 코드 품질), spec/plan document reviewer 패턴, max 3회 리뷰 사이클.

### Agent Registry
- **[agency-agents](https://github.com/msitarzewski/agency-agents)** (55.8k+ stars) — MIT License
  150+ AI 에이전트 페르소나 컬렉션. Engineering, Design, Marketing, Sales 등 12개 부서별로 조직.
  각 에이전트마다 성격, 워크플로우, 산출물, 성공 지표가 정의된 .md 파일.
  본 셋업의 agents.md 매핑 테이블의 원본 에이전트 소스.

### Subagent & Skill References
- **[awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** (VoltAgent) — MIT License
  127+ Claude Code 서브에이전트 정의. 10개 카테고리.
  본 셋업의 subagent_type 매핑 참조.

- **[awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)** (46.2k+ stars) — Apache 2.0 License
  Claude AI 스킬 큐레이션 목록. 문서 처리, 개발 도구, 보안, 500+ SaaS 앱 연동.
  teammate의 Skill 검색 단계(1단계)에서 참조하는 스킬 소스.
  Apache 2.0 라이센스에 따라 수정 시 변경사항을 명시해야 합니다.

## Evolution

| 버전 | 점수 | 주요 변경 |
|------|------|----------|
| v1 (원본) | 6.6/10 | CLAUDE.md에 모든 규칙 통합 |
| v2 | 6.9/10 | superpowers 플로우 + agents.md + 커맨드 5개 |
| v2 최적화 | **9.1/10** | Fast-track S/M/L + Phase 통합 + agents 경량화 + 잔재 정리 |

## License

MIT

본 프로젝트는 MIT 라이센스입니다. 참조한 프로젝트 중 awesome-claude-skills만 Apache 2.0이며, 나머지는 모두 MIT입니다.
