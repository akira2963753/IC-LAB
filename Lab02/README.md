## 12×12 N‑Queen
##### 這題的核心想法是用DFS下去做SCAN，如果有找到的話就往下，沒有的話就回朔到前一個找另解，以此循環把解找出。
##### 然後利用四種Mask來判斷可不可以放，col_mask(行)、row_mask(列)、diag_mask(↘︎)、adiag_mask(↙︎)。  
##### col_mask 與 row_mask 很好理解，而判斷↘︎↙︎的則是使用以下方法 :  
> ##### 因為是 12x12宮格 可得 2(n-2) + 1 = 2 x 10 + 1 = 21 斜直線 (分↘︎↙︎)  
> ##### 如果是 ↘︎ : 可以使用 row - col + 11 得到該格子屬於哪一條斜直線 (Plus 11是因為不想要有負的index，因此加入offset)   
> ##### 如果是 ↙︎ : 可以使用 row + col 得到該格子屬於哪一條斜直線  
> ##### 上述兩種方式的核心概念都是因為斜線的話row和col會同時改變，往↘︎同時+1、往↙︎col-1但row+1   
##### 接下來我們來談 *Depth-First Search, DFS* 的作法 :  
> ##### 首先在把預先放置的Queen放入Cheesboard後，我會從第0個col開始搜索，直到找到可以放置的row
> ##### 並將Queen放入、Mask更新並將目前處理的col push into stack，接著往下一個col做搜索，當然預先放置Queen的col會被跳過  
> ##### 若找不到可放置的row的話，就將前一個處理的col從stack中取出，且row調整成原本放置位置+1開始做搜索
> ##### (這樣才不會重複使用相同解)
> ##### 以此類推，經過多次計算後，找到整體來說最淺的解。  
##### 依此概念下去寫RTL，即可完成並通過Test Pattern。   
<img width="569" alt="{6174C805-E9AA-44DF-B473-AC2452C5C4D7}" src="https://github.com/user-attachments/assets/b580ffde-c13e-4335-8d47-6ce94007269c" />

## Code View   
#### 宣告Parameter、Register and Net    
``` Verilog
parameter IDLE = 2'd0,READ = 2'd1,CAL = 2'd2,OUT = 2'd3;
integer i;

reg [1:0] state,next_state;
reg [2:0] cnt;
reg [2:0] num_temp;
reg [3:0] chessboard[0:11];
reg [11:0] col_mask;
reg [11:0] row_mask;
reg [22:0] diag_mask;
reg [22:0] adiag_mask;
reg [3:0] col_cnt;
reg [3:0] row_cnt;
reg [3:0] oidx;
reg [3:0] stack[0:11];
reg [3:0] sp;
reg [11:0] record_mask; 
    
wire [4:0] diag_cnt,adiag_cnt;
wire [4:0] diag,adiag;
wire [3:0] bk_col,bk_row;
wire [4:0] bk_diag,bk_adiag;
```    
#### Assignment 
###### 這兩個是處理預先放入Queen的diag和adiag計算  
``` Verilog
assign diag = {1'b0,row} - {1'b0,col} + 5'd11;
assign adiag = row + col;
```
###### 這兩個是處理計算好要放入的Queen的diag和adiag計算      
``` Verilog
assign diag_cnt = {1'b0,row_cnt} - {1'b0,col_cnt} + 5'd11;
assign adiag_cnt = row_cnt + col_cnt;
```
###### 而這四個mask是在處理回朔到前一個處理的col、row、diag、adiag  
``` Verilog
assign bk_col = stack[sp-4'd1]; // pop previous col 
assign bk_row = chessboard[bk_col]; // get previous row 
assign bk_diag = {1'b0,bk_row} - {1'b0,bk_col} + 5'd11; // get previous diag
assign bk_adiag = bk_row + bk_col; // get previous adiag  
```  

###### 注意在這邊要把4個bit的row、col Extend 1bit 再做加法，avoid overflow。
###### Index 盡量能用Net來表示比較好，增加易讀性也可以減少錯誤率。

``` Verilog 
assign diag = {1'b0,row} - {1'b0,col} + 5'd11;
assign diag_cnt = {1'b0,row_cnt} - {1'b0,col_cnt} + 5'd11;
assign bk_diag = {1'b0,bk_row} - {1'b0,bk_col} + 5'd11;
```
#### 建立FSM  
``` Verilog
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case(state)
        IDLE : next_state = (in_valid&&in_valid_num)? READ : IDLE;
        READ : next_state = (cnt==num_temp)? CAL : READ;
        CAL : next_state = (col_cnt==4'd12)? OUT : CAL;
        OUT : next_state = (oidx==4'd11)? IDLE : OUT;
    endcase
end

```
#### 建立一開始輸入的counter and n_temp
###### 為什麼需要n_temp : 因為n只會輸入一個clk，所以用n_temp把n存下來，好讓我判斷counter算到什麼時候要轉態 
``` Verilog
// Set the counter ----------------------------------------------------------------
always @(posedge clk) begin
    if((state==IDLE&&in_valid_num)||state==READ) cnt <= cnt + 3'd1;
    else cnt <= 3'd0;
end

// Set the temp for in_num --------------------------------------------------------
always @(posedge clk) begin
    if(state==IDLE&&in_valid_num) num_temp <= in_num - 3'd1;
    else;
end
```
#### 把預先放入的Queen放入Chessboard和計算剩下的Queen位置  

``` Verilog
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin // Reset to zero
            for(i=0;i<12;i=i+1) begin
                chessboard[i] <= 4'd13;
                stack[i] <= 4'd0;
            end
            col_mask <= 12'd0;
            row_mask <= 12'd0;
            diag_mask <= 23'd0;
            adiag_mask <= 23'd0;
            record_mask <= 12'd0;
            row_cnt <= 4'd0;
            col_cnt <= 4'd0;
            sp <= 4'd0;
        end
        else if((state==IDLE&&in_valid)||state==READ) begin
            chessboard[col] <= row; // Put the queen into chessboard
            record_mask[col] <= 1'b1; // 紀錄被預先放入的col 這些不能更改 
            col_mask[col] <= 1'b1; // set col_mask
            row_mask[row] <= 1'b1; // set row_mask
            diag_mask[diag] <= 1'b1; // set diag_mask
            adiag_mask[adiag] <= 1'b1; //set adiag_mask
        end
        else if(state==IDLE) begin // reset to zero
            for(i=0;i<12;i=i+1) begin
                chessboard[i] <= 4'd13;
                stack[i] <= 4'd0;
            end
            col_mask <= 12'd0;
            row_mask <= 12'd0;
            diag_mask <= 23'd0;
            adiag_mask <= 23'd0;
            record_mask <= 12'd0;
            row_cnt <= 4'd0;
            col_cnt <= 4'd0;
            sp <= 4'd0;            
        end
        else if(state==CAL&&col_cnt!=4'd12) begin
            if(col_mask[col_cnt]==1'b0&&record_mask[col_cnt]!=1'b1) begin //該col沒有ueen
                // 該 row 跟 斜直線上 沒有Queen
                if(row_mask[row_cnt]==1'b0&&diag_mask[diag_cnt]==1'b0&&adiag_mask[adiag_cnt]==1'b0) begin
                        // 寫入Queen
                        chessboard[col_cnt] <= row_cnt;
                        col_mask[col_cnt] <= 1'b1;
                        row_mask[row_cnt] <= 1'b1;
                        diag_mask[diag_cnt] <= 1'b1;
                        adiag_mask[adiag_cnt] <= 1'b1;
                        col_cnt <= col_cnt + 4'd1; // move to next col
                        row_cnt <= 4'd0; // reset to zero
                        stack[sp] <= col_cnt; // push col_cnt into stack
                        sp <= sp + 4'd1; // sp ++
                end
                else begin
                    if(row_cnt>=4'd11) begin // 都找不到row可以放 要回朔
                        col_cnt <= bk_col; // back to previous col_cnt exclude unfixed col
                        row_cnt <= bk_row + 4'd1; // row_cnt++
                        // clean mask
                        col_mask[bk_col] <= 1'b0;
                        row_mask[bk_row] <= 1'b0;
                        diag_mask[bk_diag] <= 1'b0;
                        adiag_mask[bk_adiag] <= 1'b0;
                        // pop col_cnt from stack
                        stack[sp-4'd1] <= 4'd0;
                        sp <= sp - 4'd1;
                    end
                    else row_cnt <= row_cnt + 4'd1; //move to next row
                end 
            end
            else begin
                col_cnt <= col_cnt + 4'd1; //move to next col
                row_cnt <= 4'd0; //Reset to zero
            end
        end
    end
```
#### 輸出結果!!  
``` Verilog
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out <= 4'd0;
            oidx <= 4'd0;
            out_valid <= 1'b0;
        end 
        else if(state==OUT) begin
            out_valid <= 1'b1;
            out <= chessboard[oidx];
            oidx <= oidx + 4'd1;
        end 
        else begin
            out <= 4'd0;
            out_valid <= 1'b0;
            oidx <= 4'd0;
        end
    end

``` 



