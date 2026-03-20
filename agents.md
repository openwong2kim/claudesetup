# Agent Registry
> 소프트웨어 개발용 core 에이전트만 포함. 확장 에이전트(마케팅/영업/게임/학술 등)는 https://github.com/msitarzewski/agency-agents 참조.
> 사용법: 도메인 확인 → agency-agent 선택 → 매핑된 subagent_type으로 스폰 → 프롬프트에 역할 명시
> **최신 전체 목록**: `~/.claude/subagent-index.md` (install.sh가 자동 생성, 아래 테이블에 없는 에이전트는 여기서 확인)

## Engineering
| Agency Agent | subagent_type | 용도 |
|---|---|---|
| engineering-frontend-developer | frontend-developer | UI, React/Vue/Angular, CSS |
| engineering-backend-architect | backend-developer | API 설계, 서버, DB 연동 |
| engineering-senior-developer | fullstack-developer | 전체 스택, 복잡한 기능 |
| engineering-software-architect | architect-reviewer | 시스템 설계, 아키텍처 리뷰 |
| engineering-ai-engineer | ai-engineer | AI/ML, LLM 통합 |
| engineering-ai-data-remediation-engineer | data-engineer | 데이터 정제, ETL |
| engineering-data-engineer | data-engineer | 데이터 파이프라인 |
| engineering-database-optimizer | database-optimizer | 쿼리 최적화, DB 성능 |
| engineering-devops-automator | devops-engineer | CI/CD, 인프라 자동화 |
| engineering-sre | sre-engineer | 안정성, 모니터링 |
| engineering-security-engineer | security-engineer | 보안, 취약점, 인증/인가 |
| engineering-threat-detection-engineer | security-engineer | 위협 탐지 |
| engineering-code-reviewer | code-reviewer | 코드 리뷰, 품질 검증 |
| engineering-mobile-app-builder | mobile-developer | iOS/Android, RN, Flutter |
| engineering-rapid-prototyper | fullstack-developer | 프로토타입, MVP |
| engineering-git-workflow-master | git-workflow-manager | 브랜치/머지, Git 워크플로우 |
| engineering-incident-response-commander | incident-responder | 장애 대응, 포스트모템 |
| engineering-embedded-firmware-engineer | general-purpose | 임베디드, 펌웨어 |
| engineering-technical-writer | technical-writer | 기술 문서, API 문서 |
| engineering-solidity-smart-contract-engineer | blockchain-developer | 스마트 컨트랙트, Web3 |
| engineering-autonomous-optimization-architect | architect-reviewer | 자율 최적화 시스템 설계 |
| engineering-feishu-integration-developer | backend-developer | Feishu/Lark 연동 |
| engineering-wechat-mini-program-developer | frontend-developer | WeChat 미니프로그램 |

## Design
| Agency Agent | subagent_type | 용도 |
|---|---|---|
| design-ui-designer | ui-designer | UI 설계, 컴포넌트 디자인 |
| design-ux-researcher | ux-researcher | 사용자 조사, UX 리서치 |
| design-ux-architect | ui-designer | 정보 구조, 와이어프레임 |
| design-image-prompt-engineer | prompt-engineer | 이미지 생성 프롬프트 |

## Testing
| Agency Agent | subagent_type | 용도 |
|---|---|---|
| testing-evidence-collector | qa-expert | 테스트 증거 수집 |
| testing-reality-checker | qa-expert | 현실성 검증, 엣지 케이스 |
| testing-test-results-analyzer | qa-expert | 테스트 결과 분석 |
| testing-performance-benchmarker | performance-engineer | 성능 벤치마크, 부하 테스트 |
| testing-api-tester | test-automator | API 테스트 자동화 |
| testing-tool-evaluator | research-analyst | 도구 평가, 비교 분석 |
| testing-workflow-optimizer | devops-engineer | 워크플로우 최적화 |
| testing-accessibility-auditor | qa-expert | 접근성 감사, WCAG |

## Support
| Agency Agent | subagent_type | 용도 |
|---|---|---|
| support-analytics-reporter | data-analyst | 분석 리포트, 대시보드 |
| support-infrastructure-maintainer | devops-engineer | 인프라 유지보수 |
| support-legal-compliance-checker | legal-advisor | 법적 규정 준수 |
| support-executive-summary-generator | technical-writer | 경영진 보고서, 요약 |

## Specialized
| Agency Agent | subagent_type | 용도 |
|---|---|---|
| agents-orchestrator | general-purpose | 멀티에이전트 오케스트레이션 |
| specialized-mcp-builder | mcp-developer | MCP 서버/클라이언트 |
| specialized-developer-advocate | technical-writer | 개발자 관계, 에반젤리즘 |
| specialized-document-generator | technical-writer | 문서 생성 자동화 |
| specialized-model-qa | qa-expert | AI 모델 품질 검증 |
| specialized-workflow-architect | architect-reviewer | 워크플로우 설계 |
| blockchain-security-auditor | security-auditor | 블록체인 보안 감사 |
| compliance-auditor | security-auditor | 규정 준수 감사 |
| lsp-index-engineer | backend-developer | LSP/인덱스 엔지니어링 |

## Quick Reference: subagent_type 역매핑
| subagent_type | 대표 agency-agent | 용도 |
|---|---|---|
| frontend-developer | engineering-frontend-developer | UI, React, CSS |
| backend-developer | engineering-backend-architect | API, 서버, DB |
| fullstack-developer | engineering-senior-developer | 전체 스택 |
| architect-reviewer | engineering-software-architect | 아키텍처 설계/리뷰 |
| ai-engineer | engineering-ai-engineer | AI/ML |
| data-engineer | engineering-data-engineer | 데이터 파이프라인 |
| data-analyst | support-analytics-reporter | 데이터 분석 |
| database-optimizer | engineering-database-optimizer | DB 성능 |
| devops-engineer | engineering-devops-automator | CI/CD, 배포 |
| sre-engineer | engineering-sre | 안정성, 모니터링 |
| security-engineer | engineering-security-engineer | 보안 구현 |
| security-auditor | compliance-auditor | 보안 감사 |
| code-reviewer | engineering-code-reviewer | 코드 리뷰 |
| test-automator | testing-api-tester | 테스트 자동화 |
| qa-expert | testing-evidence-collector | 품질 보증 |
| performance-engineer | testing-performance-benchmarker | 성능 최적화 |
| mobile-developer | engineering-mobile-app-builder | 모바일 앱 |
| ui-designer | design-ui-designer | UI/UX 디자인 |
| ux-researcher | design-ux-researcher | 사용자 조사 |
| technical-writer | engineering-technical-writer | 기술 문서 |
| mcp-developer | specialized-mcp-builder | MCP 서버 |
| blockchain-developer | engineering-solidity-smart-contract-engineer | Web3 |
| git-workflow-manager | engineering-git-workflow-master | Git 워크플로우 |
| incident-responder | engineering-incident-response-commander | 장애 대응 |
| research-analyst | testing-tool-evaluator | 조사, 도구 평가 |
| prompt-engineer | design-image-prompt-engineer | 프롬프트 |
| legal-advisor | support-legal-compliance-checker | 법적 규정 |
| general-purpose | (매핑 없는 에이전트) | 범용 |
