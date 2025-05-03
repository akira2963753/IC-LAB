## 12×12 N‑Queen
##### 這題的核心想法是用DFS下去做SCAN，如果有找到的話就往下，沒有的話就回朔到前一個找另解，以此循環把解找出。  
##### 然後利用四種Mask來判斷可不可以放，col_mask(行)、row_mask(列)、diag_mask(↘︎)、adiag_mask(↙︎)。  
##### col_mask 與 row_mask 很好理解，而判斷↘︎↙︎的則是使用以下方法 :  
> ##### 因為是 12x12宮格 可得 2(n-2) + 1 = 2 x 10 + 1 = 21 斜直線 (分↘︎↙︎)  
> ##### 如果是 ↘︎ : 可以使用 row - col + 11 得到該格子屬於哪一條斜直線 (Plus 11是因為不想要有負的index，因此加入offset)   
> ##### 如果是 ↙︎ : 可以使用 row + col 得到該格子屬於哪一條斜直線  
> ##### 上述兩種方式的核心概念都是因為斜線的話row和col會同時改變，往↘︎同時+1、往↙︎col-1但row+1   
#### 接下來我們來談 *DFS(深度優先搜尋)* 的作法 :  
##### 首先在把預先放置的Queen放入Cheesboard後，我會從第0個col開始搜索，直到找到可以放置的row
##### 並將Queen放入、Mask更新並將目前處理的col push into stack，接著往下一個col做搜索，當然預先放置Queen的col會被跳過  
##### 若找不到可放置的row的話，就將前一個處理的col從stack中取出，且row調整成原本放置位置+1開始做搜索(這樣才不會重複使用相同解)
##### 以此類推，經過多次計算後，找到整體來說最淺的解。  


<img width="569" alt="{6174C805-E9AA-44DF-B473-AC2452C5C4D7}" src="https://github.com/user-attachments/assets/b580ffde-c13e-4335-8d47-6ce94007269c" />  

