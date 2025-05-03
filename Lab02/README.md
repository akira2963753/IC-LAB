# 12×12 N‑Queen：DFS + Mask 解題筆記

> **核心思路**  
> 以 **DFS（深度優先搜尋）** 搭配 **四種 Mask** 進行合法性判斷：  
> `col_mask`（行）、`row_mask`（列）、`diag_mask`（↘︎）、`adiag_mask`（↙︎）。  
> 若目前位置可放 Queen 就「深入」，否則「回朔」到上一欄尋找其他可能解；  
> 重複此流程直到找出所有解，或取得最淺（最先找到）的解。

---

## 1. 斜線（↘︎ / ↙︎）索引計算

- 棋盤大小 **n = 12**  
- 斜線總數  
  \[
    2\,(n - 2) + 1 \;=\; 2 \times 10 + 1 \;=\; \color{red}{21}
  \]
- **主對角 ↘︎**  
  ```text
  diag_index = row - col + (n - 1)   # (n‑1) = 11 為 offset，避免負索引




<img width="569" alt="{6174C805-E9AA-44DF-B473-AC2452C5C4D7}" src="https://github.com/user-attachments/assets/b580ffde-c13e-4335-8d47-6ce94007269c" />  

