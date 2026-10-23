# 레슨 3 - 프로젝트 게시

완성한 퀴즈와 프로젝트 지침을 Git에 기록하고 GitHub 공개 저장소에 게시합니다. **첫 커밋은 이후 변경 사항을 비교하는 기준선**이 됩니다.

**이 레슨에서 할 일**

- Git 저장소를 초기화하고 첫 커밋을 만듭니다.
- GitHub에 공개 저장소를 만들고 푸시합니다.
- 커밋과 파일이 게시됐는지 확인합니다.

> 여기서 **게시**는 코드를 GitHub에 올리는 것입니다. 퀴즈 웹사이트가 배포되는 것은 아닙니다.

---

## 3-0. Git 작성자 정보 확인 (최초 1회)

커밋 시 이름·이메일 오류가 나지 않도록 먼저 확인합니다. Copilot CLI 입력창에서 실행합니다.

```text
copilot> !git config --global user.name
copilot> !git config --global user.email
```

값이 비어 있으면 설정합니다. (따옴표 안은 본인 정보로 바꿉니다.)

```text
copilot> !git config --global user.name "Your Name"
copilot> !git config --global user.email "you@example.com"
```

## 3-1. 옵션 A: 에이전트에게 요청하기 (권장)

자연어 요청 → 작업 내용 확인 → 승인 흐름을 경험합니다. 저장소 이름은 본인이 쓸 고유한 이름으로 바꿔도 됩니다.

```text
현재 프로젝트 폴더를 Git 저장소로 초기화하고 main을 기본 브랜치로 설정해 주세요. 퀴즈와 프로젝트 지침 등 실습에 필요한 파일만 포함해 첫 커밋을 만든 뒤, 내 GitHub 계정에 space-quiz-workshop-demo 라는 공개 저장소를 생성하고 푸시해 주세요. 게시할 파일을 먼저 확인하고, 관련 없는 파일이나 비밀 정보는 제외해 주세요.
```

에이전트가 요청하는 Git·GitHub 명령을 **읽고** 승인합니다. 완료 메시지가 나오면 3-3으로 이동합니다.

## 3-2. 옵션 B: 직접 실행하기 (참고)

GitHub CLI(`gh`) 로그인이 되어 있어야 합니다. Copilot CLI 입력창에서 한 줄씩 실행합니다.

```text
!git init -b main
!git status --short
!git add index.html .github/copilot-instructions.md
!git diff --cached --stat
!git commit -m "Add space quiz and project instructions"
!gh repo create space-quiz-workshop-demo --public --source=. --push
```

일반 터미널에서 실행할 때는 앞의 `!`를 뺍니다.

## 3-3. 결과 확인

```text
copilot> !git log --oneline -1
copilot> !gh repo view --web
```

브라우저에서 저장소에 `index.html`과 `.github/copilot-instructions.md` **두 파일**이 있는지 확인합니다.

---

## 체크포인트

- [ ] `main` 브랜치에 첫 커밋이 있다.
- [ ] GitHub 공개 저장소에 두 파일이 올라갔다.

다음: [레슨 4 - 이슈를 병렬로 작업하기](04-issues-and-sessions.md)
