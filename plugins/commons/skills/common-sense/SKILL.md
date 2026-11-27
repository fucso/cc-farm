---
name: common-sense
description: farm の共有規約（状態モデル、状態遷移、依存、Issue 形式、Issue の規模、コメント規約、PR 規約、経緯の置き場所）を定義する。Issue のラベル・コメント・PR を扱う前や、Issue を起票する前に参照する。定義のみで、実行はしない。
argument-hint: "[節名（任意）]"
---

# common-sense

- farm の各スキルが共通で参照する規約の定義。
- このスキル自身は何も実行しない。規約を読んで、呼び出し元のスキルが従う。

## 引数

- 節名（任意）: 読みたい節の名前。$ARGUMENTS で受け取る。
- 指定がなければ、全節を対象にする。

## 状態モデル

- ステータスは `farm:` プレフィックスのラベルで表す。
- ステータスのラベルは Issue にのみ付け、PR には付けない。
- ステータスのラベルは常に1つまで。遷移時は新しいラベルを付けて古いラベルを外す（付け替え）。
- ラベルの種類:
  - `farm:ready`: 着手できる状態。
  - `farm:blocked`: 未解決の依存があり、着手できない状態。
  - `farm:in-progress`: エージェントが作業している状態。
  - `farm:in-review`: PR ができ、人間のレビュー待ちの状態。
  - `farm:needs-human`: 人間の判断が要る状態。
- done はラベルを持たない。Issue が closed（completed）であることから導出する。

## 状態遷移

- ready への遷移: muster が付ける。
- in-progress への遷移:
  - graze が、ブランチを Issue に紐付けると同時に付ける。
  - mend が、着手時に付ける（changes requested からの復帰）。
- in-review への遷移:
  - graze が、終了時に付け替える。このとき PR を ready for review にする。
  - mend が、終了時に付け替える。
- blocked への遷移:
  - 作業中に隠れた依存が見つかったら、graze は作業を終了して blocked に付け替える。
  - 理由をコメントに書く。
- needs-human への遷移:
  - 人間の判断が要る問題が見つかったら、needs-human に付け替える。
  - 理由をコメントに書く。
- changes requested の扱い:
  - roundup が、PR の reviewDecision から検出する。
  - roundup が mend を dispatch し、mend が着手時に in-progress へ戻す。
- in-progress の Issue は、shepherd が触らない。

## 依存

- GitHub のネイティブな依存関係（blocked by）を正本とする。
- Issue 本文には、依存を書かない。
- blocked は、open な blocker の有無から導出する。
- 導出した結果に合わせて、blocked ラベルを同期する。

## Issue 形式

- 節構成は次のとおり。
  1. 目的
  2. 背景・文脈
  3. 要件
  4. 完了条件
  5. 範囲外
  6. 未確定事項
- 種別は、GitHub の issue type で表す。
- 完了条件:
  - チェックボックスで書く。
  - 3つまでにする。
- 設計は基本書かない。
- プロジェクトの成長に関わる判断は、背景・文脈に記録する。
- バグの Issue は、次の節構成に差し替える。
  1. 再現手順（番号付き）
  2. 期待する動作
  3. 実際の動作
  4. 環境とバージョン
- テンプレートファイルは、このスキルの templates/ に同梱している。
  - templates/task.md: 通常の Issue。
  - templates/bug.md: バグの Issue。

## Issue の規模

- 1 Issue = 1セッション = 1 PR。
- 目的は1つにする。
- 単独で完了できること。

## コメント規約

- コメントは、ラベルで表現できない事態のときだけ書く。
- 次のコメントは書かない。
  - dispatch の記録。
  - 正常終了時の結果コメント。
- 書き先は問題の種類で決める。
  - 要件の問題は、Issue に書く。
  - 実装の問題は、PR に書く。
- エージェントが書くコメントの先頭には、farm のコメントであることが分かるマーカーを入れる。
  - マーカーの形式は、次の HTML コメント。

    ```
    <!-- farm:comment -->
    ```

## PR 規約

- ブランチ名は自由。
- PR はドラフトで作成する。
- in-review への付け替え時に、ready for review にする。
- 本文の形式は poteto-mode の規約に任せる。
- 本文には、Issue との紐付け（Closes #<issue>）を必ず入れる。

## 経緯の置き場所

- コード（コメントを含む）に、経緯や以前の実装の打ち消しを書かない。
- コードは現在の仕様だけを表す。
- 経緯と判断の記録は Issue に置き、Issue を ADR として扱う。
- 経緯をたどるときは、git の変更履歴から PR と Issue をたどる。
