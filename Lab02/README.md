![ChatGPT Image 2025年5月3日 上午02_08_36](https://github.com/user-attachments/assets/1b522571-9519-404c-85f8-b5fd389534a7)##### 這題的想法是用DFS下去做SCAN，如果有找到的話就往下，沒有的話就回朔到前一個找另解，以此循環把解找出。  
##### 然後利用四種Mask來判斷可不可以放，col_mask(行)、row_mask(列)、diag_mask(↘)、adiag_mask(↙)。  
##### col_mask and row_mask 很好理解，而判斷↘↙的則是使用以下方法 :  


![Uploading ChatGPT Ima<?xml version="1.0" encoding="utf-8"?><Error><Code>AuthenticationFailed</Code><Message>Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.
RequestId:3d3902e8-c01e-0020-668d-bb805e000000
Time:2025-05-02T18:08:36.6956912Z</Message><AuthenticationErrorDetail>Signed expiry time [Fri, 02 May 2025 17:15:16 GMT] must be after signed start time [Fri, 02 May 2025 18:08:36 GMT]</AuthenticationErrorDetail></Error>ge 2025年5月3日 上午02_08_36.png…]()


<img width="569" alt="{6174C805-E9AA-44DF-B473-AC2452C5C4D7}" src="https://github.com/user-attachments/assets/b580ffde-c13e-4335-8d47-6ce94007269c" />

