## Lab01 筆記

Signed / Unsigned 可以擴充一個bit作為sign bit下去做  
記得因為已經考慮到signed / unsiged 的關係   
所有需要用到計算的reg都必須要宣告為signed  
宣告的reg到底最大要用多少bit的空間要計算好  
並且必須要多一個bit來作為sign bit  
至於恆為正數的a跟b，則是用$signed()搭配Extend High 0 bit    

因為這題是屬於 Combinational Logic Circuit  
所以解題思路就是用always(*) 下去完成每個功能  
Sort的部分使用的是最簡單的Bubble Sort  

最後也是成功完成100000個 Pattern 的 Test  
<img width="355" alt="{9AB175FC-72EB-4582-861E-6ECE798DE460}" src="https://github.com/user-attachments/assets/05ce31c0-01a2-4bbd-805e-1b0890378e06" />  

Code View  
-
##### 定義 I/O :  
<img width="489" alt="{EC9F9393-7215-4AB7-9A21-83257A52FD6B}" src="https://github.com/user-attachments/assets/bbf50b0e-e14a-4b94-84b5-798d6e84286b" />  

##### 宣告 Net and Register :    
###### 記得要多開一個bit的空間讓放sign bit    
<img width="502" alt="{5526270F-036B-4885-A1D0-7BFBA3E7C0CB}" src="https://github.com/user-attachments/assets/e5a8016d-8408-49b1-ade5-e67a74f3ada7" />  

##### Signed / Unsigned :    
###### 這邊的想法就是直接擴展一個sign bit(這樣後面就不用再分成處理有號跟無號了)  
###### 如果是Signed Operation就把高位元Extend出去為Sign bit    
###### 如果是Unsigned Operation就把Sign bit設為"0"      
<img width="504" alt="{EA0A7E45-3F8E-4160-813B-EE80549BEDCF}" src="https://github.com/user-attachments/assets/92937be9-dea8-4297-85c1-dcc86adc3dcf" />  

##### Sort :  
###### 這邊是用Bubble Sort的概念  
###### 直接處理值的排列跟Student ID的排列  
<img width="8" alt="{DC4330C6-39B2-4659-8B35-2FC59E87156E}" src="https://github.com/user-attachments/assets/da3be91b-cee7-4654-ad11-52640806ab0a" />  

##### Linear-Transition and Calculate :  
###### 這裡就是照"Lab01_Exercise"中的公式做設計  
###### 注意因為a跟b恆為正數，所以計算的時候要開一個Extend "0" Sign bit   
###### 像這樣 -> $signed({1'b0,a_plus_1} 、$signed({1'b0,b})  
###### 計算out後把student_id輸出便完成功能  
<img width="542" alt="{3DAF783D-9F71-4B00-A180-6EF3AAD0578E}" src="https://github.com/user-attachments/assets/5eee512f-38f3-4011-a445-b71dcb993b35" />

