##### 這題的想法是用DFS下去做SCAN，如果有找到的話就往下，沒有的話就回朔到前一個找另解，以此循環把解找出。  
##### 然後利用四種Mask來判斷可不可以放，col_mask(行)、row_mask(列)、diag_mask(↘)、adiag_mask(↙)。  
##### col_mask and row_mask 很好理解，而判斷↘↙的則是使用以下方法 :  
##### 12x12宮格 可得 2(n-2) + 1 = 2 x 10 + 1 = 21 斜直線     



<img width="569" alt="{6174C805-E9AA-44DF-B473-AC2452C5C4D7}" src="https://github.com/user-attachments/assets/b580ffde-c13e-4335-8d47-6ce94007269c" />  

