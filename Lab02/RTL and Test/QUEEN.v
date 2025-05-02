module QUEEN(
    input clk,
    input rst_n,
    input in_valid,
    input in_valid_num,
    input [3:0] col,
    input [3:0] row,
    input [2:0] in_num,
    output reg out_valid,
    output reg [3:0] out
);
    // Parameter, Integer, Register and Net -------------------------------------------
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

    // Assignment ---------------------------------------------------------------------
    assign diag = {1'b0,row} - {1'b0,col} + 5'd11;
    assign adiag = row + col;
    assign diag_cnt = {1'b0,row_cnt} - {1'b0,col_cnt} + 5'd11;
    assign adiag_cnt = row_cnt + col_cnt;
    assign bk_col = stack[sp-4'd1];
    assign bk_row = chessboard[bk_col];
    assign bk_diag = {1'b0,bk_row} - {1'b0,bk_col} + 5'd11;
    assign bk_adiag = bk_row + bk_col;

    // FSM ----------------------------------------------------------------------------
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

    // Calculate ----------------------------------------------------------------------
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

    // Out
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

    
endmodule