## Lab01 筆記

signed / unsigned 可以擴充一個bit作為sign bit下去做  
記得因為已經考慮到signed / unsiged 的關係   
所有需要用到計算的reg都必須要宣告為signed  
需要計算好要宣告的reg到底最大要用多少bit的空間  
並且必須要多一個bit來作為sign bit  
至於恆為正數的a跟b，則是用$signed()搭配Extend High 0 bit    

因為這題是屬於 Combinational Logic Circuit  
所以解題思路就是用always(*) 下去完成每個功能  
Sort的部分使用的是最簡單的Bubble Sort  

最後也是成功完成100000個 Pattern 的 Test  
<img width="355" alt="{9AB175FC-72EB-4582-861E-6ECE798DE460}" src="https://github.com/user-attachments/assets/05ce31c0-01a2-4bbd-805e-1b0890378e06" />
