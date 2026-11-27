---
name: graze
description: GitHub Issue を1件実装してプルリクエストを作成する。このリポジトリの特定の Issue への着手を頼まれたときに使う（例: "/sheep:graze 12"、"issue #12 を graze して"）。実装の進め方は pstack の poteto-mode に、自己レビューは interrogate に委譲する。マージはしない。
argument-hint: "[issue番号またはURL]"
---

# graze

- GitHub Issue を1件読み、実装して、プルリクエストを作成するスキル。
- 実装の進め方そのものは pstack に委譲し、このスキルは入口・出口・ガードレールだけを持つ。

## 引数

- issue（必須）: 現在のリポジトリの Issue 番号または URL。$ARGUMENTS で受け取る。
- issue が無い場合は、他のことをする前にまず聞く。

## 前提

- commons プラグインがインストールされていて、/commons:common-sense が使えること。
- pstack プラグイン（michael-denyer/pstack-claude）がインストールされていて、/pstack:poteto-mode と /pstack:interrogate が使えること。
- gh が利用可能で、認証済みであること。

## 手順

1. 規約の把握
   - /commons:common-sense を呼び出し、farm の規約と状態の流れを把握する。
2. Issue の確認
   - 次のコマンドで Issue を取得し、タイトルと本文をタスクとして扱う。

     ```
     gh issue view <issue>
     ```

   - その Issue を参照する open なプルリクエストが既にないか確認する。
   - 既にある場合は、重複して着手せず、その旨を報告して止まる。
3. ブランチ作成と着手
   - 次のスクリプトで、ブランチを作って Issue に紐付ける。

     ```
     ${CLAUDE_SKILL_DIR}/scripts/start.sh <issue> <branch>
     ```

4. 実装
   - Issue のタイトルと本文をタスクとして /pstack:poteto-mode を起動する。
   - 完了条件として「実装と検証までで終わること」を付け加える。プルリクエストの作成と CI 対応は後続の手順で行うため、poteto-mode 側では行わない。
   - playbook は指定しない。poteto-mode のルーターに選ばせる。
   - 検証は poteto-mode の仕事であり、リポジトリに project の verify スキルがあればそれを使うのも poteto-mode 側の判断に含まれる。
   - この環境で実検証が不可能な場合は、証跡を偽らず、その旨をプルリクエスト本文に明記する。
   - 作業を続けられない問題が見つかった場合は、「終了手順」に従って止まる。
5. 自己レビュー
   - 差分に対して /pstack:interrogate を実行する。
   - "act on" に分類された指摘は直す。
   - それ以外で重要なものは、プルリクエスト本文に残して見えるようにする。
6. プルリクエスト作成
   - コミットは小さく、レビューしやすい単位に分ける。
   - プルリクエストを作成する。本文には、変更の概要と検証の証跡（実行したことと観測した結果）を書く。
   - 次のスクリプトで、プルリクエストの体裁を整える。

     ```
     ${CLAUDE_SKILL_DIR}/scripts/prepare-pr.sh <issue> <pr>
     ```

7. CI 監視
   - プルリクエストのチェックを監視し、自分の変更が原因の失敗は直す。
   - 無関係な失敗や環境起因の失敗は、追いかけずに報告する。
   - CI がグリーンになったら監視を終える。その後に届いたコメントには反応しない（それは mend の仕事）。
8. レビュー待ちへの移行
   - 次のスクリプトを実行する。

     ```
     ${CLAUDE_SKILL_DIR}/scripts/finish.sh <issue> <pr>
     ```

## 終了手順

- 作業を続けられない場合の止まり方。
  - 隠れた依存が見つかった。
  - 人間の判断が要る。
  - 内容が曖昧、または既に完了している。
  - 自分では解消できない理由でブロックされている。
- 次のスクリプトを、理由を添えて実行して終了する。

  ```
  ${CLAUDE_SKILL_DIR}/scripts/stop.sh <issue> <理由>
  ```

- 明確な停止も正常な結果である。

## ガードレール

- 対象の Issue の範囲だけで作業する。
- マージはしない。Issue を手で閉じない（プルリクエストの Closes が閉じる）。
