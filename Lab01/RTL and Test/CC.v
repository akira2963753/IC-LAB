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