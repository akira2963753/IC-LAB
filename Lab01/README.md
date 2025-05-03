## Lab01 解題思路

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
``` Verilog
module CC(
    input [3:0] in_s0,
    input [3:0] in_s1,
    input [3:0] in_s2,
    input [3:0] in_s3,
    input [3:0] in_s4,
    input [3:0] in_s5,
    input [3:0] in_s6,
    input [2:0] opt,
    input [1:0] a,
    input [2:0] b,
    output reg [2:0] out,
    output reg [2:0] s_id0,
    output reg [2:0] s_id1,
    output reg [2:0] s_id2,
    output reg [2:0] s_id3,
    output reg [2:0] s_id4,
    output reg [2:0] s_id5,
    output reg [2:0] s_id6
);

```   

##### 宣告 Net and Register :    
###### 記得要多開一個bit的空間讓放sign bit    
``` Verilog
    integer i,j;
    reg signed [4:0] in[0:6]; // add a sign bit
    reg [2:0] s_id[0:6];
    reg signed [4:0] in_temp;
    reg [2:0] id_temp;
    reg signed [4:0] u;
    reg signed [4:0] pass_score;
    // Max : 4*15 + 7 = 67 -> 8bit(add a sign bit)
    reg signed [7:0] score;
    wire [2:0] a_plus_1;
    assign a_plus_1 = a + 1;
```  
##### Signed / Unsigned :    
###### 這邊的想法就是直接擴展一個sign bit(這樣後面就不用再分成處理有號跟無號了)  
###### 如果是Signed Operation就把高位元Extend出去為Sign bit    
###### 如果是Unsigned Operation就把Sign bit設為"0"      
``` Verilog
    always @(*) begin
        // Initialize
        out = 3'd0;
        for(i=0;i<7;i=i+1) s_id[i] = i;

        // Signed or Unsigned
        in[0] = (opt[0])? {in_s0[3],in_s0} : {1'b0,in_s0};
        in[1] = (opt[0])? {in_s1[3],in_s1} : {1'b0,in_s1};
        in[2] = (opt[0])? {in_s2[3],in_s2} : {1'b0,in_s2};
        in[3] = (opt[0])? {in_s3[3],in_s3} : {1'b0,in_s3};
        in[4] = (opt[0])? {in_s4[3],in_s4} : {1'b0,in_s4};
        in[5] = (opt[0])? {in_s5[3],in_s5} : {1'b0,in_s5};
        in[6] = (opt[0])? {in_s6[3],in_s6} : {1'b0,in_s6};
```  
##### Sort :  
###### 這邊是用Bubble Sort的概念  
###### 直接處理值的排列跟Student ID的排列  
``` Verilog
        // Sort Using Bubble Sort
        for(i=0;i<6;i=i+1) begin
            for(j=0;j<6-i;j=j+1) begin
                // Largest to Smallest
                if(opt[1]&&(in[j]<in[j+1])) begin
                    // Value Swap
                    in_temp = in[j+1];
                    in[j+1] = in[j];
                    in[j] = in_temp;
                    // Student ID Swap
                    id_temp = s_id[j+1];
                    s_id[j+1] = s_id[j];
                    s_id[j] = id_temp;
                end
                // Smallest to Largest
                else if(~opt[1]&&(in[j]>in[j+1])) begin
                    // Value Swap
                    in_temp = in[j+1];
                    in[j+1] = in[j];
                    in[j] = in_temp;
                    // Student ID Swap
                    id_temp = s_id[j+1];
                    s_id[j+1] = s_id[j];
                    s_id[j] = id_temp;                        
                end
                else;
            end
        end  

```   
##### Linear-Transition and Calculate :  
###### 這裡就是照"Lab01_Exercise"中的公式做設計  
###### 注意因為a跟b恆為正數，所以計算的時候要開一個Extend "0" Sign bit   
###### 像這樣 -> $signed({1'b0,a_plus_1} 、$signed({1'b0,b})  
###### 計算out後把student_id輸出便完成功能  
``` Verilog
        // Calculate 
        u = (in[0]+in[1]+in[2]+in[3]+in[4]+in[5]+in[6]) / 7;
        pass_score = u - a;
        
        // Linear - Transformation
        for(i=0;i<7;i=i+1) begin
            if(in[i]<0) begin // Negative
                score = (in[i])/$signed({1'b0,a_plus_1}) + $signed({1'b0,b});
            end
            else begin // Positive
                score = (in[i])*($signed({1'b0,a_plus_1})) + $signed({1'b0,b});
            end
        // Count
            if(score >= pass_score) out = out + 1;
            else;
           
        end
        if(opt[2]) out = 3'd7 - out;
        else;

        s_id0 = s_id[0];
        s_id1 = s_id[1];
        s_id2 = s_id[2];
        s_id3 = s_id[3];
        s_id4 = s_id[4];
        s_id5 = s_id[5];
        s_id6 = s_id[6];
    end
    
endmodule

```  

